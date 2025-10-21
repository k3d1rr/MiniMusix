#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Track : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *artworkUrl;
- (instancetype)init;
@end

@interface AudioState : NSObject
@property (nonatomic) double duration;
@property (nonatomic) double currentTime;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) float volume;
- (instancetype)init;
@end

@interface MediaMonitorModel : NSObject
@property (nonatomic, strong) Track *currentTrack;
@property (nonatomic, strong) AudioState *audioState;
@property (nonatomic, copy) NSArray<NSString *> *colors;
@property (nonatomic) double progress;
@property (nonatomic, copy) NSString *artworkSrc;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isVisible;

- (instancetype)init;
- (void)calculateProgress;
- (void)playPause;
- (void)nextTrack;
- (void)previousTrack;
- (void)seekToPosition:(double)position;
- (void)updateColorsFromImage:(NSImage *)image;
@end

NS_ASSUME_NONNULL_END
