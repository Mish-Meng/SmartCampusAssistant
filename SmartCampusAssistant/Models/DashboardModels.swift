import Foundation

enum TaskPriority: String, CaseIterable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
}

enum TaskColumnKind: String, CaseIterable, Identifiable {
    case yesterday = "Yesterday"
    case today = "Today"
    case inProgress = "In Progress"
    case analysed = "Analysed"

    var id: String { rawValue }
}

enum DashboardMenuItem: String, CaseIterable, Identifiable {
    case standupTasks = "Standup Tasks"
    case taskBreakdown = "Task Breakdown"
    case campusChat = "Campus Chat"
    case assignments = "Assignments"
    case joinClass = "Join Class"
    case integrations = "Integrations"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .standupTasks: return "checklist"
        case .taskBreakdown: return "square.grid.2x2"
        case .campusChat: return "bubble.left.and.bubble.right"
        case .assignments: return "doc.text"
        case .joinClass: return "video"
        case .integrations: return "link"
        }
    }
}

enum DashboardTab: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case calendar = "Calendar"
    case settings = "Settings"

    var id: String { rawValue }
}

struct LectureTask: Identifiable, Hashable {
    let id: UUID
    let title: String
    let time: String
    let location: String
    let priority: TaskPriority
}

struct TaskColumn: Identifiable {
    let id: TaskColumnKind
    let tasks: [LectureTask]

    var title: String { id.rawValue }
    var count: Int { tasks.count }
}
