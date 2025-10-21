import SwiftUI
import AppKit

// Visual Effect View for glass morphism
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

// Wave Animation View
struct WaveAnimationView: View {
    @State private var phase: CGFloat = 0
    let color: Color
    
    var body: some View {
        TimelineView(.animation) { _ in
            Canvas { context, size in
                let path = Path { path in
                    path.move(to: CGPoint(x: 0, y: size.height / 2))
                    
                    for x in stride(from: 0, to: size.width, by: 2) {
                        let y = sin((x / size.width) * 4 * .pi + phase) * 10 + size.height / 2
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                
                context.stroke(path, with: .color(color), lineWidth: 2)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = 2 * .pi
            }
        }
    }
}

// Progress Bar Component
struct ProgressBar: View {
    @Binding var progress: Double
    let primaryColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(primaryColor)
                    .frame(width: geometry.size.width * (progress / 100), height: 4)
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }
}

// MiniPlayerView - Main SwiftUI Component
struct MiniPlayerView: View {
    @EnvironmentObject private var mediaModel: MediaMonitorModel
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 16) {
            artworkSection
            trackInfoSection
            controlsSection
            waveAnimationSection
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .cornerRadius(20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(isHovering ? 0.2 : 0.1), lineWidth: 1)
        )
        .shadow(radius: 20)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .gesture(
            DragGesture()
                .onChanged { _ in }
                .onEnded { _ in }
        )
    }
    
    private var artworkSection: some View {
        Group {
            if let artworkUrl = mediaModel.artworkSrc, !artworkUrl.isEmpty {
                AsyncImage(url: URL(string: artworkUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 56, height: 56)
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 56, height: 56)
            }
        }
    }
    
    private var trackInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(mediaModel.currentTrack.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(mediaModel.currentTrack.artist)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
            
            ProgressBar(progress: $mediaModel.progress, primaryColor: Color(hex: mediaModel.colors.first ?? "#1db954"))
                .frame(width: 200)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var controlsSection: some View {
        HStack(spacing: 12) {
            Button(action: {
                mediaModel.previousTrack()
            }) {
                Image(systemName: "backward.end.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                mediaModel.playPause()
            }) {
                Image(systemName: mediaModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                mediaModel.nextTrack()
            }) {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var waveAnimationSection: some View {
        WaveAnimationView(color: Color(hex: mediaModel.colors.first ?? "#1db954"))
            .frame(width: 60, height: 40)
            .opacity(mediaModel.isPlaying ? 1.0 : 0.3)
    }
}

// Color extension for hex strings
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
