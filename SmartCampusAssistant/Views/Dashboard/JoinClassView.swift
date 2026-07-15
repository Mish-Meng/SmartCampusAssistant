import SwiftUI

struct JoinClassView: View {
    @StateObject private var viewModel = JoinClassViewModel()
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                gatewayHeader

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 16)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.classes) { virtualClass in
                            VirtualClassCard(virtualClass: virtualClass) {
                                join(virtualClass)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var gatewayHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "video.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(AppTheme.magenta.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text("Virtual Classroom Gateway")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("Select a class to join your online session or manage meeting links.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 16)
    }

    private func join(_ virtualClass: VirtualClass) {
        guard let url = viewModel.joinClass(virtualClass) else { return }
        openURL(url)
    }
}

struct VirtualClassCard: View {
    let virtualClass: VirtualClass
    let onJoin: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                platformBadge
                Spacer()
                platformIcon
            }

            Text(virtualClass.courseTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(3)
                .frame(height: 60, alignment: .topLeading)

            VStack(alignment: .leading, spacing: 6) {
                if let meetingID = virtualClass.meetingID {
                    DetailRow(label: "ID", value: meetingID)
                }
                if let passcode = virtualClass.passcode {
                    DetailRow(label: "Code", value: passcode)
                }
                DetailRow(label: "Lecturer", value: virtualClass.lecturer)
            }

            Text(virtualClass.joinDetailsSummary)
                .font(.caption2)
                .foregroundStyle(.secondary)

            if virtualClass.hasJoinLink {
                Button(action: onJoin) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.right.square")
                        Text("Join Now")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.purple)
                }
                .padding(.top, 4)
            }
        }
        .padding(16)
        .frame(width: 260)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
    }

    private var platformBadge: some View {
        Text(virtualClass.platform.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.15))
            .foregroundStyle(badgeColor)
            .clipShape(Capsule())
    }

    private var platformIcon: some View {
        Image(systemName: virtualClass.platform.icon)
            .font(.body)
            .foregroundStyle(.blue)
            .frame(width: 36, height: 36)
            .background(Color.blue.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var badgeColor: Color {
        switch virtualClass.platform.badgeColor {
        case "purple": return AppTheme.purple
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        default: return .gray
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(label):")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption)
                .foregroundStyle(.primary)
                .lineLimit(2)
        }
    }
}

#Preview {
    JoinClassView()
}
