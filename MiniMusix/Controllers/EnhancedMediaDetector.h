#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MediaMonitorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnhancedMediaDetector : NSObject

@property (strong, nonatomic) MediaMonitorModel *mediaModel;
@property (nonatomic) BOOL isMonitoring;

- (instancetype)initWithModel:(MediaMonitorModel *)model;
- (void)startMonitoring;
- (void)stopMonitoring;
- (NSDictionary *)getCurrentMediaState;
- (void)updateMiniplayerWithMediaInfo:(NSDictionary *)info;
- (void)updateMiniplayerWithUniversalMedia:(NSDictionary *)mediaInfo;

@end

NS_ASSUME_NONNULL_END
