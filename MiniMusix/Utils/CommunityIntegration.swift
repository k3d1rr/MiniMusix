import SwiftUI
import AppKit

// CommunityIntegration.swift - GitHub community features
class CommunityIntegration {
    
    static func openGitHubIssues() {
        let url = URL(string: "https://github.com/username/minimusix/issues")!
        NSWorkspace.shared.open(url)
    }
    
    static func openGitHubDiscussions() {
        let url = URL(string: "https://github.com/username/minimusix/discussions")!
        NSWorkspace.shared.open(url)
    }
    
    static func openGitHubReleases() {
        let url = URL(string: "https://github.com/username/minimusix/releases")!
        NSWorkspace.shared.open(url)
    }
    
    static func reportIssue(title: String, body: String) {
        let issueBody = """
        **Issue Description:**
        \(body)

        **System Information:**
        - macOS Version: \(getMacOSVersion())
        - App Version: \(getAppVersion())
        - Installation: Sideloaded from web

        **Steps to Reproduce:**
        1.
        2.
        3.

        **Expected Behavior:**

        **Actual Behavior:**

        **Additional Context:**
        """
        
        // Encode the body for URL
        let encodedBody = issueBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://github.com/username/minimusix/issues/new?title=\(title)&body=\(encodedBody)"
        
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
    
    static func getMacOSVersion() -> String {
        let processInfo = ProcessInfo.processInfo
        let osVersion = processInfo.operatingSystemVersion
        
        return String(format: "%d.%d.%d",
                     osVersion.majorVersion,
                     osVersion.minorVersion,
                     osVersion.patchVersion)
    }
    
    static func getAppVersion() -> String {
        if let infoDict = Bundle.main.infoDictionary,
           let version = infoDict["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
}

// HelpMenuView - SwiftUI view for help menu
struct HelpMenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("MiniMusix Help")
                .font(.headline)
                .padding(.bottom, 8)
            
            Button(action: {
                CommunityIntegration.openGitHubIssues()
            }) {
                HStack {
                    Image(systemName: "exclamationmark.circle")
                    Text("Report Issue")
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                CommunityIntegration.openGitHubDiscussions()
            }) {
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Community Discussions")
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                CommunityIntegration.openGitHubReleases()
            }) {
                HStack {
                    Image(systemName: "arrow.down.circle")
                    Text("Check for Updates")
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .padding(.vertical, 8)
            
            Text("Having issues with media detection?")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                let body = "Please describe the media detection issue you're experiencing."
                CommunityIntegration.reportIssue(title: "Media Detection Issue", body: body)
            }) {
                Text("Get Help")
                    .font(.subheadline)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .frame(width: 250)
    }
}

// AboutView - SwiftUI view for about information
struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "waveform")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.green)
            
            Text("MiniMusix")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Version \(CommunityIntegration.getAppVersion())")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Native macOS miniplayer for system media")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Features:")
                    .font(.headline)
                
                Text("• Universal media monitoring")
                Text("• Dynamic color theming")
                Text("• Floating lyrics viewer")
                Text("• Native macOS integration")
                Text("• Web-based distribution")
            }
            .font(.subheadline)
            
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 400)
    }
}
