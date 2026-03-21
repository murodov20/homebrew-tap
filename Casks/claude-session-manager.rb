cask "claude-session-manager" do
  version "0.0.1"
  sha256 "ecc74c1ba9d4434480b5d669c16a41bf37ebea9f5abcbf078e8b7c3998dc0c4e"

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
