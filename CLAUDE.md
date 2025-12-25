# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NotlonWatch is a watchOS application that records audio notes, transcribes them, and uploads them to Notion databases. The project consists of two main components:

1. **watchOS App** (`NotlonWatch Watch App/`) - Swift/SwiftUI Apple Watch application
2. **Node.js Server** (`notion-watch-server/`) - Express.js backend for processing uploads

## Architecture

### watchOS App Structure
- **Models/**: Data models (`AudioRecording.swift`, `UserSettings.swift`)
- **Views/**: SwiftUI views for UI components
- **ViewModels/**: MVVM pattern view models for business logic
- **Services/**: Core services for app functionality
  - `AuthService.swift` - Firebase authentication
  - `AudioManager.swift` - Audio recording and playback
  - `NetworkService.swift` - HTTP requests to backend
  - `NotionService.swift` - Notion API integration

### Key Dependencies
- **Firebase**: Authentication, analytics, storage (configured via `GoogleService-Info.plist`)
- **AVFoundation**: Audio recording and playback
- **Notion API**: Database integration via `@notionhq/client`
- **Cloudinary**: Audio file storage

## Development Commands

### watchOS App
Build and run the app using Xcode:
```bash
# Open project in Xcode
open NotlonWatch.xcodeproj
```

### Backend Server
```bash
cd notion-watch-server

# Install dependencies
npm install

# Start development server
node server.js
```

The server runs on port 3000 by default (configured in `.env`).

## Testing

### watchOS App Tests
```bash
# Run tests in Xcode using Cmd+U or:
xcodebuild test -scheme "NotlonWatch Watch App" -destination 'platform=iOS Simulator,name=iPhone 15'
```

Test files located in:
- `NotlonWatch Watch AppTests/` - Unit tests
- `NotlonWatch Watch AppUITests/` - UI tests

### Backend Tests
Currently no test framework configured. The `package.json` contains placeholder test script.

## Configuration

### Environment Variables (Server)
- `PORT`: Server port (default: 3000)

### Required API Keys
The app requires several API credentials passed from the client:
- Notion API Key and Database ID
- Cloudinary Cloud Name, API Key, and API Secret
- Firebase configuration via `GoogleService-Info.plist`

## Key Integration Points

### Client-Server Communication
The watchOS app communicates with the server via HTTPS POST to `/upload` endpoint at `https://notionwatchserver.onrender.com/upload`. The server:
1. Receives audio files and metadata
2. Uploads audio to Cloudinary
3. Creates entries in Notion database
4. Returns success/failure response

### Audio Workflow
1. User records audio via `AudioRecorderViewModel`
2. Audio transcription happens locally
3. File uploaded via `NetworkService` to backend
4. Backend processes and stores in Notion + Cloudinary

## Important Notes

- The project uses MVVM architecture pattern throughout the watchOS app
- Firebase is configured for authentication and may include other services
- Server expects multipart/form-data uploads with specific field names
- Timeout for network requests is set to 120 seconds
- Italian language is used in debug messages and some UI text