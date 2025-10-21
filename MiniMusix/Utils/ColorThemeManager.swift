import SwiftUI
import AppKit

// ColorThemeManager - Current React color logic in macOS
class ColorThemeManager: ObservableObject {
    @Published var primaryColor: Color = Color(hex: "#1db954")
    @Published var secondaryColor: Color = Color(hex: "#1ed760")
    @Published var backgroundColor: Color = Color(hex: "#121212")
    
    private var currentColors: [String] = ["#1db954", "#1ed760"]
    
    func extractColors(from image: NSImage) async -> [String] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let colors = self.extractColorsSync(from: image)
                continuation.resume(returning: colors)
            }
        }
    }
    
    private func extractColorsSync(from image: NSImage) -> [String] {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return self.currentColors
        }
        
        let bitmap = NSBitmapImageRep(cgImage: cgImage)
        var colorCounts: [String: Int] = [:]
        
        // Sample pixels across the image
        let sampleStep: Int = 20
        for x in stride(from: 0, to: Int(bitmap.size.width), by: sampleStep) {
            for y in stride(from: 0, to: Int(bitmap.size.height), by: sampleStep) {
                if let color = bitmap.colorAt(x: x, y: y) {
                    // Skip very dark or very light colors
                    let brightness = (color.redComponent + color.greenComponent + color.blueComponent) / 3
                    if brightness > 0.1 && brightness < 0.9 {
                        let rgbColor = String(format: "rgb(%.0f, %.0f, %.0f)", 
                                            color.redComponent * 255, 
                                            color.greenComponent * 255, 
                                            color.blueComponent * 255)
                        colorCounts[rgbColor] = (colorCounts[rgbColor] ?? 0) + 1
                    }
                }
            }
        }
        
        // Sort colors by frequency and return top 3
        let sortedColors = colorCounts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
        
        let colors = Array(sortedColors)
        if colors.isEmpty {
            return self.currentColors
        }
        
        // Update current colors
        DispatchQueue.main.async {
            self.currentColors = colors
            if let firstColor = colors.first {
                self.primaryColor = Color(hex: firstColor)
            }
            if colors.count > 1 {
                self.secondaryColor = Color(hex: colors[1])
            }
        }
        
        return colors
    }
    
    func getCurrentColors() -> [String] {
        return currentColors
    }
    
    func updateTheme(with colors: [String]) {
        self.currentColors = colors
        if let firstColor = colors.first {
            self.primaryColor = Color(hex: firstColor)
        }
        if colors.count > 1 {
            self.secondaryColor = Color(hex: colors[1])
        }
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
