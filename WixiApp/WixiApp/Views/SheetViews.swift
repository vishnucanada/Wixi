import SwiftUI

// MARK: - Contact Driver Sheet

struct ContactDriverSheet: View {
    @Environment(\.dismiss) private var dismiss

    private let messages = [
        ("I'm at the pickup point", "1 min ago"),
        ("On my way! Be there in 3 minutes 😊", "Just now"),
    ]

    @State private var newMessage = ""
    @State private var chatMessages: [(String, String, Bool)] = []

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Chat with driver")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Elena K. · Toyota Corolla")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.gray500)
                }
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.gray500)
                        .frame(width: 32, height: 32)
                        .background(Theme.gray100)
                        .clipShape(Circle())
                }
            }
            .padding(20)

            Divider()

            // Messages
            ScrollView {
                VStack(spacing: 12) {
                    // Pre-loaded messages
                    ForEach(Array(messages.enumerated()), id: \.offset) { idx, msg in
                        MessageBubble(text: msg.0, time: msg.1, isUser: idx == 0)
                    }
                    // User sent messages
                    ForEach(Array(chatMessages.enumerated()), id: \.offset) { _, msg in
                        MessageBubble(text: msg.0, time: msg.1, isUser: msg.2)
                    }
                }
                .padding(20)
            }

            Divider()

            // Quick replies
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["I'm here", "Running late", "Thanks!", "See you soon"], id: \.self) { reply in
                        Button(action: { sendMessage(reply) }) {
                            Text(reply)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Theme.navy)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Theme.pinkLight)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }

            // Input
            HStack(spacing: 12) {
                TextField("Type a message...", text: $newMessage)
                    .font(.system(size: 15))
                    .padding(12)
                    .background(Theme.gray50)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Button(action: {
                    if !newMessage.isEmpty {
                        sendMessage(newMessage)
                        newMessage = ""
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Theme.navy)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    private func sendMessage(_ text: String) {
        chatMessages.append((text, "Just now", true))
        // Auto-reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let replies = ["Got it! 👍", "Perfect, see you soon!", "Almost there! 🚗", "No problem 😊"]
            chatMessages.append((replies.randomElement()!, "Just now", false))
        }
    }
}

struct MessageBubble: View {
    let text: String
    let time: String
    let isUser: Bool

    var body: some View {
        HStack {
            if isUser { Spacer() }
            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                Text(text)
                    .font(.system(size: 15))
                    .foregroundStyle(isUser ? .white : Theme.gray900)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isUser ? Theme.navy : Theme.gray100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Text(time)
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.gray400)
            }
            if !isUser { Spacer() }
        }
    }
}

// MARK: - Share Trip Sheet

struct ShareTripSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var shared = false

    private let contacts = [
        ("Mom", "M", Theme.pinkDark),
        ("Dad", "D", Theme.navy),
        ("Sofia", "S", Theme.navyLight),
        ("Anna", "A", Theme.pink),
    ]

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Share your trip")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.gray500)
                        .frame(width: 32, height: 32)
                        .background(Theme.gray100)
                        .clipShape(Circle())
                }
            }

            Text("Share your live location and trip details with someone you trust.")
                .font(.system(size: 14))
                .foregroundStyle(Theme.gray500)

            // Contacts
            VStack(spacing: 12) {
                ForEach(Array(contacts.enumerated()), id: \.offset) { _, contact in
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(contact.2)
                                .frame(width: 44, height: 44)
                            Text(contact.1)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        Text(contact.0)
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        if shared {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.green)
                        } else {
                            Image(systemName: "paperplane")
                                .foregroundStyle(Theme.navy)
                        }
                    }
                    .padding(12)
                    .background(Theme.gray50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            Button(action: {
                withAnimation { shared = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { dismiss() }
            }) {
                Text(shared ? "Shared!" : "Share with all")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(shared ? Color(Theme.green) : Theme.navy)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(24)
    }
}

// MARK: - Safety Sheet

struct SafetySheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Safety tools")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.gray500)
                        .frame(width: 32, height: 32)
                        .background(Theme.gray100)
                        .clipShape(Circle())
                }
            }

            VStack(spacing: 12) {
                SafetyRow(icon: "phone.fill", title: "Emergency call", subtitle: "Call 112 with your location shared automatically", color: .red)
                SafetyRow(icon: "location.fill", title: "Share live location", subtitle: "Send real-time location to your trusted contacts", color: Theme.navy)
                SafetyRow(icon: "shield.fill", title: "Report an issue", subtitle: "Let our safety team know about any concerns", color: Theme.pinkDark)
                SafetyRow(icon: "questionmark.circle.fill", title: "24/7 Wixi support", subtitle: "Our all-women support team is always here", color: Theme.navyLight)
            }

            Text("Your safety is our priority. All Wixi drivers are verified women who have passed background checks.")
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray400)
                .multilineTextAlignment(.center)
        }
        .padding(24)
    }
}

struct SafetyRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.gray500)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundStyle(Theme.gray400)
        }
        .padding(14)
        .background(Theme.gray50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
