//  NotlonWatch/Views/PrivacyPolicyView.swift
import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode

    // !!! IMPORTANTE: Rivedi e personalizza ulteriormente questo testo.
    // !!! CONSULTA UN LEGALE per assicurarti della conformità. !!!
    let privacyPolicyText = """
    NotlonWatch Privacy Policy

    Last updated: April 19, 2025

    **1. Introduction**

    NotlonWatch is an Apple Watch application developed by Francesco Fusca (ff9). This app allows you to record audio notes and save them to your personal Notion account, also using the Cloudinary service for audio file storage. This Privacy Policy describes what data we collect, how we use it, and with whom we share it.

    **2. Data Collected**

    To provide the app's functionality, NotlonWatch requires and manages the following data:

    *   **Authentication Information (provided to Firebase):**
        *   Email address: For creating and managing your NotlonWatch account.
        *   Password: For your account security (stored in encrypted form by Firebase).
        *   User ID (Firebase): A unique identifier associated with your NotlonWatch account.
    *   **External Service Credentials (stored locally on your device):**
        *   Notion API Key: Required to authorize the app to access your Notion account.
        *   Notion Database ID: Identifies the specific database where your notes will be saved.
        *   Cloudinary Cloud Name: Identifier for your Cloudinary account.
        *   Cloudinary API Key: Key to authorize audio file uploads to your Cloudinary account.
        *   Cloudinary API Secret: Secret associated with your Cloudinary API Key.
        *   *Important:* These external credentials are stored *exclusively* on your device via UserDefaults and sent to our server *only* when necessary to perform requested operations (e.g., saving a note). They are not permanently stored on our servers.
    *   **User Content:**
        *   Audio Files: Audio recordings created with the app.
        *   Text Descriptions: The text you enter as descriptions for your audio notes.

    **3. Data Usage**

    We use the collected data *exclusively* for the following purposes:

    *   Providing the app's main functionality: audio recording, saving to Notion and Cloudinary.
    *   Authenticating and managing your NotlonWatch account.
    *   Allowing the app to interact with your Notion and Cloudinary accounts *based on the credentials you provide*.
    *   Sending app-related notifications (errors, confirmations).
    *   Responding to support requests.

    **4. Data Sharing and Third-Party Services**

    To function, NotlonWatch relies on the following third-party services. We share your data with these services *only* when strictly necessary to provide the app's functionality:

    *   **Firebase (Google):** Used for secure authentication of your NotlonWatch account. See Google's privacy policy: (https://policies.google.com/privacy)
    *   **Cloudinary:** Used to store your audio files. When you save a note, the audio file is uploaded to *your* Cloudinary account (using the credentials you provide). See Cloudinary's privacy policy: (https://cloudinary.com/privacy)
    *   **Notion:** Used to create new pages in the database you specify and save the text description and link to the audio file stored on Cloudinary. Access occurs through *your* API Key. See Notion's privacy policy: (https://www.notion.so/notion/Privacy-Policy-3468d120cf614d4c9014c09f6adc9091)
    *   **NotlonWatch Server (hosted on Render):** Our server acts as an intermediary to handle uploads to Cloudinary and interaction with the Notion API, using the credentials you provide. The server does not permanently store your Notion or Cloudinary credentials.

    We do *not* sell, rent, or share your personal data with third parties for marketing purposes.

    **5. Independence Statement**

    NotlonWatch is an independent application developed by Francesco Fusca. **We are not affiliated, associated, authorized, endorsed by, or in any way officially connected with Notion Labs, Inc. ("Notion") or Cloudinary Ltd. ("Cloudinary").** The use of the names Notion and Cloudinary is purely for identification purposes of the service the app integrates with. The use of Notion and Cloudinary through this app is subject to the respective terms of service and privacy policies of those platforms.

    **6. Legal Basis for Processing (GDPR)**

    If you are in the European Economic Area (EEA), the processing of your data is based on **contract performance** (providing the app service as described) and your **implicit consent** by providing the necessary credentials for integration with Notion and Cloudinary.

    **7. Data Retention**

    *   **Firebase Account:** Retained until you delete it.
    *   **Local Credentials (Notion, Cloudinary):** Stored in UserDefaults until you log out, delete your account, or uninstall the app.
    *   **Data on Third-Party Services (Audio on Cloudinary, Notes on Notion):** Retention depends on the policies and your settings on Cloudinary and Notion.

    **8. Your Rights**

    You have the right to access, rectify, and delete your data. You can manage Notion and Cloudinary credentials in the app settings. You can delete your Firebase account from the app. For other rights, contact us.

    **9. Data Security**

    We adopt industry-standard security measures, including HTTPS and secure password management through Firebase. The security of your Notion and Cloudinary credentials stored locally also depends on your device's security.

    **10. Policy Changes**

    We may update this policy. We will inform you of significant changes. The updated version will be available in the app.

    **11. Contact**

    For questions, contact:
    Francesco Fusca / NotlonWatch
    francescofusca9@gmail.com
    """

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(privacyPolicyText)
                    .font(.caption) // Riduci un po' la dimensione per watchOS
                    .padding()

                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
            }
            .navigationTitle("Privacy Policy") // Aggiungi titolo alla NavigationView
        }
    }
}
