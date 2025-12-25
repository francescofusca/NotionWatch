# NotlonWatch 👁️

**NotlonWatch** is an open-source Apple Watch application that allows you to record audio notes, transcribe them (optional), and automatically save them to a Notion database via a secure middleware server. It supports uploading audio files to Cloudinary and linking them directly in your Notion pages.

![Banner](PLACEHOLDER_BANNER_IMAGE_HERE)

## 🚀 Features

*   **Voice Recording:** Record high-quality audio directly from your Apple Watch.
*   **Notion Integration:** Automatically creates a new page in your specified Notion database.
*   **Cloudinary Storage:** Uploads audio files to your Cloudinary account and embeds the link in Notion.
*   **Text Transcription:** Add a text description or transcription to your audio note (supports dictation and QWERTY keyboard on supported models).
*   **Secure:** Sensitive API keys are stored locally on the device (UserDefaults) and never hardcoded.
*   **Middleware Server:** Includes a lightweight Node.js Express server to handle secure communication between the Watch and third-party APIs.

## 📱 Screenshots

| Home Screen | Recording | Settings | Notion Result |
|:---:|:---:|:---:|:---:|
| ![Home](PLACEHOLDER_HOME_IMAGE) | ![Recording](PLACEHOLDER_RECORDING_IMAGE) | ![Settings](PLACEHOLDER_SETTINGS_IMAGE) | ![Notion](PLACEHOLDER_NOTION_IMAGE) |

## 🛠️ Architecture

The project consists of two parts:
1.  **Watch App (Swift):** The client application running on watchOS.
2.  **Server (Node.js):** A middleware server that receives the audio and credentials, uploads to Cloudinary, and updates Notion.

## 📋 Prerequisites

Before running the app, you need accounts for:
*   **Notion:** Create an internal integration and share a database with it.
*   **Cloudinary:** Get your Cloud Name, API Key, and API Secret.
*   **Server Hosting:** A place to host the Node.js server (e.g., Render, Heroku, or a local machine).

## ⚙️ Setup Guide

### 1. Server Setup (Backend)

The watch app cannot talk directly to Notion/Cloudinary securely without exposing logic, so a simple server is required.

1.  Navigate to the `notion-watch-server` folder.
2.  Install dependencies:
    ```bash
    npm install
    ```
3.  (Optional for local testing) Create a `.env` file based on `.env.example` if you want to hardcode server-side defaults (not recommended for public instances).
4.  Deploy this folder to a hosting provider like **Render.com** (it's free and easy).
    *   **Build Command:** `npm install`
    *   **Start Command:** `node server.js`
5.  **Important:** Copy your deployed server URL (e.g., `https://your-app.onrender.com/upload`).
6.  Open `NotlonWatch Watch App/AppConfig.swift` in Xcode and paste your URL into `serverURL`.

### 2. Watch App Setup (Frontend)

1.  Open `NotlonWatch.xcodeproj` in Xcode.
2.  Navigate to **NotlonWatch Watch App > AppConfig.swift** and ensure your server URL is correct.
3.  **Firebase Setup (Important):**
    *   This app uses Firebase Auth. You must add your own `GoogleService-Info.plist` to the root of the `NotlonWatch Watch App` folder.
    *   Go to the Firebase Console, create a project, download the plist, and drag it into Xcode (ensure "Add to targets" is checked for the Watch App).
4.  Build and Run on your Simulator or Apple Watch.

### 3. App Configuration (On Device)

Once the app is running on your watch:
1.  Tap the **Settings** (Gear icon) button.
2.  Enter your credentials:
    *   **Notion API Key** (from Notion Developers)
    *   **Notion Database ID** (from your database URL)
    *   **Cloudinary Cloud Name, API Key, API Secret**
3.  Toggle "Enable Transcription" if desired.
4.  Tap **Save**. The main button will turn **Red**, indicating you are ready to record!

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*Created by FF9*
