//  NotionWatch/Views/LoginView.swift
import SwiftUI
import WatchKit

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showSignUp: Bool
    @State private var showingForgotPassword = false
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 24) {
                        // Header con animazione
                        VStack(spacing: 12) {
                            Text("👁️")
                                .font(.system(size: 40))
                                .scaleEffect(isLoading ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isLoading)

                            Text("Accedi")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("Bentornato in NotionWatch")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 16)

                        // Form section
                        VStack(spacing: 16) {
                            inputField(
                                title: "Email",
                                text: $viewModel.email,
                                icon: "envelope.fill",
                                isSecure: false
                            )

                            inputField(
                                title: "Password",
                                text: $viewModel.password,
                                icon: "lock.fill",
                                isSecure: true
                            )
                        }
                        .padding(.horizontal, 4)

                        // Login button
                        Button(action: {
                            hapticFeedback()
                            isLoading = true
                            viewModel.signIn()

                            // Reset loading state after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                isLoading = false
                            }
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "person.fill.checkmark")
                                        .font(.system(size: 16, weight: .medium))
                                }

                                Text(isLoading ? "Accesso..." : "Accedi")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        viewModel.email.isEmpty || viewModel.password.isEmpty ?
                                        LinearGradient(colors: [.gray.opacity(0.6), .gray], startPoint: .top, endPoint: .bottom) :
                                        LinearGradient(colors: [.blue.opacity(0.8), .blue], startPoint: .top, endPoint: .bottom)
                                    )
                            )
                            .shadow(
                                color: viewModel.email.isEmpty || viewModel.password.isEmpty ? .clear : .blue.opacity(0.3),
                                radius: 8, x: 0, y: 4
                            )
                        }
                        .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || isLoading)
                        .buttonStyle(.plain)

                        // Secondary actions
                        VStack(spacing: 12) {
                            Button(action: {
                                hapticFeedback()
                                showSignUp = true
                            }) {
                                HStack {
                                    Image(systemName: "person.badge.plus")
                                        .font(.system(size: 14, weight: .medium))
                                    Text("Non hai un account? Registrati")
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(.blue)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.blue.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(.blue.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(.plain)

                            Button(action: {
                                hapticFeedback()
                                showingForgotPassword = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "questionmark.circle")
                                        .font(.caption)
                                    Text("Password dimenticata?")
                                        .font(.caption)
                                }
                                .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 8)
                        Spacer(minLength: 16)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(minHeight: geometry.size.height)
            }
            .navigationBarHidden(true)
        }
        .alert(item: $viewModel.alert) { alert in
            Alert(
                title: Text("Avviso"),
                message: Text(alert.message),
                dismissButton: .default(Text("OK")) {
                    isLoading = false
                }
            )
        }
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView(viewModel: viewModel)
        }
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func inputField(
        title: String,
        text: Binding<String>,
        icon: String,
        isSecure: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 16)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }

            if isSecure {
                SecureField("Inserisci \(title.lowercased())", text: text)
                    .textContentType(title == "Email" ? .emailAddress : .password)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.regularMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.tertiary, lineWidth: 1)
                            )
                    )
            } else {
                TextField("Inserisci \(title.lowercased())", text: text)
                    .textContentType(title == "Email" ? .emailAddress : .password)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.regularMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.tertiary, lineWidth: 1)
                            )
                    )
            }
        }
    }

    private func hapticFeedback() {
        WKInterfaceDevice.current().play(.click)
    }
}
