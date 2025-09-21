//  NotionWatch/ViewModels/SettingsViewModel.swift
import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var notionAPIKey: String {
        didSet { saveSettings() }
    }
    @Published var notionDatabaseID: String {
        didSet { saveSettings() }
    }
    @Published var cloudinaryAPIKey: String {
        didSet { saveSettings() }
    }
    @Published var cloudinaryAPISecret: String {
        didSet { saveSettings() }
    }
    @Published var cloudinaryCloudName: String {
        didSet { saveSettings() }
    }
    @Published var showingAlert = false
    @Published var alertMessage = ""

    private let userDefaults = UserDefaults.standard //Istanza di user default
    private var cancellables: Set<AnyCancellable> = []

    init() {
        // Carica le impostazioni da UserDefaults
        notionAPIKey = userDefaults.string(forKey: "NotionAPIKey") ?? ""  // Carica, default ""
        notionDatabaseID = userDefaults.string(forKey: "NotionDatabaseId") ?? "" // Carica, default ""
        cloudinaryAPIKey = userDefaults.string(forKey: "CloudinaryAPIKey") ?? ""
        cloudinaryAPISecret = userDefaults.string(forKey: "CloudinaryAPISecret") ?? ""
        cloudinaryCloudName = userDefaults.string(forKey: "CloudinaryCloudName") ?? ""
    }

    private func saveSettings() {
        userDefaults.set(notionAPIKey, forKey: "NotionAPIKey") // Salva
        userDefaults.set(notionDatabaseID, forKey: "NotionDatabaseId") // Salva
        userDefaults.set(cloudinaryAPIKey, forKey: "CloudinaryAPIKey")
        userDefaults.set(cloudinaryAPISecret, forKey: "CloudinaryAPISecret")
        userDefaults.set(cloudinaryCloudName, forKey: "CloudinaryCloudName")
    }
  func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }

    func areAllCredentialsConfigured() -> Bool {
        return !notionAPIKey.isEmpty &&
               !notionDatabaseID.isEmpty &&
               !cloudinaryAPIKey.isEmpty &&
               !cloudinaryAPISecret.isEmpty &&
               !cloudinaryCloudName.isEmpty
    }

    func exportCredentials() -> String {
        let credentials = [
            "notionAPIKey": notionAPIKey,
            "notionDatabaseID": notionDatabaseID,
            "cloudinaryAPIKey": cloudinaryAPIKey,
            "cloudinaryAPISecret": cloudinaryAPISecret,
            "cloudinaryCloudName": cloudinaryCloudName
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: credentials, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }

    func importCredentials(from jsonString: String) -> Bool {
        guard let jsonData = jsonString.data(using: .utf8),
              let credentials = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String] else {
            showAlert(message: "Invalid credentials format")
            return false
        }

        if let notionAPI = credentials["notionAPIKey"] { notionAPIKey = notionAPI }
        if let notionDB = credentials["notionDatabaseID"] { notionDatabaseID = notionDB }
        if let cloudinaryAPI = credentials["cloudinaryAPIKey"] { cloudinaryAPIKey = cloudinaryAPI }
        if let cloudinarySecret = credentials["cloudinaryAPISecret"] { cloudinaryAPISecret = cloudinarySecret }
        if let cloudinaryCloud = credentials["cloudinaryCloudName"] { cloudinaryCloudName = cloudinaryCloud }

        showAlert(message: "Credentials imported successfully")
        return true
    }
}
