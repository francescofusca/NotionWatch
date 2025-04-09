//  NotionWatch/ViewModels/AudioRecorderViewModel.swift
import Foundation
import SwiftUI
import Combine


class AudioRecorderViewModel: ObservableObject {

    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var playbackTime : TimeInterval = 0 //Tempo di riproduzione
    @Published var transcribedText: String? // Changed to optional String, not tied to Speech
    @Published var isUploading = false
    @Published var uploadProgress: Double = 0.0
    @Published var showingAlert = false
    @Published var alertMessage = ""
    //@Published var showingTextInput = false // Flag to control text input presentation  RIMUOVO


    private var cancellables: Set<AnyCancellable> = []
    private let audioManager: AudioManager
    private let notionService: NotionService

    init(audioManager: AudioManager = AudioManager(), notionService: NotionService = NotionService()) {
        self.audioManager = audioManager
        self.notionService = notionService

        audioManager.$isRecording
            .assign(to: &$isRecording)

        audioManager.$isPlaying
            .assign(to: &$isPlaying)

        audioManager.$recordingDuration
            .assign(to: &$recordingDuration)

        audioManager.$playbackTime
            .assign(to: &$playbackTime)

        // No longer observing currentRecording for transcription

    }
     // MARK: - UI Actions
       func startRecording() {
           audioManager.startRecording()
       }

       func stopRecording() {
           audioManager.stopRecording()
       }

       func deleteRecording(){
           audioManager.deleteRecording()
           transcribedText = nil
       }
       func startPlayback() {
          audioManager.startPlayback()
       }

       func stopPlayback() {
          audioManager.stopPlayback()
       }


    func saveRecording() {
         guard let recording = audioManager.currentRecording else {
             showAlert(message: "Nessuna registrazione da salvare.")
             return
         }

        // Check if we have transcribed text
        guard let text = transcribedText, !text.isEmpty else{
            showAlert(message: "Inserisci una descrizione per la nota")
            return // Do not proceed if no text
        }
         isUploading = true
         uploadProgress = 0.0

         notionService.sendAudioToNotion(recording: recording, transcribedText: transcribedText) { [weak self] result in
             DispatchQueue.main.async {
                 self?.isUploading = false
                 switch result {
                 case .success(let message):
                     self?.showAlert(message: message)
                     self?.audioManager.currentRecording = nil
                     self?.transcribedText = nil
                 case .failure(let error):
                     self?.showAlert(message: "Errore durante l'invio: \(error.localizedDescription)")
                 }
             }
         }
     }

    // MARK: - Text Input, modifico per avere la closure
      func processTranscription(text: String?) {
          self.transcribedText = text // Store the transcribed text
      }

    // MARK: - Helpers
     func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }

    var hasCurrentRecording: Bool {
        audioManager.currentRecording != nil
    }
}
