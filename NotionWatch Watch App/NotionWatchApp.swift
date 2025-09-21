import SwiftUI
import AVFoundation
import Firebase

@main
struct NotionWatchNewApp: App {
    @StateObject private var authService = AuthService()
    @State private var showSignUp = false
    @State private var isAppearing = false

    init() {
        requestMicrophonePermission()
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if authService.isLoggedIn {
                    ContentView(authViewModel: AuthViewModel(authService: authService))
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .animation(.easeInOut(duration: 0.6), value: authService.isLoggedIn)
                } else {
                    Group {
                        if showSignUp {
                            SignUpView(
                                viewModel: AuthViewModel(authService: authService),
                                showSignUp: $showSignUp
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        } else {
                            LoginView(
                                viewModel: AuthViewModel(authService: authService),
                                showSignUp: $showSignUp
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: showSignUp)
                }

                // Splash screen overlay
                if !isAppearing {
                    SplashView()
                        .transition(.opacity)
                        .animation(.easeOut(duration: 1.0), value: isAppearing)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        isAppearing = true
                    }
                }
            }
        }
    }

     func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("DEBUG: Permesso microfono garantito")
                } else {
                    print("DEBUG: Permesso microfono negato")
                }
            }
        }
    }
}
