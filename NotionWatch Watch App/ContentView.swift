//  NotionWatch/ContentView.swift

import SwiftUI

struct ContentView: View {
    @ObservedObject var audioViewModel = AudioRecorderViewModel()
    @ObservedObject var authViewModel = AuthViewModel()
    @State private var showingSettings = false
    @State private var showingPrivacyPolicy = false // Aggiungi
    @State private var showingHelp = false // Aggiungi


    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 20) {
                    // Titolo
                    Text("Notion Watch")
                        .font(.title)
                        .padding(.top)

                    // Stato della registrazione
                    if audioViewModel.isRecording {
                        recordingView
                    } else {
                        idleView
                    }

                    // Stato della riproduzione
                    if audioViewModel.isPlaying {
                        playbackView
                    }

                    // Trascrizione (mostrata solo dopo l'inserimento del testo)
                    if let transcription = audioViewModel.transcribedText, !audioViewModel.isRecording, !audioViewModel.isPlaying {
                        Text("Trascrizione:")
                            .font(.headline)
                        Text(transcription)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }

                    // Pulsanti (condizionali)
                    if !audioViewModel.isRecording && !audioViewModel.isPlaying && audioViewModel.hasCurrentRecording && audioViewModel.transcribedText != nil  {
                        saveDeleteButtons
                    }

                    // Indicatore di caricamento
                    if audioViewModel.isUploading {
                        ProgressView(value: audioViewModel.uploadProgress)
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Invio in corso...")
                    }


                    //Bottoni per accedere alle varie schermate
                    HStack{
                        Button {
                            showingSettings.toggle()
                        } label: {
                            Text("Impostazioni")
                        }
                        Button {
                            showingPrivacyPolicy.toggle()
                        } label: {
                            Text("Privacy")
                        }
                        Button {
                            showingHelp.toggle()
                        } label: {
                            Text("Aiuto")
                        }

                    }


                }
                .padding()
                .alert(isPresented: $audioViewModel.showingAlert) {
                    Alert(
                        title: Text("Avviso"),
                        message: Text(audioViewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }


            }
            .sheet(isPresented: $showingSettings) { // Impostazioni
                SettingsView(viewModel: SettingsViewModel(), authViewModel: authViewModel)
            }
            .sheet(isPresented: $showingPrivacyPolicy) { // Informativa sulla privacy
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingHelp) { // Guida
                NotionCredentialsHelpView()
            }
        }

    }

    // Viste private per organizzare il codice
    @ViewBuilder
       private var idleView: some View {
              Button(action: {
                  audioViewModel.startRecording()
              }) {
                  Image(systemName: "mic.circle.fill")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 80, height: 80)
                      .foregroundColor(.red)
              }
              .buttonStyle(PlainButtonStyle())
              Text("Tocca per registrare")
          }

          @ViewBuilder
          private var recordingView: some View {
              VStack {
                  Image(systemName: "record.circle.fill")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 80, height: 80)
                      .foregroundColor(.red)
                  Text("\(formattedDuration(audioViewModel.recordingDuration))")
                      .font(.headline)
                  Button("Ferma") {
                      audioViewModel.stopRecording()
                      // Chiamiamo presentTextInputController *QUI*
                      presentTextInputController()

                  }
              }
          }

    @ViewBuilder
     private var playbackView: some View{
         VStack{
             Image(systemName: "play.circle.fill")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 80, height: 80)
                 .foregroundColor(.green)
             Text("\(formattedDuration(audioViewModel.playbackTime)) / \(formattedDuration(audioViewModel.recordingDuration))")
             Slider(value: $audioViewModel.playbackTime, in: 0...audioViewModel.recordingDuration)
             .disabled(audioViewModel.isRecording)
             HStack{
                 Button {
                     audioViewModel.stopPlayback()
                 } label: {
                    Text("Stop") //Uso il testo per watchOs
                 }
                 .buttonStyle(.borderedProminent)

             }
         }
     }

       @ViewBuilder
       private var saveDeleteButtons: some View {
           HStack(spacing: 20) {
               Button(action: {
                   audioViewModel.saveRecording()
               }) {
                   Image(systemName: "square.and.arrow.down.fill")
                       .foregroundColor(.green)
               }

               Button(action: {
                   audioViewModel.deleteRecording()
               }) {
                   Image(systemName: "trash.fill")
                       .foregroundColor(.red)
               }
           }
       }
    private func formattedDuration(_ duration: TimeInterval) -> String {
           let minutes = Int(duration) / 60
           let seconds = Int(duration) % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }

    // Funzione per presentare il controller di input
    func presentTextInputController() {

        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: [], allowedInputMode: .plain) { result in
                guard let result = result as? [String], let text = result.first else {

                    return
                }
                audioViewModel.processTranscription(text: text)

            }

        }
    func setupTextInput() {
        }
}
