import Foundation

struct ClassroomAssignment: Identifiable, Hashable {
    let id: String
    let title: String
    let courseName: String
    let dueDate: Date?
    let status: AssignmentStatus
    let maxPoints: Int?

    enum AssignmentStatus: String {
        case assigned = "Assigned"
        case turnedIn = "Turned In"
        case missing = "Missing"
        case graded = "Graded"
    }

    var dueDateText: String {
        guard let dueDate else { return "No due date" }
        return dueDate.formatted(date: .abbreviated, time: .shortened)
    }
}
