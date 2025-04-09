import SwiftUI
import AVFoundation
import Firebase

@main
struct NotionWatchNewApp: App { // Usa il nome del NUOVO progetto
    @State private var authService: AuthService?
    @State private var showSignUp = false

    init() {
        requestMicrophonePermission()
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if let authService = authService {
                if authService.isLoggedIn {
                    ContentView(authViewModel: AuthViewModel(authService: authService))
                } else {
                    VStack {
                        if showSignUp {
                            SignUpView(viewModel: AuthViewModel(authService: authService), showSignUp: $showSignUp)
                        } else {
                            LoginView(viewModel: AuthViewModel(authService: authService), showSignUp: $showSignUp)
                        }
                    }
                }
            } else {
                ProgressView()
                    .onAppear {
                        self.authService = AuthService()
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
