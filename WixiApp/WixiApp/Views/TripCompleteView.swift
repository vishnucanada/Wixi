import SwiftUI

struct TripCompleteView: View {
    let destination: TripDestination
    let ride: RideOption
    let driver: Driver
    let onDone: () -> Void
    @State private var selectedRating: Int = 0
    @State private var showThanks = false
    @State private var tipAmount: Double? = nil

    private let tips: [Double] = [1, 2, 5]

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            VStack(spacing: 20) {
                if showThanks {
                    thanksView
                } else {
                    ratingView
                }
            }
            .padding(24)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
    }

    // MARK: - Rating View

    private var ratingView: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Theme.green)
                Text("You've arrived!")
                    .font(.system(size: 20, weight: .semibold))
                Text(destination.name)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.gray500)
            }

            Divider()

            // Trip summary
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(ride.name)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.gray500)
                    Text(destination.distance + " · " + destination.duration)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.gray400)
                }
                Spacer()
                Text(String(format: "€%.2f", ride.price + (tipAmount ?? 0)))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.navy)
            }
            .padding(14)
            .background(Theme.gray50)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // Rate driver
            VStack(spacing: 10) {
                Text("Rate \(driver.name)")
                    .font(.system(size: 16, weight: .semibold))

                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) { selectedRating = star }
                        }) {
                            Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                .font(.system(size: 28))
                                .foregroundStyle(star <= selectedRating ? .orange : Theme.gray200)
                                .scaleEffect(star <= selectedRating ? 1.1 : 1.0)
                        }
                    }
                }
            }

            // Tip
            VStack(spacing: 10) {
                Text("Add a tip?")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.gray600)

                HStack(spacing: 10) {
                    ForEach(tips, id: \.self) { amount in
                        Button(action: {
                            withAnimation { tipAmount = tipAmount == amount ? nil : amount }
                        }) {
                            Text(String(format: "€%.0f", amount))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(tipAmount == amount ? .white : Theme.navy)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(tipAmount == amount ? Theme.navy : Theme.pinkLight)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }

            // Submit
            Button(action: {
                withAnimation(.spring(response: 0.5)) { showThanks = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { onDone() }
            }) {
                Text(selectedRating > 0 ? "Submit rating" : "Skip")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Theme.navy)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Thanks View

    private var thanksView: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 20)

            Text("💜")
                .font(.system(size: 56))

            Text("Thank you!")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Theme.navy)

            Text("We hope you had a safe and comfortable ride with Wixi.")
                .font(.system(size: 15))
                .foregroundStyle(Theme.gray500)
                .multilineTextAlignment(.center)

            if selectedRating > 0 {
                HStack(spacing: 4) {
                    ForEach(1...selectedRating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.orange)
                    }
                }
            }

            Spacer().frame(height: 20)
        }
    }
}
