//  NotionWatch/Services/NotionService.swift

import Foundation

class NotionService {

    private let networkService = NetworkService()

    func sendAudioToNotion(recording: AudioRecording, transcribedText: String?, completion: @escaping (Result<String, Error>) -> Void) {

        // Prendo le credenziali da UserDefaults
        let userDefaults = UserDefaults.standard
        guard let apiKey = userDefaults.string(forKey: "NotionAPIKey"),
              let databaseId = userDefaults.string(forKey: "NotionDatabaseId") else {
            completion(.failure(NSError(domain: "NotionServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Key o Database ID mancanti."])))
            return
        }
        
        networkService.uploadAudio(fileURL: recording.fileURL, description: transcribedText ?? "", apiKey: apiKey, databaseId: databaseId) { result in //Passo le variabili
            switch result {
            case .success(let message):
                // Handle success (e.g., show a confirmation message)
                print("Risposta server", message)
                completion(.success("Nota salvata con successo!"))
            case .failure(let error):
                // Handle failure (e.g., show an error message)
                completion(.failure(error))

            }
        }

    }
}
