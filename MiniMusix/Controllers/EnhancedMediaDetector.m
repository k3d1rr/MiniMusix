#import "EnhancedMediaDetector.h"
#import <MediaPlayer/MediaPlayer.h>

@interface EnhancedMediaDetector ()
@property (nonatomic) dispatch_queue_t monitoringQueue;
@end

@implementation EnhancedMediaDetector

- (instancetype)initWithModel:(MediaMonitorModel *)model {
    self = [super init];
    if (self) {
        self.mediaModel = model;
        self.isMonitoring = NO;
        self.monitoringQueue = dispatch_queue_create("com.minimusix.mediaMonitoring", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)startMonitoring {
    if (self.isMonitoring) return;
    
    self.isMonitoring = YES;
    
    // Register for MediaRemote notifications
    MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_get_main_queue(), ^(NSDictionary *info) {
        [self handleMediaRemoteNotification:info];
    });
    
    // Get initial state
    [self getCurrentMediaState];
    
    NSLog(@"MiniMusix: Started monitoring system media");
}

- (void)stopMonitoring {
    if (!self.isMonitoring) return;
    
    self.isMonitoring = NO;
    NSLog(@"MiniMusix: Stopped monitoring system media");
}

- (NSDictionary *)getCurrentMediaState {
    __block NSDictionary *currentInfo = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(NSDictionary *info) {
        currentInfo = info;
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC));
    return currentInfo;
}

- (void)handleMediaRemoteNotification:(NSDictionary *)info {
    if (!info || !self.isMonitoring) return;
    
    dispatch_async(self.monitoringQueue, ^{
        NSString *title = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle];
        NSString *artist = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist];
        NSString *album = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum];
        NSNumber *duration = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration];
        NSNumber *elapsedTime = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime];
        NSNumber *playbackRate = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoPlaybackRate];
        
        // Get source app bundle ID
        NSDictionary *clientProperties = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoClientProperties];
        NSString *sourceApp = clientProperties[@"bundleID"] ?: @"Unknown";
        
        // Extract artwork if available
        NSData *artworkData = info[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
        NSString *artworkSrc = @"";
        if (artworkData) {
            NSString *base64Artwork = [artworkData base64EncodedStringWithOptions:0];
            artworkSrc = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", base64Artwork];
        }
        
        NSDictionary *mediaInfo = @{
            @"title": title ?: @"",
            @"artist": artist ?: @"",
            @"album": album ?: @"",
            @"source": sourceApp,
            @"duration": duration ?: @0,
            @"currentTime": elapsedTime ?: @0,
            @"isPlaying": @([playbackRate floatValue] > 0),
            @"artworkSrc": artworkSrc
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateMiniplayerWithUniversalMedia:mediaInfo];
        });
    });
}

- (void)updateMiniplayerWithMediaInfo:(NSDictionary *)info {
    [self updateMiniplayerWithUniversalMedia:info];
}

- (void)updateMiniplayerWithUniversalMedia:(NSDictionary *)mediaInfo {
    if (!mediaInfo) return;
    
    // Update the model on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = mediaInfo[@"title"];
        NSString *artist = mediaInfo[@"artist"];
        NSString *album = mediaInfo[@"album"];
        NSString *source = mediaInfo[@"source"];
        NSNumber *duration = mediaInfo[@"duration"];
        NSNumber *currentTime = mediaInfo[@"currentTime"];
        NSNumber *isPlaying = mediaInfo[@"isPlaying"];
        NSString *artworkSrc = mediaInfo[@"artworkSrc"];
        
        // Update model properties
        self.mediaModel.currentTrack.title = title;
        self.mediaModel.currentTrack.artist = artist;
        self.mediaModel.currentTrack.album = album;
        self.mediaModel.currentTrack.source = source;
        self.mediaModel.audioState.duration = [duration doubleValue];
        self.mediaModel.audioState.currentTime = [currentTime doubleValue];
        self.mediaModel.isPlaying = [isPlaying boolValue];
        self.mediaModel.artworkSrc = artworkSrc;
        
        // Calculate progress
        [self.mediaModel calculateProgress];
        
        NSLog(@"MiniMusix: Updated media info - %@ by %@ (Source: %@)", title, artist, source);
    });
}

@end
