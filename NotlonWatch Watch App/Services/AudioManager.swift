//  NotlonWatch/Services/AudioManager.swift
import Foundation
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate { // Conforms to protocols
    @Published var isRecording = false
    @Published var isPaused = false
    @Published var isPlaying = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var currentRecording: AudioRecording?
    @Published var playbackTime : TimeInterval = 0

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?


    override init() {
            super.init()
            let session = AVAudioSession.sharedInstance()
            do{
                try session.setCategory(.playAndRecord, mode: .default)
                try session.setActive(true)
            }
            catch{
                print("Errore nella configurazione della sessione audio", error.localizedDescription)
            }

        }

    func startRecording() {
          let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
          let fileURL = documentsURL.appendingPathComponent("\(UUID().uuidString).m4a")

          let settings: [String: Any] = [
              AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
              AVSampleRateKey: 44100,
              AVNumberOfChannelsKey: 1,
              AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
          ]

          do {
              audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
              audioRecorder?.delegate = self // Set the delegate
              audioRecorder?.record()
              isRecording = true
              currentRecording = AudioRecording(fileURL: fileURL, createdAt: Date())
              startTimer() // Start the recording timer
          } catch {
              print("Errore nell'avvio della registrazione:", error)
              // Handle error appropriately (show alert, etc.)
              resetRecordingState()
          }
      }

      func stopRecording() {
          audioRecorder?.stop()
          isRecording = false
          isPaused = false
          timer?.invalidate()
          timer = nil // Invalidate timer
          audioRecorder = nil
      }

      func pauseRecording() {
          guard isRecording && !isPaused else { return }
          audioRecorder?.pause()
          isPaused = true
          timer?.invalidate()
      }

      func resumeRecording() {
          guard isRecording && isPaused else { return }
          audioRecorder?.record()
          isPaused = false
          startTimer()
      }

      func startPlayback() {
            guard let recording = currentRecording else { return }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recording.fileURL)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                isPlaying = true
                //Timer per il tempo di riproduzione
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ [weak self] _ in
                    guard let self = self else {return}
                    self.playbackTime = self.audioPlayer?.currentTime ?? 0
                }

            } catch {
                print("Errore nella riproduzione:", error)
                // Handle error
                resetPlaybackState()
            }
        }

        func stopPlayback() {
            audioPlayer?.stop()
            isPlaying = false
            resetPlaybackState()
        }


    private func startTimer() {
        timer?.invalidate() // Stop any existing timer
        recordingDuration = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 1
        }
    }


    private func resetRecordingState() {
        isRecording = false
        isPaused = false
        recordingDuration = 0
        currentRecording = nil
        timer?.invalidate()
        timer = nil

    }
    private func resetPlaybackState(){
        isPlaying = false
        playbackTime = 0
        timer?.invalidate()
        timer = nil
        audioPlayer = nil
    }

    // MARK: - AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
           resetPlaybackState()
        } else {
            print("Errore durante la riproduzione")
           resetPlaybackState()
        }
    }

    // MARK: - AVAudioRecorderDelegate
      func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
          if !flag{
              print("Errore durante la registrazione")
              resetRecordingState()
          }
      }

    //Funzione per eliminare la registrazione, da usare nel pulsante "Cancella"
    func deleteRecording() {
          guard let recording = currentRecording else { return }

          do {
              try FileManager.default.removeItem(at: recording.fileURL)
              currentRecording = nil // Clear the current recording
              resetRecordingState()
          } catch {
              print("Errore nell'eliminazione del file:", error)
              // Handle error
          }
      }

}
