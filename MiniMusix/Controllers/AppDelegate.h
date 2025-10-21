#import "AppDelegate.h"
#import "EnhancedMediaDetector.h"
#import "StatusBarController.h"
#import "MediaMonitorModel.h"

@interface AppDelegate ()
@property (strong, nonatomic) EnhancedMediaDetector *mediaDetector;
@property (strong, nonatomic) StatusBarController *statusBarController;
@property (strong, nonatomic) MediaMonitorModel *mediaModel;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Initialize core components
    self.mediaModel = [[MediaMonitorModel alloc] init];
    self.mediaDetector = [[EnhancedMediaDetector alloc] initWithModel:self.mediaModel];
    self.statusBarController = [[StatusBarController alloc] initWithModel:self.mediaModel];
    
    // Start monitoring system media
    [self.mediaDetector startMonitoring];
    
    // Setup permissions
    [self setupPermissions];
}

- (void)setupPermissions {
    // Request Accessibility permissions for media control
    NSDictionary *options = @{(__bridge NSString *)kAXTrustedCheckOptionPrompt: @YES};
    BOOL trusted = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
    
    if (!trusted) {
        NSLog(@"Accessibility permissions not granted. Please enable in System Settings.");
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Clean up resources
    [self.mediaDetector stopMonitoring];
}

@end
