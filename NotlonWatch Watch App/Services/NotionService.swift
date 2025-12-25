//  NotlonWatch/Services/NotionService.swift

import Foundation

class NotionService {

    private let networkService = NetworkService()

    func sendAudioToNotion(recording: AudioRecording, transcribedText: String?, completion: @escaping (Result<String, Error>) -> Void) {

        // Prendo le credenziali da UserDefaults
        let userDefaults = UserDefaults.standard
        guard let apiKey = userDefaults.string(forKey: "NotionAPIKey"),
              let databaseId = userDefaults.string(forKey: "NotionDatabaseId"),
              let cloudinaryApiKey = userDefaults.string(forKey: "CloudinaryAPIKey"),
              let cloudinaryApiSecret = userDefaults.string(forKey: "CloudinaryAPISecret"),
              let cloudinaryCloudName = userDefaults.string(forKey: "CloudinaryCloudName") else {
            completion(.failure(NSError(domain: "NotionServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Credenziali mancanti. Verifica le impostazioni."])))
            return
        }
        
        networkService.uploadAudio(
            fileURL: recording.fileURL,
            description: transcribedText ?? "",
            transcription: transcribedText, // Passa anche la trascrizione separatamente
            apiKey: apiKey,
            databaseId: databaseId,
            cloudinaryApiKey: cloudinaryApiKey,
            cloudinaryApiSecret: cloudinaryApiSecret,
            cloudinaryCloudName: cloudinaryCloudName
        ) { result in
            switch result {
            case .success(let message):
                print("Risposta server", message)
                completion(.success("Nota salvata con successo!"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
