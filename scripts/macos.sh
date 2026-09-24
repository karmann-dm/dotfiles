#!/usr/bin/env bash
# macOS system defaults tuned for a keyboard-first workflow.
# Every line is independent — comment out anything you don't like and re-run.
set -euo pipefail

# ── Keyboard ──────────────────────────────────────────────────────────────────
# Fast key repeat (hold j in vim and it actually moves). Needs logout.
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
# Holding a key repeats it instead of showing the accent picker.
defaults write -g ApplePressAndHoldEnabled -bool false
# Tab moves focus between all controls in dialogs (buttons too).
defaults write -g AppleKeyboardUIMode -int 3
# No smart quotes / dashes / autocorrect — they break code snippets.
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# ── AeroSpace recommendations ─────────────────────────────────────────────────
# One Space spanning all displays (AeroSpace manages its own workspaces).
defaults write com.apple.spaces spans-displays -bool true
# Mission Control groups windows by app — tiny AeroSpace windows are usable.
defaults write com.apple.dock expose-group-apps -bool true
# ctrl+cmd + drag anywhere in a window moves it.
defaults write -g NSWindowShouldDragOnGesture -bool true

# ── Dock ──────────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false   # don't reorder Spaces
defaults write com.apple.dock tilesize -int 40

# ── Finder ────────────────────────────────────────────────────────────────────
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # search current folder
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ── Misc ──────────────────────────────────────────────────────────────────────
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
# Faster window resize animations (Cocoa apps).
defaults write -g NSWindowResizeTime -float 0.001

for app in Dock Finder SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "  ✓ macOS defaults applied (log out & in for keyboard changes)"
