import SwiftUI
import AppKit

// Lyrics Line Model
struct LyricLine: Identifiable {
    let id = UUID()
    let text: String
    let timestamp: TimeInterval
    var isActive: Bool = false
}

// LyricsViewer - Right-side floating lyrics panel
struct LyricsViewer: View {
    @State private var isVisible = false
    @State private var lyrics: [LyricLine] = []
    @State private var currentLineIndex = 0
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    if isVisible {
                        VStack(alignment: .center, spacing: 20) {
                            // Header
                            Text("Lyrics")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                            
                            // Lyrics Content
                            ScrollView {
                                VStack(alignment: .center, spacing: 16) {
                                    ForEach(Array(lyrics.enumerated()), id: \.element.id) { index, line in
                                        Text(line.text)
                                            .font(.system(size: index == currentLineIndex ? 24 : 18, 
                                                        weight: index == currentLineIndex ? .semibold : .medium))
                                            .foregroundColor(index == currentLineIndex ? .white : .white.opacity(0.7))
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: 280)
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .opacity(line.isActive ? 1.0 : 0.6)
                                            .scaleEffect(index == currentLineIndex ? 1.05 : 1.0)
                                    }
                                }
                                .frame(maxWidth: 300)
                            }
                            .frame(maxHeight: 300)
                        }
                        .frame(width: 320, height: 400)
                        .background(
                            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                                .cornerRadius(20)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(radius: 20)
                        .offset(x: dragOffset.width + -20, y: dragOffset.height)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { _ in
                                    dragOffset = .zero
                                }
                        )
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                    
                    // Hover area for triggering visibility
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 8, height: geometry.size.height * 0.6)
                        .onHover { hovering in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isVisible = hovering
                            }
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // Function to load lyrics for current track
    func loadLyricsForTrack(_ track: Track) {
        // This would integrate with a lyrics API or local lyrics database
        // For now, using placeholder lyrics
        lyrics = [
            LyricLine(text: "♪ Instrumental ♪", timestamp: 0),
            LyricLine(text: "This is a sample lyrics line", timestamp: 10),
            LyricLine(text: "Another line of lyrics here", timestamp: 20),
            LyricLine(text: "And here's the chorus", timestamp: 30),
            LyricLine(text: "More lyrics continue...", timestamp: 40)
        ]
        currentLineIndex = 0
    }
    
    // Function to update current line based on playback time
    func updateCurrentLine(_ currentTime: TimeInterval) {
        for (index, line) in lyrics.enumerated() {
            if currentTime >= line.timestamp && 
               (index == lyrics.count - 1 || currentTime < lyrics[index + 1].timestamp) {
                if currentLineIndex != index {
                    currentLineIndex = index
                    // Auto-scroll to current line if needed
                    withAnimation {
                        // Scroll logic would go here
                    }
                }
                break
            }
        }
    }
}

// Visual Effect View (reused from MiniPlayerView)
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        return visualEffectView
    }
    
    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}
