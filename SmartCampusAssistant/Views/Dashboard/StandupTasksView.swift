import SwiftUI

struct StandupTasksView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 0) {
            DashboardToolbar(searchText: $viewModel.searchText)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 14) {
                    ForEach(viewModel.filteredColumns) { column in
                        KanbanColumnView(column: column)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            AIAssistantBanner()
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
    }
}

struct KanbanColumnView: View {
    let column: TaskColumn

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Circle()
                    .fill(column.id.columnDotColor)
                    .frame(width: 8, height: 8)

                Text(column.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("\(column.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                } label: {
                    Image(systemName: "plus")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if column.tasks.isEmpty {
                emptyColumnPlaceholder
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(column.tasks) { task in
                            KanbanTaskCard(task: task)
                        }
                    }
                }
            }
        }
        .frame(width: 240)
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
    }

    private var emptyColumnPlaceholder: some View {
        VStack(spacing: 10) {
            Text("NO TASKS YET")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color(.systemGray4), style: StrokeStyle(lineWidth: 1, dash: [6]))
                .frame(height: 100)
                .overlay {
                    Image(systemName: "plus")
                        .foregroundStyle(.secondary)
                }
        }
    }
}

struct KanbanTaskCard: View {
    let task: LectureTask

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Color.orange)
                .frame(height: 3)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Text("LECTURE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)

                    Text(task.priority.rawValue)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.15))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())
                }

                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(task.time)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.caption2)
                    Text(task.location)
                        .font(.caption)
                        .lineLimit(1)
                }
                .foregroundStyle(.secondary)
            }
            .padding(12)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    StandupTasksView(viewModel: DashboardViewModel())
}
