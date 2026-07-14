# Smart Campus Assistant

A SwiftUI iPhone app that helps students navigate campus life — schedules, dining, buildings, events, and a built-in assistant.

## Requirements

- macOS with **Xcode 15+**
- iOS **17.0+** (iPhone)
- Apple Developer account (for running on a physical device)

> **Note:** iOS apps must be built on a Mac with Xcode. You can edit Swift source files on Windows, but building and running requires Xcode.

## Getting Started

1. Copy or clone this folder to your Mac.
2. Open `SmartCampusAssistant.xcodeproj` in Xcode.
3. Select an iPhone simulator (e.g. iPhone 15).
4. Press **⌘R** to build and run.

## Project Structure

```
SmartCampusAssistant/
├── SmartCampusAssistantApp.swift   # App entry point
├── App/                            # Root navigation
├── Models/                         # Data models
├── ViewModels/                     # MVVM view models
├── Views/                          # SwiftUI screens
│   ├── Home/
│   ├── Schedule/
│   ├── Map/
│   ├── Dining/
│   └── Assistant/
├── Theme/                          # Colors and styling
└── Assets.xcassets/                # App icon and accent color
```

## Features (v1 scaffold)

| Tab | Description |
|-----|-------------|
| **Home** | Greeting, upcoming classes, featured events |
| **Schedule** | Full daily class list |
| **Map** | Searchable campus buildings |
| **Dining** | Open/closed status and menu highlights |
| **Assistant** | Chat-style campus Q&A (local rules for now) |

Sample data is used throughout so the app runs without a backend.

## Architecture

- **SwiftUI** for all UI
- **MVVM** — views observe `@StateObject` view models
- **iOS 17+** APIs (`NavigationStack`, `ContentUnavailableView`, etc.)

## Next Steps

- Connect to a real campus API or student portal
- Add MapKit for an interactive campus map
- Replace rule-based assistant with an AI backend
- Add push notifications for class reminders
