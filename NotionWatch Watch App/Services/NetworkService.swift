//  NotionWatch/Services/NetworkService.swift
import Foundation
import Combine

class NetworkService {
    func uploadAudio(fileURL: URL, description: String, apiKey: String, databaseId: String, completion: @escaping (Result<String, Error>) -> Void) {

        guard let url = URL(string: "https://notionwatchserver.onrender.com/upload") else { //USA IP o HOSTNAME
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120.0 // Aumenta il timeout

        var data = Data()

        // Aggiungi il file audio
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"audio\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        do {
            let audioData = try Data(contentsOf: fileURL)
            data.append(audioData)
        } catch {
            completion(.failure(error))
            return
        }
        data.append("\r\n".data(using: .utf8)!)

        // Aggiungi la descrizione
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
        data.append(description.data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        
        // Aggiungo API KEY
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"apiKey\"\r\n\r\n".data(using: .utf8)!)
        data.append(apiKey.data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)

        // Aggiungo DATABASE ID
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"databaseId\"\r\n\r\n".data(using: .utf8)!)
        data.append(databaseId.data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)


        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            if let data = data, let message = String(data: data, encoding: .utf8) {
                completion(.success(message))
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        }.resume()
    }

    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case invalidResponse

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "URL non valido."
            case .invalidResponse:
                return "Risposta non valida dal server."
            }
        }
    }
}
