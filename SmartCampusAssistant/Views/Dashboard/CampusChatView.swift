import SwiftUI

struct CampusChatView: View {
    @StateObject private var viewModel = AssistantViewModel()

    var body: some View {
        VStack(spacing: 0) {
            chatHeader

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            CampusChatBubbleView(message: message)
                                .id(message.id)
                        }

                        if viewModel.isTyping {
                            TypingIndicatorView()
                        }

                        AssistantTipsCard()
                    }
                    .padding(16)
                }
                .onChange(of: viewModel.messages.count) {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.isTyping) {
                    scrollToBottom(proxy: proxy)
                }
            }

            chatInputBar
        }
        .background(Color(.systemGroupedBackground))
    }

    private var chatHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(AppTheme.primaryGradient)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text("Campus Assistant")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("Ask me anything about your campus life")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    private var chatInputBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 10) {
                Button(action: viewModel.uploadImage) {
                    Image(systemName: "photo")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                Button(action: viewModel.recordVoice) {
                    Image(systemName: "mic")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                TextField("Ask about your classes...", text: $viewModel.inputText, axis: .vertical)
                    .font(.subheadline)
                    .lineLimit(1...4)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.body)
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(AppTheme.primaryGradient)
                        .clipShape(Circle())
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isTyping)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let last = viewModel.messages.last {
            withAnimation {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

struct CampusChatBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if message.isFromUser {
                Spacer(minLength: 40)
            } else {
                assistantAvatar
            }

            Text(message.content)
                .font(.subheadline)
                .padding(12)
                .background(message.isFromUser ? AppTheme.purple : Color(.systemGray6))
                .foregroundStyle(message.isFromUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            if message.isFromUser {
                userAvatar
            } else {
                Spacer(minLength: 40)
            }
        }
    }

    private var assistantAvatar: some View {
        Image(systemName: "brain.head.profile")
            .font(.caption)
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background(AppTheme.primaryGradient)
            .clipShape(Circle())
    }

    private var userAvatar: some View {
        Image(systemName: "person.fill")
            .font(.caption)
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background(AppTheme.purple.opacity(0.7))
            .clipShape(Circle())
    }
}

struct TypingIndicatorView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "brain.head.profile")
                .font(.caption)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(AppTheme.primaryGradient)
                .clipShape(Circle())

            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer(minLength: 40)
        }
    }
}

struct AssistantTipsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(.white)
                Text("Assistant Tips")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                TipRow(text: "Ask \"Where is my next class?\" to find your room number.")
                TipRow(text: "Ask \"What assignments are due?\" for a quick summary.")
                TipRow(text: "Use the **Task Breakdown** module to upload your timetable!")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.infoGradient)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TipRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundStyle(.white)
            Text(.init(text))
                .font(.caption)
                .foregroundStyle(.white.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    CampusChatView()
}
