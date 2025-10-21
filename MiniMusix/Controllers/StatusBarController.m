#import "StatusBarController.h"
#import "MiniPlayerViewController.h"

@interface StatusBarController ()
@property (strong, nonatomic) MiniPlayerViewController *miniPlayerViewController;
@property (nonatomic) BOOL isShowingPopover;
@end

@implementation StatusBarController

- (instancetype)initWithModel:(MediaMonitorModel *)model {
    self = [super init];
    if (self) {
        self.mediaModel = model;
        self.isShowingPopover = NO;
        [self setupStatusBar];
        [self setupPopover];
        [self observeModelChanges];
    }
    return self;
}

- (void)setupStatusBar {
    self.statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSStatusItemSquareLength];
    
    if (self.statusItem.button) {
        // Set initial icon
        NSImage *iconImage = [NSImage imageWithSystemSymbolName:@"waveform" accessibilityDescription:@"MiniMusix"];
        self.statusItem.button.image = iconImage;
        self.statusItem.button.image.template = YES;
        
        // Setup click action
        self.statusItem.button.action = @selector(statusItemClicked:);
        self.statusItem.button.target = self;
        
        // Enable highlighting
        self.statusItem.button.sendActionOnDown = NO;
    }
}

- (void)setupPopover {
    self.miniPlayerViewController = [[MiniPlayerViewController alloc] initWithModel:self.mediaModel];
    
    self.popover = [[NSPopover alloc] init];
    self.popover.contentViewController = self.miniPlayerViewController;
    self.popover.behavior = NSPopoverBehaviorTransient;
    self.popover.animates = YES;
    
    // Style the popover
    self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
}

- (void)statusItemClicked:(NSStatusBarButton *)sender {
    if (self.isShowingPopover) {
        [self.popover performClose:sender];
        self.isShowingPopover = NO;
    } else {
        // Update popover size based on content
        [self updatePopoverSize];
        
        [self.popover showRelativeToRect:sender.bounds
                                  ofView:sender
                           preferredEdge:NSRectEdgeMaxY];
        self.isShowingPopover = YES;
    }
}

- (void)updatePopoverSize {
    // Calculate size based on content
    CGFloat width = 400;
    CGFloat height = 120;
    
    self.popover.contentSize = CGSizeMake(width, height);
}

- (void)updateStatusBarIcon {
    if (!self.statusItem.button) return;
    
    NSString *symbolName = self.mediaModel.isPlaying ? @"waveform" : @"waveform";
    
    NSImage *iconImage = [NSImage imageWithSystemSymbolName:symbolName 
                                         accessibilityDescription:@"MiniMusix"];
    self.statusItem.button.image = iconImage;
    self.statusItem.button.image.template = YES;
}

- (void)observeModelChanges {
    // Observe changes to update the status bar icon
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(handleMediaStateChange)
                                               name:@"MediaStateChanged"
                                             object:nil];
}

- (void)handleMediaStateChange {
    [self updateStatusBarIcon];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
