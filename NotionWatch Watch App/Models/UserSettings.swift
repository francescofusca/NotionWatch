//  NotionWatch/Models/UserSettings.swift
import Foundation

// Non strettamente necessario con l'approccio UserDefaults, ma utile per chiarezza
struct UserSettings {
    var notionAPIKey: String?
    var notionDatabaseID: String?
    var cloudinaryCloudName: String?
    var cloudinaryAPIKey: String?
    var cloudinaryAPISecret: String?
}
