import SwiftUI

struct RideSelectionView: View {
    let destination: TripDestination
    @Binding var selectedRide: RideOption?
    let onConfirm: (RideOption) -> Void
    let onBack: () -> Void

    private var rides: [RideOption] {
        rideOptions(for: destination.basePrice)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Handle
            Capsule()
                .fill(Theme.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            VStack(alignment: .leading, spacing: 16) {
                // Header with back button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.navy)
                    }
                    Spacer()
                    Text("Choose a ride")
                        .font(.system(size: 18, weight: .semibold))
                    Spacer()
                    // Spacer for alignment
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .opacity(0)
                }

                // Trip summary
                VStack(spacing: 4) {
                    HStack(spacing: 8) {
                        Text("Syntagma Square")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.gray600)
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(Theme.pinkDark)
                        Text(destination.name)
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.gray600)
                            .lineLimit(1)
                    }
                    Text("\(destination.distance) · \(destination.duration)")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.gray400)
                }

                // Women-only innovation banner
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Theme.pinkDark)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Women ONLY — Our Innovation")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Theme.navy)
                        Text("Every WiXi driver is a woman. Only women passengers accepted.")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.gray500)
                    }
                    Spacer()
                }
                .padding(12)
                .background(Theme.blush)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.pinkDark.opacity(0.4), lineWidth: 1))

                Divider()

                // Ride options
                ForEach(rides) { ride in
                    RideOptionCard(
                        ride: ride,
                        isSelected: selectedRide?.id == ride.id,
                        onTap: { selectedRide = ride }
                    )
                }

                // Payment row
                HStack(spacing: 10) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.gray500)
                    Text("Personal · Visa ****4242")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.gray600)
                    Spacer()
                    Text("Change")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.navy)
                }
                .padding(14)
                .background(Theme.gray50)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Confirm button
                Button(action: {
                    if let ride = selectedRide {
                        onConfirm(ride)
                    }
                }) {
                    Text("Request \(selectedRide?.name ?? "WiXi")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(Theme.navy)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(24)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
    }
}

// MARK: - Ride Option Card

struct RideOptionCard: View {
    let ride: RideOption
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Theme.pinkLight : Theme.gray100)
                        .frame(width: 48, height: 48)
                    Image(systemName: ride.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.navy)
                }

                // Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(ride.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.gray900)
                    Text(ride.description)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.gray500)
                }

                Spacer()

                // Price & ETA
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "€%.2f", ride.price))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.gray900)
                    Text("\(ride.eta) min")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.gray500)
                }
            }
            .padding(14)
            .background(isSelected ? Theme.blush : .white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Theme.navy : Theme.gray200, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}
