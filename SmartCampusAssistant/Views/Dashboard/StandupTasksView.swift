import SwiftUI

struct StandupTasksView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    categoryGrid
                    AIAssistantBanner()
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationDestination(for: TaskColumnKind.self) { kind in
                TaskCategoryDetailView(
                    kind: kind,
                    tasks: viewModel.tasks(for: kind)
                )
            }
        }
    }

    private var categoryGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(TaskColumnKind.allCases) { kind in
                NavigationLink(value: kind) {
                    TaskCategoryCard(
                        kind: kind,
                        count: viewModel.count(for: kind)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Category Card

struct TaskCategoryCard: View {
    let kind: TaskColumnKind
    let count: Int

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(kind.iconColor.opacity(0.15))
                    .frame(width: 72, height: 72)

                Image(systemName: kind.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(kind.iconColor)
            }

            VStack(spacing: 4) {
                Text(kind.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                if count > 0 {
                    Text("\(count) task\(count == 1 ? "" : "s")")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.dashboardCardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.dashboardCardRadius)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Category Detail

struct TaskCategoryDetailView: View {
    let kind: TaskColumnKind
    let tasks: [LectureTask]

    var body: some View {
        Group {
            if tasks.isEmpty {
                ContentUnavailableView(
                    "No tasks yet",
                    systemImage: kind.icon,
                    description: Text("Tasks in \(kind.rawValue) will appear here.")
                )
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(tasks) { task in
                            TaskDetailCard(task: task)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationTitle(kind.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }
}

struct TaskDetailCard: View {
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
