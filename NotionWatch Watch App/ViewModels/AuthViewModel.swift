//  NotionWatch/ViewModels/AuthViewModel.swift
import Foundation
import SwiftUI
import Combine
import FirebaseAuth

class AuthViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    //@Published var showingAlert = false // RIMUOVI
    //@Published var alertMessage = ""   // RIMUOVI
    @Published var showingForgotPassword = false    // RIMUOVI

    // NUOVE proprietà per la gestione dell'alert
    @Published var alert: IdentifiableAlert?

    struct IdentifiableAlert: Identifiable { // Struttura per l'alert
        let id = UUID()
        let message: String
        let isError: Bool
    }

    private let authService: AuthService
    private var cancellables: Set<AnyCancellable> = []

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }

 func signIn() { //Corretto
        print("DEBUG: AuthViewModel.signIn() chiamato")
        authService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                print("DEBUG: signIn() completion handler chiamato")
                switch result {
                case .success:
                    print("DEBUG: signIn() successo")
                case .failure(let error):
                    print("DEBUG: signIn() errore: \(error)")
                    self.showAlert(message: "Errore durante il login: \(error.localizedDescription)", isError: true) //Passo il parametro
                }
            }
        }
    }


     func signUp() {  //Corretto
        print("DEBUG: signUp() chiamato")

        guard isValidEmail(email) else {
            showAlert(message: "Inserisci un indirizzo email valido.", isError: true)
            return
        }

        guard password.count >= 6 else {
            showAlert(message: "La password deve contenere almeno 6 caratteri.", isError: true)
            return
        }

        authService.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                print("DEBUG: signUp() completion handler chiamato")
                switch result {
                case .success:
                    print("DEBUG: signUp() successo")
                    self.showAlert(message: "Registrazione avvenuta con successo! Ora puoi effettuare il login.", isError: false)
                    // Potresti voler reindirizzare l'utente alla schermata di login qui
                case .failure(let error):
                    print("DEBUG: signUp() errore: \(error)")
                    self.showAlert(message: "Errore durante la registrazione: \(error.localizedDescription)", isError: true) //Passo il parametro
                }
            }
        }
    }


    func signOut() {  //Corretto
           print("DEBUG: AuthViewModel.signOut() chiamato")
           authService.signOut { [weak self] result in
               DispatchQueue.main.async {
                    guard let self = self else {return} //Aggiungo il guard
                   switch result {
                   case .success:
                       print("DEBUG: AuthViewModel.signOut() - Successo")
                   case .failure(let error):
                       print("DEBUG: AuthViewModel.signOut() - Errore: \(error.localizedDescription)")
                       self.showAlert(message: "Errore durante il logout: \(error.localizedDescription)", isError: true) //Passo il parametro
                   }
               }
           }
       }

     func deleteAccount() {   //Corretto
        print("DEBUG: AuthViewModel.deleteAccount() chiamato")
        authService.deleteAccount { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {return} //Aggiungo il guard
                switch result {
                case .success:
                    print("DEBUG: AuthViewModel.deleteAccount() - Successo")
                    self.showAlert(message: "Account eliminato con successo.", isError: false)

                case .failure(let error):
                    print("DEBUG: AuthViewModel.deleteAccount() - Errore: \(error.localizedDescription)")
                    self.showAlert(message: "Errore durante l'eliminazione dell'account: \(error.localizedDescription)", isError: true) //Passo il parametro
                }
            }
        }
    }
    //Aggiungo la funzione per resettare la password
    func sendPasswordReset(completion: @escaping (Bool) -> Void) {
        print("DEBUG: AuthViewModel.sendPasswordReset() chiamato")

        guard isValidEmail(email) else {
            showAlert(message: "Inserisci un indirizzo email valido.", isError: true)
             completion(false)
            return
        }

        authService.sendPasswordReset(to: email) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                print("DEBUG: sendPasswordReset completion chiamato.")
                switch result {
                case .success:
                    print("DEBUG: AuthViewModel.sendPasswordReset() - Successo")
                    self.showAlert(message: "Email di reset password inviata a \(self.email). Controlla la tua casella di posta (e la cartella spam/posta indesiderata).", isError: false)
                    completion(true)

                case .failure(let error):
                                   print("DEBUG: AuthViewModel.sendPasswordReset() - Errore: \(error.localizedDescription)")

                                   // Gestione errori piu specifica
                                   let err = error as NSError // USA CAST DIRETTO
                                   let message: String
                                   if err.code == AuthErrorCode.userNotFound.rawValue {
                                       message = "Nessun utente trovato con questo indirizzo email."
                                   } else if err.code == AuthErrorCode.invalidEmail.rawValue {
                                       message = "Indirizzo email non valido."
                                   } else if err.userInfo["FIRAuthErrorUserInfoNameKey"] as? String == "ERROR_INTERNAL_ERROR", // Cast ancora necessario qui
                                             let underlyingError = err.userInfo[NSUnderlyingErrorKey] as? NSError,
                                             let underlyingMessage = underlyingError.userInfo["message"] as? String,
                                             underlyingMessage == "RESET_PASSWORD_EXCEED_LIMIT" {
                                       message = "Hai superato il limite di richieste di reset password per questo account. Riprova più tardi."
                                   } else {
                                       message = "Errore durante l'invio dell'email di reset: \(error.localizedDescription)"
                                   }

                                   self.showAlert(message: message, isError: true)
                                   completion(false)
                               }            }
        }
    }


    func showAlert(message: String, isError: Bool) {
        // Usa la nuova struttura IdentifiableAlert
        DispatchQueue.main.async {
             self.alert = IdentifiableAlert(message: message, isError: isError)
        }
    }

    func isValidEmail(_ email: String) -> Bool { /* ... (codice esistente) ... */
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
