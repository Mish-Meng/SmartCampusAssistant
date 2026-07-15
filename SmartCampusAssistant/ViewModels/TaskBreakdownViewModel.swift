import Foundation

@MainActor
final class TaskBreakdownViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var isGenerating = false
    @Published var statusMessage: String?

    func uploadTimetable() {
        statusMessage = "Photo picker coming soon — paste your timetable text for now."
    }

    func recordVoiceNote() {
        statusMessage = "Voice recording coming soon — describe your tasks in the text field."
    }

    func generateTasks() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            statusMessage = "Paste your timetable, syllabus, or task notes first."
            return
        }

        isGenerating = true
        statusMessage = nil

        // Placeholder until Gemini API is connected.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            self?.isGenerating = false
            self?.statusMessage = "Tasks generated! Check Standup Tasks to review them."
            self?.inputText = ""
        }
    }
}
