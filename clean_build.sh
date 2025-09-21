#!/bin/bash

# Nome progetto e scheme
PROJECT_NAME="NotionWatch"
SCHEME_NAME="NotionWatch Watch App"
BUNDLE_ID="com.ff9.prova2.NotionWatch.watchkitapp"  # Sostituisci con il bundle identifier della tua Watch app

# Cancella DerivedData specifico del progetto
rm -rf ~/Library/Developer/Xcode/DerivedData/$PROJECT_NAME-*

# Clean + build
xcodebuild -scheme "$SCHEME_NAME" -project "$PROJECT_NAME.xcodeproj" -destination "platform=watchOS Simulator,name=Apple Watch Series 11 (46mm)" clean build | xcbeautify

# Trova UDID del simulatore Apple Watch Series 11 (46mm)
WATCH_UDID=$(xcrun simctl list devices | grep "Apple Watch Series 11 (46mm) (" | grep -oE "[0-9A-F\-]{36}" | head -n 1)

if [ ! -z "$WATCH_UDID" ]; then
    # Boot simulatore se non già acceso
    xcrun simctl boot "$WATCH_UDID" 2>/dev/null
    open -a Simulator

    # Percorso della build della watch app
    APP_PATH=~/Library/Developer/Xcode/DerivedData/$PROJECT_NAME-dvmelyjmfzwlfnbqvzzftfxglhbu/Build/Products/Debug-watchsimulator/$PROJECT_NAME Watch App.app

    # Installa e lancia l’app sul simulatore
    xcrun simctl install "$WATCH_UDID" "$APP_PATH"
    xcrun simctl launch "$WATCH_UDID" "$BUNDLE_ID"

    echo "Simulatore Apple Watch avviato con l'app aggiornata"
else
    echo "Simulatore Apple Watch Series 11 non trovato"
fi

