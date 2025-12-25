//  NotlonWatch/Views/NotionCredentialsHelpView.swift
import SwiftUI

struct NotionCredentialsHelpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) { // Aumenta spacing
                Text("Credentials Guide")
                    .font(.title2).bold() // Riduci titolo
                    .padding(.bottom)

                // --- Sezione Notion ---
                Group {
                    Text("Notion")
                        .font(.title3).bold() // Sottotitolo
                        .padding(.bottom, 5)

                    Text("1. API Key (Internal Integration Token):")
                        .font(.headline)
                    Text("   a. Go to: notion.so/my-integrations (from computer)")
                    Text("   b. Click '+ New Integration'.")
                    Text("   c. Give it a name (e.g. NotlonWatch App) and choose Workspace.")
                    Text("   d. Click 'Submit'.")
                    Text("   e. On the integration page, go to 'Secrets'.")
                    Text("   f. Click 'Show' and copy the 'Internal Integration Token'. This is your API Key.")
                        .foregroundColor(.gray) // Nota aggiuntiva
                    Image(systemName: "key.fill")
                        .foregroundColor(.blue)

                    Text("2. Database ID:")
                        .font(.headline)
                        .padding(.top)
                    Text("   a. Open the Notion database page you want to use with the app.")
                    Text("   b. Look at the URL in the browser address bar.")
                    Text("   c. The ID is the long string of letters and numbers between `/` and `?`.")
                    Text("      Example: `.../myworkspace/`**`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`**`?v=...`")
                        .font(.caption).foregroundColor(.gray)
                    Text("   d. Copy this string. This is your Database ID.")
                    Image(systemName: "doc.text.magnifyingglass")
                         .foregroundColor(.blue)

                    Text("3. Connect Integration to Database:")
                        .font(.headline)
                        .padding(.top)
                    Text("   a. Go to your Notion database page.")
                    Text("   b. Click the three dots (...) in the top right.")
                    Text("   c. Select 'Add connections'.")
                    Text("   d. Search and select the integration you created (e.g. NotlonWatch App).")
                    Text("   e. Confirm.")
                        .foregroundColor(.gray)
                }
                .padding(.bottom)

                Divider()

                // --- Sezione Cloudinary ---
                Group {
                    Text("Cloudinary")
                        .font(.title3).bold()
                        .padding(.bottom, 5)
                    Text("To save audio files, a Cloudinary account is required (offers a generous free plan).")
                        .font(.footnote).foregroundColor(.gray)
                        .padding(.bottom, 5)

                    Text("1. Create a Cloudinary Account:")
                         .font(.headline)
                    Text("   a. Go to: cloudinary.com")
                    Text("   b. Sign up for a free account.")

                    Text("2. Find Your Credentials:")
                        .font(.headline)
                        .padding(.top)
                    Text("   a. After logging in, go to your 'Dashboard'.")
                    Text("   b. You'll find your 'Cloud Name', 'API Key', and 'API Secret' listed in the main section or account settings.")
                    Text("   c. Copy *exactly* these three values.")
                    Image(systemName: "cloud.fill")
                         .foregroundColor(.orange)

                    Text("3. Enter in App:")
                        .font(.headline)
                        .padding(.top)
                    Text("   a. Return to the 'Settings' screen in NotlonWatch.")
                    Text("   b. Paste the 'Cloud Name', 'API Key', and 'API Secret' values in the corresponding fields.")
                }
                .padding(.bottom)

                Divider()

                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Credentials Help")
    }
}
