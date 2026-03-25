cask "claude-session-manager" do
  version "0.0.2"
  sha256 "5c7f18c54328a7f749af42d80ec21768fc3d3f2983e1da7077d4c52277329aa5"

  url "https://github.com/murodov20/claude-session-manager-gui/releases/download/v#{version}/ClaudeSessionManager-v#{version}.zip"
  name "Claude Session Manager"
  desc "macOS menu bar app for browsing and resuming Claude Code sessions"
  homepage "https://github.com/murodov20/claude-session-manager-gui"

  depends_on macos: ">= :sonoma"

  app "ClaudeSessionManager.app"

  zap trash: [
    "~/Library/Preferences/com.mmurodov.ClaudeSessionManager.plist",
  ]
end
