import SwiftUI

struct LandingView: View {
    @State private var currentPage = 0
    @State private var showApp = false

    private let slides: [(image: String, headline: String, body: String)] = [
        (
            image: "1",
            headline: "Safe. Every single ride.",
            body: "Every WiXi driver is a woman.\nEvery WiXi passenger is a woman.\nNo exceptions — ever."
        ),
        (
            image: "2",
            headline: "Driven by women.\nDesigned for women.",
            body: "WiXi is the first taxi service in the world\nconsisting exclusively of women drivers,\nserving exclusively women passengers."
        ),
        (
            image: "5",
            headline: "Our innovation.\nYour freedom.",
            body: "A women-only ride experience —\npioneered by WiXi, built for you.\nRide confidently, every time."
        ),
    ]

    var body: some View {
        if showApp {
            HomeView()
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .opacity
                ))
        } else {
            landingContent
                .transition(.opacity)
        }
    }

    // MARK: - Landing Content

    private var landingContent: some View {
        ZStack(alignment: .bottom) {
            // Full-screen image carousel
            TabView(selection: $currentPage) {
                ForEach(0..<slides.count, id: \.self) { i in
                    GeometryReader { geo in
                        Image(slides[i].image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }
                    .ignoresSafeArea()
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // Gradient overlay: bottom two-thirds fades to navy
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: Theme.navy.opacity(0.6), location: 0.35),
                    .init(color: Theme.navy.opacity(0.95), location: 0.6),
                    .init(color: Theme.navy, location: 1),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Bottom content panel
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 28) {
                    // WiXi logotype
                    wiXiLogo

                    // Slide text
                    VStack(spacing: 10) {
                        Text(slides[currentPage].headline)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .id("headline-\(currentPage)")
                            .transition(.opacity.combined(with: .move(edge: .bottom)))

                        Text(slides[currentPage].body)
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.72))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                            .id("body-\(currentPage)")
                            .transition(.opacity)
                    }
                    .animation(.easeInOut(duration: 0.35), value: currentPage)

                    // Page dots
                    HStack(spacing: 7) {
                        ForEach(0..<slides.count, id: \.self) { i in
                            Capsule()
                                .fill(i == currentPage ? Theme.pinkDark : .white.opacity(0.35))
                                .frame(width: i == currentPage ? 26 : 8, height: 8)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                        }
                    }

                    // CTA buttons
                    VStack(spacing: 12) {
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                showApp = true
                            }
                        } label: {
                            Text("Get Started")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Theme.navy)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        // Women-only badge
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.pinkDark)
                            Text("Women drivers · Women passengers · Always")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 48)
            }
        }
    }

    // MARK: - Logo

    private var wiXiLogo: some View {
        HStack(spacing: 0) {
            Text("Wi")
                .font(.system(size: 48, weight: .light, design: .serif))
                .italic()
                .foregroundStyle(.white)
            Text("X")
                .font(.system(size: 48, weight: .bold, design: .serif))
                .foregroundStyle(Theme.pinkDark)
            Text("i")
                .font(.system(size: 48, weight: .light, design: .serif))
                .italic()
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    LandingView()
}
