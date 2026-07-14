import SwiftUI

struct AssistantView: View {
    @StateObject private var viewModel = AssistantViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: viewModel.messages.count) {
                        if let last = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }

                Divider()

                HStack(spacing: 12) {
                    TextField("Ask about campus...", text: $viewModel.inputText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...4)

                    Button {
                        viewModel.sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                    }
                    .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(AppTheme.cardBackground)
            }
            .navigationTitle("Assistant")
        }
    }
}

struct ChatBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser { Spacer(minLength: 48) }

            Text(message.content)
                .padding(12)
                .background(message.isFromUser ? AppTheme.campusGreen : AppTheme.cardBackground)
                .foregroundStyle(message.isFromUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            if !message.isFromUser { Spacer(minLength: 48) }
        }
    }
}

#Preview {
    AssistantView()
}
