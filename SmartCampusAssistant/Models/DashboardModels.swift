import Foundation

enum TaskPriority: String, CaseIterable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
}

enum TaskColumnKind: String, CaseIterable, Identifiable, Hashable {
    case yesterday = "Yesterday"
    case today = "Today"
    case inProgress = "In Progress"
    case analysed = "Analysed"
    case accomplished = "Accomplished"
    case closed = "Closed"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .yesterday: return "clock.arrow.circlepath"
        case .today: return "sun.max.fill"
        case .inProgress: return "arrow.triangle.2.circlepath"
        case .analysed: return "chart.bar.doc.horizontal"
        case .accomplished: return "checkmark.seal.fill"
        case .closed: return "archivebox.fill"
        }
    }

    var iconColor: String {
        switch self {
        case .yesterday: return "orange"
        case .today: return "yellow"
        case .inProgress: return "blue"
        case .analysed: return "purple"
        case .accomplished: return "green"
        case .closed: return "gray"
        }
    }
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
