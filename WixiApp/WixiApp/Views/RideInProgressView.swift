import SwiftUI

struct RideInProgressView: View {
    let destination: TripDestination
    let ride: RideOption
    let driver: Driver
    let onShare: () -> Void
    let onSafety: () -> Void
    let onComplete: () -> Void
    @State private var progress: CGFloat = 0
    @State private var minutesLeft: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            VStack(spacing: 16) {
                // Status
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("On your way")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.gray900)
                        Text("Arriving in \(minutesLeft) min")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.gray500)
                    }
                    Spacer()
                    Text(ride.name)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.navy)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.pinkLight)
                        .clipShape(Capsule())
                }

                // Progress bar
                VStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Theme.gray200)
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Theme.navy)
                                .frame(width: geo.size.width * progress, height: 6)
                                .animation(.linear(duration: 1.0), value: progress)
                        }
                    }
                    .frame(height: 6)

                    HStack {
                        HStack(spacing: 6) {
                            Circle().fill(Theme.navy).frame(width: 8, height: 8)
                            Text("Syntagma")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.gray400)
                        }
                        Spacer()
                        HStack(spacing: 6) {
                            Text(destination.shortName)
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.gray400)
                            Circle().fill(Theme.pinkDark).frame(width: 8, height: 8)
                        }
                    }
                }

                // Driver mini card
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.pink)
                            .frame(width: 44, height: 44)
                        Text(driver.initials)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.navy)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(driver.name)
                            .font(.system(size: 15, weight: .semibold))
                        Text("\(driver.car) · \(driver.plate)")
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.gray500)
                    }
                    Spacer()
                    Text(String(format: "€%.2f", ride.price))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.navy)
                }
                .padding(14)
                .background(Theme.gray50)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Action row
                HStack(spacing: 12) {
                    Button(action: onShare) {
                        VStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18))
                            Text("Share")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Theme.navy)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Theme.pinkLight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Button(action: onSafety) {
                        VStack(spacing: 6) {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 18))
                            Text("Safety")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Theme.navy)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Theme.pinkLight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Button(action: onComplete) {
                        VStack(spacing: 6) {
                            Image(systemName: "flag.fill")
                                .font(.system(size: 18))
                            Text("Arrive")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Theme.navy)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(24)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
        .onAppear {
            minutesLeft = Int(destination.duration.filter { $0.isNumber }) ?? 20
            // Animate progress
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if progress < 0.95 {
                    withAnimation { progress += 0.03 }
                    if minutesLeft > 1 { minutesLeft -= 1 }
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}
