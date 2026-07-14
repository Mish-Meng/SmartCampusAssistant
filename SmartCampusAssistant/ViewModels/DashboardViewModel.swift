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

    func tasks(for kind: TaskColumnKind) -> [LectureTask] {
        columns.first { $0.id == kind }?.tasks ?? []
    }

    func count(for kind: TaskColumnKind) -> Int {
        tasks(for: kind).count
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
        let analysedLectures = [
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
            )
        ]

        let todayTasks = [
            LectureTask(
                id: UUID(),
                title: "BBT2203 Database Systems",
                time: "10:30 AM",
                location: "STM-B F1-05",
                priority: .high
            )
        ]

        let inProgressTasks = [
            LectureTask(
                id: UUID(),
                title: "Lab Report — Data Structures",
                time: "Due 5:00 PM",
                location: "Online Submission",
                priority: .high
            )
        ]

        let accomplishedTasks = [
            LectureTask(
                id: UUID(),
                title: "BBT2101 Introduction to Programming",
                time: "Completed",
                location: "STM-A L1-03",
                priority: .low
            )
        ]

        columns = [
            TaskColumn(id: .yesterday, tasks: []),
            TaskColumn(id: .today, tasks: todayTasks),
            TaskColumn(id: .inProgress, tasks: inProgressTasks),
            TaskColumn(id: .analysed, tasks: analysedLectures),
            TaskColumn(id: .accomplished, tasks: accomplishedTasks),
            TaskColumn(id: .closed, tasks: [])
        ]
    }
}
