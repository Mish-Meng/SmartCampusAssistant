import SwiftUI

struct DashboardMenuBottomNav: View {
    @Binding var selectedItem: DashboardMenuItem

    var body: some View {
        HStack(spacing: 0) {
            ForEach(DashboardMenuItem.allCases) { item in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedItem = item
                    }
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedItem == item {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 48, height: 36)
                            }

                            ZStack(alignment: .topTrailing) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 20))
                                    .foregroundStyle(selectedItem == item ? .primary : .secondary)
                                    .frame(width: 28, height: 28)

                                if let count = item.badgeCount {
                                    Text("\(count)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(Color.green)
                                        .clipShape(Capsule())
                                        .offset(x: 8, y: -6)
                                }
                            }
                        }
                        .frame(height: 36)

                        Text(item.shortLabel)
                            .font(.system(size: 10))
                            .fontWeight(selectedItem == item ? .semibold : .regular)
                            .foregroundStyle(selectedItem == item ? .primary : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

#Preview {
    DashboardMenuBottomNav(selectedItem: .constant(.standupTasks))
        .background(Color(.systemGroupedBackground))
}
