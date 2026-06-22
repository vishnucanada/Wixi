import SwiftUI

struct DriverFoundView: View {
    let destination: TripDestination
    let ride: RideOption
    let driver: Driver
    let onCancel: () -> Void
    let onContact: () -> Void
    let onStartRide: () -> Void
    @State private var appeared = false
    @State private var etaCountdown: Int = 0
    @State private var driverArrived = false

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            VStack(alignment: .leading, spacing: 16) {
                // Success badge
                HStack {
                    Spacer()
                    Text(driverArrived ? "Driver arrived!" : "Driver found!")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.green)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Theme.greenLight)
                        .clipShape(Capsule())
                    Spacer()
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : -10)

                // Driver card
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Theme.pink)
                            .frame(width: 56, height: 56)
                        Text(driver.initials)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Theme.navy)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(driver.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.gray900)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(.orange)
                            Text(String(format: "%.2f", driver.rating))
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.gray600)
                        }
                    }

                    Spacer()

                    // Quick actions
                    HStack(spacing: 8) {
                        Button(action: onContact) {
                            Image(systemName: "message.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.navy)
                                .frame(width: 36, height: 36)
                                .background(Theme.pinkLight)
                                .clipShape(Circle())
                        }
                        Button(action: onContact) {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.navy)
                                .frame(width: 36, height: 36)
                                .background(Theme.pinkLight)
                                .clipShape(Circle())
                        }
                    }
                }

                // Car details
                HStack {
                    Text(driver.car)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.gray600)
                    Spacer()
                    Text(driver.plate)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.navy)
                }
                .padding(14)
                .background(Theme.gray100)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // ETA countdown
                VStack(spacing: 4) {
                    Text(driverArrived ? "Your driver is here" : "Arriving in")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.gray500)
                    if !driverArrived {
                        Text("\(etaCountdown) min")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Theme.navy)
                            .contentTransition(.numericText())
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(Theme.green)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(driverArrived ? Theme.greenLight : Theme.pinkLight)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .animation(.easeInOut, value: driverArrived)

                // Route + price
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Circle().fill(Theme.navy).frame(width: 10, height: 10)
                            Text("Syntagma Square")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.gray600)
                        }
                        HStack(spacing: 10) {
                            Circle().fill(Theme.pinkDark).frame(width: 10, height: 10)
                            Text(destination.name)
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.gray600)
                                .lineLimit(1)
                        }
                    }
                    Spacer()
                    Text(String(format: "€%.2f", ride.price))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Theme.navy)
                }
                .padding(.vertical, 12)

                // Action buttons
                if driverArrived {
                    Button(action: onStartRide) {
                        Text("Start ride")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Theme.navy)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                } else {
                    HStack(spacing: 12) {
                        Button(action: onCancel) {
                            Text("Cancel ride")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Theme.gray600)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.gray200, lineWidth: 1.5))
                        }
                        Button(action: onContact) {
                            Text("Contact driver")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Theme.navy)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            .padding(24)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
        .onAppear {
            etaCountdown = driver.eta
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                appeared = true
            }
            // Countdown timer
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
                if etaCountdown > 0 {
                    withAnimation { etaCountdown -= 1 }
                } else {
                    timer.invalidate()
                    withAnimation { driverArrived = true }
                }
            }
        }
    }
}
