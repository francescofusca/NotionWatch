import SwiftUI
import AVFoundation

class AudioRecorder: ObservableObject {
    @Published var isRecording: Bool = false
    private var audioRecorder: AVAudioRecorder?
    private(set) var audioFileURL: URL? // Store the URL

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)

            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFileURL = documentsURL.appendingPathComponent("\(UUID().uuidString).m4a") // Use UUID for unique filenames

            guard let url = audioFileURL else {
                print("Errore: audioFileURL è nil")
                return
            }

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100, // Higher sample rate for better quality
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Errore nella registrazione: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        // audioFileURL is now ready to be used.
    }
}
