import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showSignUp: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 15) { // Riduci spacing
                Text("Registrazione")
                    .font(.title)
                    .padding(.bottom)

                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)

                SecureField("Password (min. 6 caratteri)", text: $viewModel.password)
                    .textContentType(.newPassword)

                Button("Registrati") {
                    viewModel.signUp()
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                .padding(.top)

                Button("Hai già un account? Accedi") {
                    showSignUp = false // Torna alla vista di login
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Registrati") // Titolo
    }
}
