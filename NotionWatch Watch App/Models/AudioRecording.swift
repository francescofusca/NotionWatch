//  NotionWatch/Models/AudioRecording.swift
import Foundation

struct AudioRecording {
    let fileURL: URL
    let createdAt: Date
    var transcribedText: String? // Optional, as transcription may not be available
}
