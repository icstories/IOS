//
//  CameraEngine.m
//  Encoder Demo
//
//  Created by Geraint Davies on 19/02/2013.
//  Copyright (c) 2013 GDCL http://www.gdcl.co.uk/license.htm
//

#import "CameraEngine.h"
#import "VideoEncoder.h"
#import "AssetsLibrary/ALAssetsLibrary.h"

static CameraEngine* theEngine;

@interface CameraEngine  () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureSession* _session;
    AVCaptureVideoPreviewLayer* _preview;
    dispatch_queue_t _captureQueue;
    AVCaptureConnection* _audioConnection;
    AVCaptureConnection* _videoConnection;
    
    VideoEncoder* _encoder;
    BOOL _isCapturing;
    BOOL _isPaused;
    BOOL _discont;
    int _currentFile;
    CMTime _timeOffset;
    CMTime _lastVideo;
    CMTime _lastAudio;
    
    int _cx;
    int _cy;
    int _channels;
    Float64 _samplerate;
}
@end


@implementation CameraEngine

@synthesize isCapturing = _isCapturing;
@synthesize isPaused = _isPaused;

+ (void) initialize
{
    // test recommended to avoid duplicate init via subclass
    if (self == [CameraEngine class])
    {
        theEngine = [[CameraEngine alloc] init];
    }
}

+ (CameraEngine*) engine
{
    return theEngine;
}

- (void) startup:(NSString *)preset
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
        {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                NSLog(@"permission : %d", granted);
            }];
        }
    }
    
    if (_session == nil)
    {

        self.isCapturing = NO;
        self.isPaused = NO;
        _currentFile = 0;
        _discont = NO;
        
        // create capture device with video input
        
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:preset];
        //AVCaptureDevice* backCamera ;//= [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; dj
        
        AVCaptureDeviceInput* input;
        //get video camera list
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        if (devices>0)
        {
            for (AVCaptureDevice *device in devices)
            {
                if ([device position] == AVCaptureDevicePositionBack)
                {
                    input=[AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
                    break;
                }
            }
            if (!input)//only for front camera
            {
               input=[AVCaptureDeviceInput deviceInputWithDevice:(AVCaptureDevice *)[devices objectAtIndex:0] error:nil];
                
            }
        }
        //add associate video input to session dj
       // AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
        [_session addInput:input];
        
        // audio input from default mic
        NSArray *micDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
//#error work here (AVCaptureDevice *)[micDevices objectAtIndex:0];//
        AVCaptureDevice* mic =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        NSError *error;
        //to get permission for use microphone 
        
        AVCaptureDeviceInput* micinput = [AVCaptureDeviceInput deviceInputWithDevice:mic error:&error];
       // NSLog(@"error for mic =%@",error.localizedDescription);
        if (error)
        {
            
            [[[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"%@ Check app privacy in device setting.",error.localizedFailureReason] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
           return;
        }else
        {
             [_session addInput:micinput];
        }
        
        
        // create an output for YUV output with self as delegate
        _captureQueue = dispatch_queue_create("uk.co.gdcl.cameraengine.capture", DISPATCH_QUEUE_SERIAL);
        AVCaptureVideoDataOutput* videoout = [[AVCaptureVideoDataOutput alloc] init];
        [videoout setSampleBufferDelegate:self queue:_captureQueue];
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        videoout.videoSettings = setcapSettings;
        [_session addOutput:videoout];
        _videoConnection = [videoout connectionWithMediaType:AVMediaTypeVideo];


        
        //Set frame rate (if requried)

        
        if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0)
        {
            CMTimeShow(_videoConnection.videoMinFrameDuration);
            CMTimeShow(_videoConnection.videoMaxFrameDuration);
            if (_videoConnection.supportsVideoMinFrameDuration)
                _videoConnection.videoMinFrameDuration = CMTimeMake(1, 20);
            if (_videoConnection.supportsVideoMaxFrameDuration)
                _videoConnection.videoMaxFrameDuration = CMTimeMake(1, 20);
            
            CMTimeShow(_videoConnection.videoMinFrameDuration);
            CMTimeShow(_videoConnection.videoMaxFrameDuration);
        }

        NSDictionary* actual = videoout.videoSettings;
        _cy = [[actual objectForKey:@"Height"] integerValue];
        _cx = [[actual objectForKey:@"Width"] integerValue];
        
        AVCaptureAudioDataOutput* audioout = [[AVCaptureAudioDataOutput alloc] init];
        [audioout setSampleBufferDelegate:self queue:_captureQueue];
        [_session addOutput:audioout];
        _audioConnection = [audioout connectionWithMediaType:AVMediaTypeAudio];
        // for audio, we want the channels and sample rate, but we can't get those from audioout.audiosettings on ios, so
        // we need to wait for the first sample
        
        // start capture and a preview layer
        [_session startRunning];

        _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    [_session setSessionPreset:preset];
    
}
//dj
//change for single front camera
// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}
- (void) startCapture
{
    @synchronized(self)
    {
        if (!self.isCapturing)
        {
            // create the encoder once we have the audio params
            _encoder = nil;
            self.isPaused = NO;
            _discont = NO;
            _timeOffset = CMTimeMake(0, 0);
            self.isCapturing = YES;
            
            UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
            
            AVCaptureVideoOrientation result = deviceOrientation;
            if ( deviceOrientation == UIDeviceOrientationLandscapeLeft)
                result = AVCaptureVideoOrientationLandscapeRight;
            else if ( deviceOrientation == UIDeviceOrientationLandscapeRight)
                result = AVCaptureVideoOrientationLandscapeLeft;
            
            [_videoConnection setVideoOrientation:result];
        }
    }
}

- (void) stopCapture
{
    @synchronized(self)
    {
        if (self.isCapturing)
        {
            NSString* filename = @"capture1.mov";
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            NSURL* url = [NSURL fileURLWithPath:path];
            _currentFile++;
            
            // serialize with audio and video capture
            
            self.isCapturing = NO;
            dispatch_async(_captureQueue, ^{
                [_encoder finishWithCompletionHandler:^{
                    self.isCapturing = NO;
                    _encoder = nil;
                 //   ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

                    
                    NSData *videoData = [NSData dataWithContentsOfURL:url];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mov"];
                    [videoData writeToFile:tempPath atomically:NO];

                    NSURL *vedioURL = [NSURL fileURLWithPath:tempPath];
                    AVAsset *asset = [AVAsset assetWithURL:vedioURL];
                    CMTime thumbnailTime = [asset duration];
                    thumbnailTime.value = 0;
                    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
                    NSData* pictureData = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
                    [[NSUserDefaults standardUserDefaults] setObject:pictureData forKey:@"ImageData"];
                    CGImageRelease(imageRef);
                    
                    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"UPLOAD_USERINTERACTION"];


                }];
            });
        }
    }
}

