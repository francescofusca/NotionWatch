import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    @Published var isLoggedIn: Bool = false
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let wasLoggedIn = self.isLoggedIn // Memorizza lo stato precedente
                self.isLoggedIn = (user != nil)
                print("DEBUG: AuthService - addStateDidChangeListener: isLoggedIn = \(self.isLoggedIn)")
                // Aggiungi un log per capire quando lo stato cambia
                if wasLoggedIn != self.isLoggedIn {
                    print("DEBUG: AuthService - Stato login cambiato a: \(self.isLoggedIn)")
                }
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("DEBUG: AuthService.signIn() chiamato")
        Auth.auth().signIn(withEmail: email, password: password) { result, error in // Non serve [weak self] qui
            if let error = error {
                print("DEBUG: AuthService.signIn() - Errore: \(error)")
                completion(.failure(error))
                return
            }
            print("DEBUG: AuthService.signIn() - Completato (Listener aggiornerà isLoggedIn)")
            // Chiamiamo completion success qui per indicare che la chiamata API è terminata
            // anche se lo stato UI è gestito dal listener
            completion(.success(()))
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("DEBUG: AuthService.signUp() chiamato")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in // Non serve [weak self] qui
            if let error = error {
                print("DEBUG: AuthService.signUp() - Errore: \(error)")
                completion(.failure(error))
                return
            }
            print("DEBUG: AuthService.signUp() - Successo (utente creato)")
            completion(.success(())) // Indica il successo della creazione
        }
    }

    func sendPasswordReset(to email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("DEBUG: AuthService.sendPasswordReset() chiamato")
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("DEBUG: AuthService.sendPasswordReset() - Errore: \(error)")
                completion(.failure(error))
                return
            }
            print("DEBUG: AuthService.sendPasswordReset() - Successo")
            completion(.success(()))
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        print("DEBUG: AuthService.signOut() chiamato")
        do {
            try Auth.auth().signOut()
            print("DEBUG: AuthService.signOut() - Successo")
            completion(.success(()))
        } catch {
            print("DEBUG: AuthService.signOut() - Errore: \(error)")
            completion(.failure(error))
        }
    }

    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        print("DEBUG: AuthService.deleteAccount() chiamato")
        guard let user = Auth.auth().currentUser else {
            print("DEBUG: AuthService.deleteAccount() - Nessun utente loggato")
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nessun utente loggato."])))
            return
        }

        user.delete { error in // Non serve [weak self] qui
            if let error = error {
                print("DEBUG: AuthService.deleteAccount() - Errore: \(error)")
                completion(.failure(error))
                return
            }
            print("DEBUG: AuthService.deleteAccount() - Successo")
            completion(.success(()))
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
            print("DEBUG: AuthService - Listener rimosso")
        }
    }
}
