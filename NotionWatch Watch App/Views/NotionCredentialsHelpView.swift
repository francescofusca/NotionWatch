//  NotionWatch/Views/NotionCredentialsHelpView.swift
import SwiftUI

struct NotionCredentialsHelpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Come Trovare le Credenziali Notion")
                    .font(.title)
                    .padding(.bottom)

                Text("API Key:")
                    .font(.headline)
                Text("1. Vai su notion.so/my-integrations")
                Text("2. Clicca '+ New Integration'.")
                Text("3. Dai un nome e seleziona il workspace associato.")
                Text("4. Clicca 'Submit'.")
                Text("5. Copia la stringa 'Internal Integration Token', quella è la tua API Key.")
                Image(systemName: "key") // Aggiungi immagini se possibile (screenshot)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)

                Text("Database ID:")
                    .font(.headline)
                Text("1. Apri la pagina o il database Notion che vuoi usare.")
                Text("2. L'ID del database è la parte dell'URL compresa tra il nome del tuo workspace e il punto interrogativo '?v='.")
                Text("   Esempio:")
                Text("   `https://www.notion.so/myworkspace/8fm7fa3925824c7a9510be4i956n8vb9?v=...`")
                    .font(.footnote)
                Text("   In questo esempio, l'ID è `8fm7fa3925824c7a9510be4i956n8vb9, mi raccomando ricordati di collegare il database con le tue integrations(API).`")
                Image(systemName: "doc.on.clipboard") // Aggiungi immagini
                   .resizable()
                   .scaledToFit()
                   .frame(height: 100)

                Button("Chiudi") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.top)
            }
            .padding()
        }
    }
}
