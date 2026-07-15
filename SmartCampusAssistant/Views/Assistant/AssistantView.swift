import SwiftUI

struct AssistantView: View {
    var body: some View {
        NavigationStack {
            CampusChatView()
                .navigationTitle("Assistant")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AssistantView()
}
