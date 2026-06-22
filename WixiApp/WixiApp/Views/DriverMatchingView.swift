import SwiftUI

struct DriverMatchingView: View {
    @State private var pulseScale: CGFloat = 0.8
    @State private var pulseOpacity: Double = 1.0
    @State private var dotPhase: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            VStack(spacing: 24) {
                Spacer().frame(height: 16)

                // Pulsing icon
                ZStack {
                    Circle()
                        .stroke(Theme.pink, lineWidth: 3)
                        .frame(width: 100, height: 100)
                        .scaleEffect(pulseScale)
                        .opacity(pulseOpacity)

                    Circle()
                        .stroke(Theme.pink.opacity(0.5), lineWidth: 2)
                        .frame(width: 100, height: 100)
                        .scaleEffect(pulseScale * 1.3)
                        .opacity(pulseOpacity * 0.6)

                    Text("🚗")
                        .font(.system(size: 44))
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        pulseScale = 1.2
                        pulseOpacity = 0.3
                    }
                }

                // Text
                Text("Finding your driver...")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.navy)

                Text("Looking for available Wixi drivers nearby")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.gray500)
                    .multilineTextAlignment(.center)

                // Loading dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(Theme.pink)
                            .frame(width: 10, height: 10)
                            .scaleEffect(dotPhase == i ? 1.3 : 0.8)
                            .opacity(dotPhase == i ? 1.0 : 0.4)
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dotPhase = (dotPhase + 1) % 3
                        }
                    }
                }

                Spacer().frame(height: 16)
            }
            .padding(24)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
    }
}
