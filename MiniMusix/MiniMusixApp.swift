import SwiftUI
import AppKit

@main
struct MiniMusixApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var mediaModel = MediaMonitorModel()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize the status bar controller
        statusBarController = StatusBarController(model: mediaModel)
        
        // Setup window to prevent app from terminating
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.level = .floating
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.ignoresMouseEvents = true
    }
}

// ObservableObject wrapper for MediaMonitorModel to use with SwiftUI
class ObservableMediaMonitorModel: ObservableObject {
    @Published var model: MediaMonitorModel
    
    init(_ model: MediaMonitorModel) {
        self.model = model
    }
    
    // Proxy properties for SwiftUI bindings
    var currentTrack: Track { model.currentTrack }
    var audioState: AudioState { model.audioState }
    var colors: [String] { model.colors }
    var progress: Double { model.progress }
    var artworkSrc: String { model.artworkSrc }
    var isPlaying: Bool { model.isPlaying }
    var isVisible: Bool { model.isVisible }
}
