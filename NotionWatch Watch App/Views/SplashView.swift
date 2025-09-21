//  NotionWatch/Views/SplashView.swift
import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.2),
                    Color.black.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // Main icon with animation
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotationAngle))
                        .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)

                    Text("👁️")
                        .font(.system(size: 40))
                        .scaleEffect(scale)
                        .opacity(opacity)
                }

                // App name
                VStack(spacing: 4) {
                    Text("NotionWatch")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(opacity)
                        .scaleEffect(scale)

                    Text("Audio Notes for Apple Watch")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .opacity(opacity * 0.8)
                        .scaleEffect(scale * 0.9)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }

            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

#if DEBUG
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
#endif