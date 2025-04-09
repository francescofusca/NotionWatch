//  NotionWatch/Views/LoginView.swift
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showSignUp: Bool
    @State private var showingForgotPassword = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.title)

                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)

                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)

                Button("Accedi") {
                    viewModel.signIn()
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)

                Button("Non hai un account? Registrati") {
                    showSignUp = true
                }
                .padding(.top)

                Button("Password dimenticata?") {
                    showingForgotPassword = true
                }
                .font(.footnote)
                .foregroundColor(.blue)
            }
            .padding()
            // USA .alert(item:content:)
            .alert(item: $viewModel.alert) { alert in
                Alert(
                    title: Text("Avviso"),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView(viewModel: viewModel)
        }
    }
}
