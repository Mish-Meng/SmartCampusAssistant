import Foundation

@MainActor
final class AssignmentsViewModel: ObservableObject {
    @Published var assignments: [ClassroomAssignment] = []
    @Published var isSyncing = false
    @Published var isGoogleClassroomConnected = false
    @Published var searchText = ""
    @Published var errorMessage: String?
    @Published var lastSyncedAt: Date?

    var filteredAssignments: [ClassroomAssignment] {
        guard !searchText.isEmpty else { return assignments }
        return assignments.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.courseName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var isEmpty: Bool {
        filteredAssignments.isEmpty
    }

    func syncWithGoogleClassroom() {
        guard !isSyncing else { return }

        isSyncing = true
        errorMessage = nil

        Task {
            do {
                let fetched = try await GoogleClassroomService.shared.fetchAssignments()
                assignments = fetched
                isGoogleClassroomConnected = true
                lastSyncedAt = Date()
            } catch {
                errorMessage = "Could not sync with Google Classroom. Try again."
            }
            isSyncing = false
        }
    }

    func syncNew() {
        syncWithGoogleClassroom()
    }
}
