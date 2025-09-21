//  NotionWatch/Views/SettingsView.swift
import SwiftUI
import WatchKit

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showingDeleteConfirmation = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header con pulsante chiudi
                    HStack {
                        Spacer()

                        VStack(spacing: 8) {
                            Image(systemName: "gearshape.2.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Text("Impostazioni")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.secondary)
                                .background(Circle().fill(.regularMaterial))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top)
                    .padding(.horizontal)

                    // Notion Settings Section
                    settingsSection(
                        title: "Configurazione Notion",
                        icon: "doc.text.fill",
                        iconColor: .orange
                    ) {
                        credentialField(
                            title: "API Key",
                            placeholder: "Inserisci la tua API Key",
                            text: $viewModel.notionAPIKey,
                            isSecure: true
                        )

                        credentialField(
                            title: "Database ID",
                            placeholder: "Inserisci l'ID del database",
                            text: $viewModel.notionDatabaseID
                        )
                    }

                    // Cloudinary Settings Section
                    settingsSection(
                        title: "Configurazione Cloudinary",
                        icon: "cloud.fill",
                        iconColor: .blue
                    ) {
                        credentialField(
                            title: "API Key",
                            placeholder: "Inserisci la tua API Key",
                            text: $viewModel.cloudinaryAPIKey,
                            isSecure: true
                        )

                        credentialField(
                            title: "API Secret",
                            placeholder: "Inserisci il tuo API Secret",
                            text: $viewModel.cloudinaryAPISecret,
                            isSecure: true
                        )

                        credentialField(
                            title: "Cloud Name",
                            placeholder: "Inserisci il nome del cloud",
                            text: $viewModel.cloudinaryCloudName
                        )
                    }

                    // Help section
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Suggerimento", systemImage: "lightbulb.fill")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.yellow)

                        Text("Prima di inserire le credenziali, salvale sul tuo iPhone e incollale qui per velocizzare l'inserimento.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.leading, 20)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.yellow.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.yellow.opacity(0.3), lineWidth: 1)
                            )
                    )

                    // Account actions
                    VStack(spacing: 12) {
                        Button(action: {
                            hapticFeedback()
                            authViewModel.signOut()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Logout")
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [.orange.opacity(0.8), .orange],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: {
                            hapticFeedback()
                            showingDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Elimina Account")
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [.red.opacity(0.8), .red],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("Avviso"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert("Conferma Eliminazione", isPresented: $showingDeleteConfirmation) {
            Button("Elimina", role: .destructive) {
                authViewModel.deleteAccount()
                presentationMode.wrappedValue.dismiss()
            }
            Button("Annulla", role: .cancel) { }
        } message: {
            Text("Sei sicuro di voler eliminare il tuo account? Questa azione non può essere annullata.")
        }
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func settingsSection<Content: View>(
        title: String,
        icon: String,
        iconColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(iconColor)

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 4)

            content()
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
    private func credentialField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            if isSecure {
                SecureField(placeholder, text: text)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.quinary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.quaternary, lineWidth: 1)
                            )
                    )
            } else {
                TextField(placeholder, text: text)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.quinary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.quaternary, lineWidth: 1)
                            )
                    )
            }
        }
    }

    private func hapticFeedback() {
        WKInterfaceDevice.current().play(.click)
    }
}
