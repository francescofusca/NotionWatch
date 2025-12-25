//  NotlonWatch/ViewModels/AudioRecorderViewModel.swift
import Foundation
import SwiftUI
import Combine
import WatchKit

class AudioRecorderViewModel: ObservableObject {

    @Published var isRecording = false
    @Published var isPaused = false
    @Published var isPlaying = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var playbackTime: TimeInterval = 0
    @Published var transcribedText: String?
    @Published var isUploading = false
    @Published var uploadProgress: Double = 0.0
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var recordingState: RecordingState = .idle
    @Published var lastActivity = Date()

    // Nuovi stati per migliorare l'UX
    enum RecordingState: Equatable {
        case idle
        case preparing
        case recording
        case paused
        case stopping
        case processing
        case completed
        case failed(String)

        static func == (lhs: RecordingState, rhs: RecordingState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle),
                 (.preparing, .preparing),
                 (.recording, .recording),
                 (.paused, .paused),
                 (.stopping, .stopping),
                 (.processing, .processing),
                 (.completed, .completed):
                return true
            case (.failed(let lhsMessage), .failed(let rhsMessage)):
                return lhsMessage == rhsMessage
            default:
                return false
            }
        }
    }


    private var cancellables: Set<AnyCancellable> = []
    private let audioManager: AudioManager
    private let notionService: NotionService

    init(audioManager: AudioManager = AudioManager(), notionService: NotionService = NotionService()) {
        self.audioManager = audioManager
        self.notionService = notionService

        audioManager.$isRecording
            .assign(to: &$isRecording)

        audioManager.$isPaused
            .assign(to: &$isPaused)

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
        recordingState = .preparing
        lastActivity = Date()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.recordingState = .recording
            self.audioManager.startRecording()
            self.hapticFeedback(.start)
        }
    }

    func stopRecording() {
        recordingState = .stopping
        audioManager.stopRecording()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.recordingState = .processing
            self.handlePostRecordingProcessing()
        }
    }

    private func handlePostRecordingProcessing() {
        let enableTranscription = UserDefaults.standard.object(forKey: "EnableTranscription") as? Bool ?? true
        let enableAutoTranscription = UserDefaults.standard.object(forKey: "EnableAutoTranscription") as? Bool ?? false

        if enableTranscription && enableAutoTranscription {
            // Usa trascrizione automatica
            performAutoTranscription()
        } else {
            // Completa normalmente - verrà gestito dall'UI
            recordingState = .completed
        }
    }

    private func performAutoTranscription() {
        // La trascrizione automatica non è supportata su watchOS
        // Usiamo un placeholder finché non viene implementata manualmente
        transcribedText = "Trascrizione automatica non disponibile su Apple Watch"
        recordingState = .completed
        hapticFeedback(.failure)
    }

    func pauseRecording() {
        audioManager.pauseRecording()
        lastActivity = Date()
    }

    func resumeRecording() {
        audioManager.resumeRecording()
        lastActivity = Date()
    }

    func deleteRecording() {
        audioManager.deleteRecording()
        transcribedText = nil
        recordingState = .idle
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
            hapticFeedback(.failure)
            return
        }

        // Controlla se la trascrizione è abilitata nelle impostazioni
        let enableTranscription = UserDefaults.standard.object(forKey: "EnableTranscription") as? Bool ?? true

        // Se la trascrizione è abilitata e non c'è testo, usa un default
        if enableTranscription && (transcribedText == nil || transcribedText!.isEmpty) {
            // Usa un testo di default invece di bloccare l'invio
            transcribedText = "Nota audio"
        }

        isUploading = true
        uploadProgress = 0.0
        recordingState = .processing
        hapticFeedback(.start)

        // Simula il progresso dell'upload
        simulateUploadProgress()

        // Passa il testo solo se la trascrizione è abilitata
        let textToSend = enableTranscription ? transcribedText : nil
        notionService.sendAudioToNotion(recording: recording, transcribedText: textToSend) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false

                switch result {
                case .success(let message):
                    self?.recordingState = .completed
                    self?.showAlert(message: message)
                    self?.audioManager.currentRecording = nil
                    self?.transcribedText = nil
                    self?.hapticFeedback(.success)

                    // Reset state after success
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.recordingState = .idle
                    }

                case .failure(let error):
                    self?.recordingState = .failed(error.localizedDescription)
                    self?.showAlert(message: "Errore durante l'invio: \(error.localizedDescription)")
                    self?.hapticFeedback(.failure)
                }
            }
        }
    }

    // MARK: - Text Input
    func processTranscription(text: String?) {
        let enableTranscription = UserDefaults.standard.object(forKey: "EnableTranscription") as? Bool ?? true

        if enableTranscription {
            self.transcribedText = text
            // Completa sempre, anche con testo vuoto
            recordingState = .completed
            hapticFeedback(.success)
        } else {
            // Se la trascrizione è disabilitata, salta direttamente alla fase completata
            self.transcribedText = nil
            recordingState = .completed
            hapticFeedback(.success)
        }
    }

    // MARK: - Helpers
    func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }

    var hasCurrentRecording: Bool {
        audioManager.currentRecording != nil
    }

    private func hapticFeedback(_ type: WKHapticType) {
        WKInterfaceDevice.current().play(type)
    }

    private func simulateUploadProgress() {
        guard isUploading else { return }

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            DispatchQueue.main.async {
                if self.uploadProgress < 1.0 && self.isUploading {
                    self.uploadProgress += 0.02
                } else {
                    timer.invalidate()
                }
            }
        }
    }

    // Computed properties per stati UI
    var isRecordingActive: Bool {
        recordingState == .recording || recordingState == .preparing
    }

    var canStartRecording: Bool {
        recordingState == .idle || recordingState == .completed
    }

    var statusMessage: String {
        switch recordingState {
        case .idle:
            return "Pronto per registrare"
        case .preparing:
            return "Preparazione..."
        case .recording:
            return "Registrazione in corso"
        case .paused:
            return "In pausa"
        case .stopping:
            return "Interruzione..."
        case .processing:
            return "Elaborazione..."
        case .completed:
            return "Completato"
        case .failed(let error):
            return "Errore: \(error)"
        }
    }
}