- (void) pauseCapture
{
    @synchronized(self)
    {
        if (self.isCapturing)
        {
            self.isPaused = YES;
            _discont = YES;
        }
    }
}

- (void) resumeCapture
{
    @synchronized(self)
    {
        if (self.isPaused)
        {
            self.isPaused = NO;
        }
    }
}

- (CMSampleBufferRef) adjustTime:(CMSampleBufferRef) sample by:(CMTime) offset
{
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++)
    {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}

- (void) setAudioFormat:(CMFormatDescriptionRef) fmt
{
    const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
    _samplerate = asbd->mSampleRate;
    _channels = asbd->mChannelsPerFrame;
    
}

- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    BOOL bVideo = YES;
    @synchronized(self)
    {
        if (!self.isCapturing  || self.isPaused)
        {
            return;
        }
        if (connection != _videoConnection)
        {
            bVideo = NO;
        }
        if ((_encoder == nil) && !bVideo)
        {
            CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
            [self setAudioFormat:fmt];
            NSString* filename = @"capture1.mov";
            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            _encoder = [VideoEncoder encoderForPath:path Height:_cy width:_cx channels:_channels samples:_samplerate];
        }
        if (_discont)
        {
            if (bVideo)
            {
                return;
            }
            _discont = NO;
            // calc adjustment
            CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            CMTime last = bVideo ? _lastVideo : _lastAudio;
            if (last.flags & kCMTimeFlags_Valid)
            {
                if (_timeOffset.flags & kCMTimeFlags_Valid)
                {
                    pts = CMTimeSubtract(pts, _timeOffset);
                }
                CMTime offset = CMTimeSubtract(pts, last);

                
                // this stops us having to set a scale for _timeOffset before we see the first video time
                if (_timeOffset.value == 0)
                {
                    _timeOffset = offset;
                }
                else
                {
                    _timeOffset = CMTimeAdd(_timeOffset, offset);
                }
            }
            _lastVideo.flags = 0;
            _lastAudio.flags = 0;
        }
        
        // retain so that we can release either this or modified one
        CFRetain(sampleBuffer);
        
        if (_timeOffset.value > 0)
        {
            CFRelease(sampleBuffer);
            sampleBuffer = [self adjustTime:sampleBuffer by:_timeOffset];
        }
        
        // record most recent time so we know the length of the pause
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
        if (dur.value > 0)
        {
            pts = CMTimeAdd(pts, dur);
        }
        if (bVideo)
        {
            _lastVideo = pts;
        }
        else
        {
            _lastAudio = pts;
        }
    }

    // pass frame to encoder
    [_encoder encodeFrame:sampleBuffer isVideo:bVideo];
    CFRelease(sampleBuffer);
}

- (void) shutdown
{
    if (_session)
    {
        [_session stopRunning];
        _session = nil;
    }
    [_encoder finishWithCompletionHandler:^{
    }];
}


- (AVCaptureVideoPreviewLayer*) getPreviewLayer
{
    return _preview;
}

@end
