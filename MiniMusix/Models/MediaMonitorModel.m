#import "MediaMonitorModel.h"
#import <AppKit/AppKit.h>

@implementation Track

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"";
        _artist = @"";
        _album = @"";
        _source = @"";
        _artworkUrl = @"";
    }
    return self;
}

@end

@implementation AudioState

- (instancetype)init {
    self = [super init];
    if (self) {
        _duration = 0.0;
        _currentTime = 0.0;
        _isPlaying = NO;
        _volume = 1.0;
    }
    return self;
}

@end

@implementation MediaMonitorModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentTrack = [[Track alloc] init];
        _audioState = [[AudioState alloc] init];
        _colors = @[@"#1db954", @"#1ed760"];
        _progress = 0.0;
        _artworkSrc = @"";
        _isPlaying = NO;
        _isVisible = NO;
    }
    return self;
}

- (void)calculateProgress {
    if (self.audioState.duration > 0) {
        self.progress = MAX(0, MIN(100, (self.audioState.currentTime / self.audioState.duration) * 100));
    } else {
        self.progress = 0.0;
    }
}

- (void)playPause {
    self.isPlaying = !self.isPlaying;
    self.audioState.isPlaying = self.isPlaying;
    
    // Send media control command
    if (self.isPlaying) {
        MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
    } else {
        MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
    }
}

- (void)nextTrack {
    MRMediaRemoteSendCommand(kMRNextTrack, nil);
}

- (void)previousTrack {
    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
}

- (void)seekToPosition:(double)position {
    double newTime = (position / 100.0) * self.audioState.duration;
    self.audioState.currentTime = newTime;
    
    // Send seek command
    NSDictionary *seekCommand = @{
        (__bridge NSString *)kMRMediaRemoteCommandInfoTime: @(newTime)
    };
    MRMediaRemoteSendCommand(kMRSeekForward, seekCommand);
}

- (void)updateColorsFromImage:(NSImage *)image {
    if (!image) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary<NSString *, NSNumber *> *colorCounts = [NSMutableDictionary dictionary];
        
        // Get CGImage for processing
        CGImageRef cgImage = [image CGImageForProposedRect:nil context:nil hints:nil];
        if (!cgImage) return;
        
        NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
        if (!bitmap) return;
        
        // Sample pixels to extract dominant colors
        for (NSUInteger x = 0; x < bitmap.pixelsWide; x += 10) {
            for (NSUInteger y = 0; y < bitmap.pixelsHigh; y += 10) {
                NSColor *color = [bitmap colorAtX:x y:y];
                if (color) {
                    NSString *rgbColor = [NSString stringWithFormat:@"rgb(%.0f, %.0f, %.0f)",
                                        color.redComponent * 255,
                                        color.greenComponent * 255,
                                        color.blueComponent * 255];
                    
                    colorCounts[rgbColor] = @([colorCounts[rgbColor] integerValue] + 1);
                }
            }
        }
        
        // Sort colors by frequency
        NSArray *sortedColors = [colorCounts keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            return [obj2 compare:obj1];
        }];
        
        NSArray *topColors = [sortedColors subarrayWithRange:NSMakeRange(0, MIN(3, sortedColors.count))];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.colors = topColors;
        });
    });
}

@end
