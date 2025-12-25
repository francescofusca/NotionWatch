//  NotlonWatch/ContentView.swift

import SwiftUI
import WatchKit

struct ContentView: View {
    @ObservedObject var audioViewModel = AudioRecorderViewModel()
    @ObservedObject var authViewModel = AuthViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showingSettings = false
    @State private var showingPrivacyPolicy = false
    @State private var showingHelp = false
    @State private var lastInteraction = Date()


    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 16) {
                        // Header con gradiente
                        VStack(spacing: 8) {
                            Text("NotlonWatch 👁️")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .scaleEffect(audioViewModel.isRecording ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: audioViewModel.isRecording)
                        }
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        )

                        // Main content area
                        VStack(spacing: 20) {
                            // Stato della registrazione
                            if audioViewModel.isRecording {
                                createRecordingView(audioViewModel: audioViewModel)
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    ))
                            } else {
                                createIdleView(
                                    settingsViewModel: settingsViewModel,
                                    audioViewModel: audioViewModel,
                                    onShowSettings: { showingSettings = true },
                                    onHaptic: { hapticFeedback() },
                                    onUpdateInteraction: { lastInteraction = Date() }
                                )
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    ))
                            }

                            // Stato della riproduzione
                            if audioViewModel.isPlaying {
                                createPlaybackView(audioViewModel: audioViewModel)
                                    .transition(.slide.combined(with: .opacity))
                            }
                        }

                        // Trascrizione con design migliorato - mostra solo se abilitata
                        let enableTranscription = UserDefaults.standard.object(forKey: "EnableTranscription") as? Bool ?? true

                        if enableTranscription, let transcription = audioViewModel.transcribedText, !audioViewModel.isRecording, !audioViewModel.isPlaying {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Descrizione", systemImage: "text.quote")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)

                                TextField("Descrizione", text: Binding(
                                    get: { audioViewModel.transcribedText ?? "" },
                                    set: { audioViewModel.transcribedText = $0 }
                                ))
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.regularMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(.tertiary, lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, 4)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        // Action buttons con design migliorato - mostra sempre se c'è una registrazione
                        if !audioViewModel.isRecording && !audioViewModel.isPlaying && audioViewModel.hasCurrentRecording {
                            let enableTranscription = UserDefaults.standard.object(forKey: "EnableTranscription") as? Bool ?? true

                            // Mostra i pulsanti se: trascrizione disabilitata OR (trascrizione abilitata E c'è testo)
                            if !enableTranscription || (enableTranscription && audioViewModel.transcribedText != nil) {
                                createSaveDeleteButtons(audioViewModel: audioViewModel, onHaptic: {})
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }

                        // Indicatore di caricamento migliorato
                        if audioViewModel.isUploading {
                            VStack(spacing: 12) {
                                ProgressView(value: max(0, min(1, audioViewModel.uploadProgress)))
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .scaleEffect(1.2)

                                Text("Invio in corso...")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.regularMaterial)
                            )
                            .transition(.scale.combined(with: .opacity))
                        }

                        Spacer(minLength: 8)

                        // Bottom navigation migliorata
                        HStack(spacing: 20) {
                            navigationButton(
                                icon: "gearshape.fill",
                                title: "Settings",
                                action: { showingSettings.toggle() }
                            )

                            navigationButton(
                                icon: "hand.raised.fill",
                                title: "Privacy",
                                action: { showingPrivacyPolicy.toggle() }
                            )

                            navigationButton(
                                icon: "questionmark.circle.fill",
                                title: "Help",
                                action: { showingHelp.toggle() }
                            )
                        }
                        .padding(.bottom, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .alert(isPresented: $audioViewModel.showingAlert) {
            Alert(
                title: Text("Avviso"),
                message: Text(audioViewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: settingsViewModel, authViewModel: authViewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingHelp) {
                NotionCredentialsHelpView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }

    }

    // MARK: - Navigation Button Helper
    @ViewBuilder
    private func navigationButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)

                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - View Components
    @ViewBuilder
    private func createIdleView(
        settingsViewModel: SettingsViewModel,
        audioViewModel: AudioRecorderViewModel,
        onShowSettings: @escaping () -> Void,
        onHaptic: @escaping () -> Void,
        onUpdateInteraction: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                onHaptic()
                if settingsViewModel.areAllCredentialsConfigured() {
                    audioViewModel.startRecording()
                } else {
                    onShowSettings()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            settingsViewModel.areAllCredentialsConfigured() ?
                            LinearGradient(colors: [.red.opacity(0.8), .red], startPoint: .top, endPoint: .bottom) :
                            LinearGradient(colors: [.gray.opacity(0.6), .gray], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 90, height: 90)
                        .shadow(color: settingsViewModel.areAllCredentialsConfigured() ? .red.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)

                    Image(systemName: "mic.fill")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundColor(.white)
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 0.2), value: 1.0)
                }
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                TapGesture().onEnded {
                    onUpdateInteraction()
                }
            )

            VStack(spacing: 4) {
                Text(settingsViewModel.areAllCredentialsConfigured() ? "Tocca per registrare" : "Configura credenziali")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(settingsViewModel.areAllCredentialsConfigured() ? .primary : .secondary)
                    .multilineTextAlignment(.center)

                if !settingsViewModel.areAllCredentialsConfigured() {
                    Text("Vai in Impostazioni")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(16)
    }

    @ViewBuilder
    private func createRecordingView(audioViewModel: AudioRecorderViewModel) -> some View {
        VStack(spacing: 20) {
            // Recording indicator con animazione
            ZStack {
                Circle()
                    .fill(
                        audioViewModel.isPaused ?
                        LinearGradient(colors: [.orange.opacity(0.8), .orange], startPoint: .top, endPoint: .bottom) :
                        LinearGradient(colors: [.red.opacity(0.8), .red], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 90, height: 90)
                    .scaleEffect(audioViewModel.isPaused ? 1.0 : 1.05)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: audioViewModel.isPaused)
                    .shadow(color: audioViewModel.isPaused ? .orange.opacity(0.3) : .red.opacity(0.3), radius: 12, x: 0, y: 6)

                Image(systemName: audioViewModel.isPaused ? "pause.fill" : "waveform")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }

            // Timer con design migliorato
            VStack(spacing: 4) {
                Text("\(formattedDuration(audioViewModel.recordingDuration))")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primary, .secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(.tertiary, lineWidth: 1)
                    )
            )

            // Control buttons
            HStack(spacing: 24) {
                controlButton(
                    icon: audioViewModel.isPaused ? "play.fill" : "pause.fill",
                    title: audioViewModel.isPaused ? "Riprendi" : "Pausa",
                    color: audioViewModel.isPaused ? .green : .orange,
                    action: {
                        hapticFeedback()
                        if audioViewModel.isPaused {
                            audioViewModel.resumeRecording()
                        } else {
                            audioViewModel.pauseRecording()
                        }
                    }
                )

                controlButton(
                    icon: "stop.fill",
                    title: "Stop",
                    color: .red,
                    action: {
                        hapticFeedback()
                        audioViewModel.stopRecording()
                        // Controlla se la trascrizione è abilitata
                        let enableTranscription = UserDefaults.standard.object(forKey: "EnableTranscription") as? Bool ?? true
                        let enableAutoTranscription = UserDefaults.standard.object(forKey: "EnableAutoTranscription") as? Bool ?? false

                        if enableTranscription && !enableAutoTranscription {
                            // Trascrizione manuale: non forziamo più l'input immediato.
                            // L'utente potrà modificare la descrizione dalla schermata principale tramite il TextField.
                             audioViewModel.processTranscription(text: "")
                        } else if !enableTranscription {
                            // Se la trascrizione è disabilitata, processa senza testo
                            audioViewModel.processTranscription(text: nil)
                        }
                        // Se enableAutoTranscription è true, la trascrizione è già stata gestita automaticamente
                    }
                )
            }
        }
        .padding(20)
    }

    @ViewBuilder
    private func createPlaybackView(audioViewModel: AudioRecorderViewModel) -> some View {
        VStack(spacing: 16) {
            // Playback indicator
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.green.opacity(0.8), .green], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)

                Image(systemName: "play.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }

            // Progress and time
            VStack(spacing: 8) {
                Text("\(formattedDuration(audioViewModel.playbackTime)) / \(formattedDuration(audioViewModel.recordingDuration))")
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundColor(.primary)

                // Custom progress bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.tertiary)
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(colors: [.green, .green.opacity(0.7)], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: (audioViewModel.recordingDuration > 0 ? CGFloat(audioViewModel.playbackTime / audioViewModel.recordingDuration) : 0) * 140, height: 6)
                        .animation(.linear(duration: 0.1), value: audioViewModel.playbackTime)
                }
                .frame(width: 140)
                .onTapGesture { location in
                    let progress = location.x / 140
                    audioViewModel.playbackTime = progress * audioViewModel.recordingDuration
                }
            }

            // Stop button
            controlButton(
                icon: "stop.fill",
                title: "Stop",
                color: .red,
                action: {
                    hapticFeedback()
                    audioViewModel.stopPlayback()
                }
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.tertiary, lineWidth: 1)
                )
        )
    }

    @ViewBuilder
    private func createSaveDeleteButtons(audioViewModel: AudioRecorderViewModel, onHaptic: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            actionButton(
                icon: "play.fill",
                title: "Ascolta",
                color: .blue,
                action: {
                    onHaptic()
                    audioViewModel.startPlayback()
                }
            )

            actionButton(
                icon: "paperplane.fill",
                title: "Invia",
                color: .green,
                action: {
                    hapticFeedback()
                    audioViewModel.saveRecording()
                }
            )

            actionButton(
                icon: "trash.fill",
                title: "Elimina",
                color: .red,
                action: {
                    onHaptic()
                    audioViewModel.deleteRecording()
                }
            )
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Button Helpers
    @ViewBuilder
    private func controlButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func actionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.8), color],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 44, height: 44)
                        .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)

                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                }

                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(FixedColorButtonStyle())
    }
    private func formattedDuration(_ duration: TimeInterval) -> String {
           let minutes = Int(duration) / 60
           let seconds = Int(duration) % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }

    // MARK: - Helper Functions
    private func hapticFeedback() {
        WKInterfaceDevice.current().play(.click)
    }

struct FixedColorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

