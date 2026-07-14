import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var selectedTab: DashboardTab = .dashboard
    @Published var selectedMenuItem: DashboardMenuItem = .standupTasks
    @Published var searchText = ""
    @Published var columns: [TaskColumn] = []

    init() {
        loadSampleData()
    }

    var filteredColumns: [TaskColumn] {
        guard !searchText.isEmpty else { return columns }

        return columns.map { column in
            let filtered = column.tasks.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
            return TaskColumn(id: column.id, tasks: filtered)
        }
    }

    private func loadSampleData() {
        let lectures = [
            LectureTask(
                id: UUID(),
                title: "BBT3105 Cost Accounting for I",
                time: "4:15 PM",
                location: "STM-B F1-02",
                priority: .medium
            ),
            LectureTask(
                id: UUID(),
                title: "BBT 2204 IT Project I (Regular)",
                time: "7:15 PM",
                location: "Online/Virtual",
                priority: .medium
            ),
            LectureTask(
                id: UUID(),
                title: "BBT3102 Business Process Management",
                time: "2:00 PM",
                location: "STM-A L2-14",
                priority: .medium
            ),
            LectureTask(
                id: UUID(),
                title: "BBT2203 Database Systems",
                time: "10:30 AM",
                location: "STM-B F1-05",
                priority: .high
            )
        ]

        columns = [
            TaskColumn(id: .yesterday, tasks: []),
            TaskColumn(id: .today, tasks: []),
            TaskColumn(id: .inProgress, tasks: []),
            TaskColumn(id: .analysed, tasks: lectures)
        ]
    }
}
