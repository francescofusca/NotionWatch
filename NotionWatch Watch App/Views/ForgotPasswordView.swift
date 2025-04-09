//
//  ForgotPasswordView.swift
//  NotionWatch
//
//  Created by admin on 19/05/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode // Per chiudere la vista

    var body: some View {
        ScrollView {
            VStack {
                Text("Recupero Password")
                    .font(.title)
                    .padding(.bottom)

                Text("Inserisci l'indirizzo email associato al tuo account:")
                    .font(.body)
                    .padding()

                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .padding()

                Button("Invia Email di Reset") {
                    viewModel.sendPasswordReset{ _ in
                        //
                    }
                }
                .disabled(viewModel.email.isEmpty)
                .padding()

                Button("Annulla") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.top)
            }
        }
    }
}
