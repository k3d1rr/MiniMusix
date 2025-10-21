#import "MiniPlayerViewController.h"
#import "MediaMonitorModel.h"

@interface MiniPlayerViewController ()
@property (strong, nonatomic) NSView *swiftUIView;
@end

@implementation MiniPlayerViewController

- (instancetype)initWithModel:(MediaMonitorModel *)model {
    self = [super init];
    if (self) {
        self.mediaModel = model;
        [self setupSwiftUIView];
    }
    return self;
}

- (void)setupSwiftUIView {
    if (@available(macOS 10.15, *)) {
        // This will be replaced with actual SwiftUI view
        self.swiftUIView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 120)];
        self.view = self.swiftUIView;
    }
}

- (void)loadView {
    self.view = self.swiftUIView;
}

@end
