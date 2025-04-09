//  NotionWatch/Views/SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel : AuthViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Impostazioni")
                    .font(.title)
                    .padding(.bottom)

                Text("Notion API Key:")
                    .font(.headline)
                TextField("Inserisci la tua API Key", text: $viewModel.notionAPIKey)
                    //.textFieldStyle(RoundedBorderTextFieldStyle()) // RIMUOVI
                    //.autocapitalization(.none) RIMUOVO
                    //.disableAutocorrection(true) RIMUOVO

                Text("Notion Database ID:")
                    .font(.headline)
                TextField("Inserisci l'ID del database", text: $viewModel.notionDatabaseID)
                    //.textFieldStyle(RoundedBorderTextFieldStyle()) // RIMUOVI
                    //.autocapitalization(.none) RIMUOVO
                    //.disableAutocorrection(true) RIMUOVO
                
                HStack{
                    Spacer()
                    Button("Logout") {
                        authViewModel.signOut()
                        presentationMode.wrappedValue.dismiss() // Chiudi la vista Impostazioni

                    }
                    .foregroundColor(.red)
                    Spacer()
                }

                Button(action: {
                    authViewModel.deleteAccount()
                    presentationMode.wrappedValue.dismiss()

                }) {
                    Text("Elimina Account")
                        .foregroundColor(.red)
                }

                Spacer() // Spinge il contenuto in alto
            }
            .padding()
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Avviso"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
