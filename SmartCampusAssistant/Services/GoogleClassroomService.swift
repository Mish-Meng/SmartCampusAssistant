import Foundation

/// Placeholder for Google Classroom API integration.
/// Replace with Google Sign-In + Classroom API calls when backend credentials are configured.
final class GoogleClassroomService {
    static let shared = GoogleClassroomService()

    func fetchAssignments() async throws -> [ClassroomAssignment] {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        let calendar = Calendar.current
        let today = Date()

        return [
            ClassroomAssignment(
                id: "gc-1",
                title: "Cost Accounting Case Study",
                courseName: "BBT3105 Cost Accounting",
                dueDate: calendar.date(byAdding: .day, value: 3, to: today),
                status: .assigned,
                maxPoints: 20
            ),
            ClassroomAssignment(
                id: "gc-2",
                title: "IT Project Sprint Report",
                courseName: "BBT 2204 IT Project I",
                dueDate: calendar.date(byAdding: .day, value: 5, to: today),
                status: .assigned,
                maxPoints: 15
            ),
            ClassroomAssignment(
                id: "gc-3",
                title: "Business Process Diagram",
                courseName: "BBT3102 Business Process Management",
                dueDate: calendar.date(byAdding: .day, value: -1, to: today),
                status: .missing,
                maxPoints: 10
            ),
            ClassroomAssignment(
                id: "gc-4",
                title: "Database Normalization Quiz",
                courseName: "BBT2203 Database Systems",
                dueDate: calendar.date(byAdding: .day, value: 7, to: today),
                status: .turnedIn,
                maxPoints: 25
            )
        ]
    }
}
