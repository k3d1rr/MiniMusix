#import <Cocoa/Cocoa.h>
#import "MediaMonitorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatusBarController : NSObject

@property (strong, nonatomic) MediaMonitorModel *mediaModel;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSPopover *popover;

- (instancetype)initWithModel:(MediaMonitorModel *)model;
- (void)statusItemClicked:(NSStatusBarButton *)sender;
- (void)updateStatusBarIcon;

@end

NS_ASSUME_NONNULL_END
