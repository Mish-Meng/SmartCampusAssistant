import SwiftUI

enum AppTheme {
    static let accent = Color("AccentColor")
    static let purple = Color(red: 0.55, green: 0.27, blue: 0.95)
    static let magenta = Color(red: 0.91, green: 0.30, blue: 0.58)
    static let primaryGradient = LinearGradient(
        colors: [purple, magenta],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let campusGreen = Color(red: 0.12, green: 0.45, blue: 0.32)
    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let screenBackground = Color(.systemGroupedBackground)

    static let cornerRadius: CGFloat = 12
    static let cardPadding: CGFloat = 16
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.cardPadding)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
