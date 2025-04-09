import SwiftUI
import WatchKit

struct MainView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var messaggioRobot: String = "Ciao! Premi per registrare."
    @State private var mostraConferma: Bool = false
    @State private var isUploading = false // Track upload state

    var body: some View {
        VStack {
            Text(messaggioRobot)
                .font(.subheadline)
                .padding()
                .multilineTextAlignment(.center)

            if !audioRecorder.isRecording {
                Button("Inizia a Registrare") {
                    audioRecorder.startRecording()
                    messaggioRobot = "Sto registrando..."
                }
            } else {
                Button("Ferma") {
                    audioRecorder.stopRecording()
                    messaggioRobot = "Vuoi salvare questa nota?"
                    mostraConferma = true
                }
            }
            if mostraConferma {
                            HStack {
                                Button("Salva") {
                                    inviaAudioANotion()
                                    mostraConferma = false // Hide buttons after starting upload
                                }
                                .disabled(isUploading) // Disable while uploading

                                Button("Cancella") {
                                    // Delete the file if the user cancels
                                    if let url = audioRecorder.audioFileURL {
                                        try? FileManager.default.removeItem(at: url)
                                    }
                                    messaggioRobot = "Nota cancellata. Vuoi registrarne un’altra?"
                                    mostraConferma = false
                                }
                            }
                        }

            if isUploading {
                ProgressView() // Show a loading indicator
                Text("Caricamento...")
                    .font(.caption)
            }
        }
    }


    func inviaAudioANotion() {
        guard let audioFileURL = audioRecorder.audioFileURL,
              let _ = UserDefaults.standard.string(forKey: "NotionAPIKey"),
              let _ = UserDefaults.standard.string(forKey: "NotionDatabaseId") else {
            messaggioRobot = "Errore: controlla le impostazioni di Notion."
            return
        }

        isUploading = true // Start showing loading indicator
        messaggioRobot = "Invio in corso..."

        // --- SIMULAZIONE di invio al server (SOSTITUISCI con la vera logica) ---
        // 1. Prepara la richiesta (simulata)
        // In a real app, you would create a URLRequest here,
        // set the HTTP method to POST, add headers, and add the audio file data.
        guard let url = URL(string: "https://notionwatchserver.onrender.com/upload") else { return } // URL DEL TUO SERVER!!!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Add the file data
          do {
             let audioData = try Data(contentsOf: audioFileURL)
              request.httpBody = audioData

             // You would typically also set a "Content-Type" header,
             //  like "multipart/form-data" if you're sending the file as form data,
             //  or "audio/m4a" if you're sending it directly as the body.

         } catch {
             print("Could not read audio file: \(error)")
             isUploading = false
             messaggioRobot = "Errore nell'invio."
             return
         }
        // 2. Invia la richiesta (simulata con un ritardo)
        URLSession.shared.dataTask(with: request) { data, response, error in
           DispatchQueue.main.async { // Update UI on the main thread
               self.isUploading = false  // Hide loading indicator

               if let error = error {
                   self.messaggioRobot = "Errore di rete: \(error.localizedDescription)"
                   return
               }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Success
                    self.messaggioRobot = "Nota salvata con successo!"
                }
               else if let httpResponse = response as? HTTPURLResponse{
                   // Handle other status codes
                   self.messaggioRobot = "Errore del server: \(httpResponse.statusCode)"
               } else {
                   // Handle other errors
                   self.messaggioRobot = "Errore sconosciuto"
               }

              // Delete file after success
               try? FileManager.default.removeItem(at: audioFileURL)

           }
        }.resume()


        // --- FINE SIMULAZIONE ---
    }

}
