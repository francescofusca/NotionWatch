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
    @Published var showingAlert = false
    @Published var alertMessage = ""

    private let userDefaults = UserDefaults.standard //Istanza di user default
    private var cancellables: Set<AnyCancellable> = []

    init() {
        // Carica le impostazioni da UserDefaults
        notionAPIKey = userDefaults.string(forKey: "NotionAPIKey") ?? ""  // Carica, default ""
        notionDatabaseID = userDefaults.string(forKey: "NotionDatabaseId") ?? "" // Carica, default ""
    }

    private func saveSettings() {
        userDefaults.set(notionAPIKey, forKey: "NotionAPIKey") // Salva
        userDefaults.set(notionDatabaseID, forKey: "NotionDatabaseId") // Salva
    }
  func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }
}
