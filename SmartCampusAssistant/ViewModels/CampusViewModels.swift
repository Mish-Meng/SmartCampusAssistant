import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var greeting: String = ""
    @Published var upcomingCourses: [Course] = []
    @Published var featuredEvents: [CampusEvent] = []

    init() {
        loadSampleData()
    }

    func refresh() {
        loadSampleData()
    }

    private func loadSampleData() {
        greeting = Self.timeBasedGreeting()

        let calendar = Calendar.current
        let today = Date()
        let hour = calendar.component(.hour, from: today)

        upcomingCourses = [
            Course(
                id: UUID(),
                code: "CS 301",
                name: "Data Structures",
                location: "Science Hall 204",
                startTime: calendar.date(bySettingHour: max(hour + 1, 9), minute: 0, second: 0, of: today)!,
                endTime: calendar.date(bySettingHour: max(hour + 2, 10), minute: 30, second: 0, of: today)!,
                instructor: "Dr. Chen"
            ),
            Course(
                id: UUID(),
                code: "MATH 220",
                name: "Linear Algebra",
                location: "Math Building 112",
                startTime: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: today)!,
                endTime: calendar.date(bySettingHour: 14, minute: 15, second: 0, of: today)!,
                instructor: "Prof. Rivera"
            )
        ]

        featuredEvents = [
            CampusEvent(
                id: UUID(),
                title: "Career Fair",
                location: "Student Union Ballroom",
                date: calendar.date(byAdding: .day, value: 2, to: today)!,
                category: .academic
            ),
            CampusEvent(
                id: UUID(),
                title: "Intramural Soccer",
                location: "North Field",
                date: calendar.date(byAdding: .day, value: 1, to: today)!,
                category: .sports
            )
        ]
    }

    private static func timeBasedGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
}

@MainActor
final class ScheduleViewModel: ObservableObject {
    @Published var courses: [Course] = []

    init() {
        loadSampleData()
    }

    private func loadSampleData() {
        let calendar = Calendar.current
        let today = Date()

        courses = [
            Course(
                id: UUID(),
                code: "CS 301",
                name: "Data Structures",
                location: "Science Hall 204",
                startTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!,
                endTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: today)!,
                instructor: "Dr. Chen"
            ),
            Course(
                id: UUID(),
                code: "ENG 102",
                name: "Technical Writing",
                location: "Liberal Arts 305",
                startTime: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: today)!,
                endTime: calendar.date(bySettingHour: 12, minute: 15, second: 0, of: today)!,
                instructor: "Prof. Adams"
            ),
            Course(
                id: UUID(),
                code: "MATH 220",
                name: "Linear Algebra",
                location: "Math Building 112",
                startTime: calendar.date(bySettingHour: 13, minute: 0, second: 0, of: today)!,
                endTime: calendar.date(bySettingHour: 14, minute: 15, second: 0, of: today)!,
                instructor: "Prof. Rivera"
            )
        ]
    }
}

@MainActor
final class DiningViewModel: ObservableObject {
    @Published var locations: [DiningLocation] = []

    init() {
        loadSampleData()
    }

    private func loadSampleData() {
        locations = [
            DiningLocation(
                id: UUID(),
                name: "Main Dining Hall",
                building: "Student Center",
                isOpen: true,
                hours: "7:00 AM – 9:00 PM",
                menuHighlights: ["Grill station", "Salad bar", "Daily soup"]
            ),
            DiningLocation(
                id: UUID(),
                name: "Campus Café",
                building: "Library Plaza",
                isOpen: true,
                hours: "8:00 AM – 6:00 PM",
                menuHighlights: ["Coffee", "Sandwiches", "Pastries"]
            ),
            DiningLocation(
                id: UUID(),
                name: "Late Night Bites",
                building: "Residence Quad",
                isOpen: false,
                hours: "9:00 PM – 1:00 AM",
                menuHighlights: ["Pizza", "Fries", "Smoothies"]
            )
        ]
    }
}

@MainActor
final class CampusMapViewModel: ObservableObject {
    @Published var buildings: [CampusBuilding] = []
    @Published var searchText: String = ""

    var filteredBuildings: [CampusBuilding] {
        guard !searchText.isEmpty else { return buildings }
        return buildings.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.abbreviation.localizedCaseInsensitiveContains(searchText)
        }
    }

    init() {
        loadSampleData()
    }

    private func loadSampleData() {
        buildings = [
            CampusBuilding(id: UUID(), name: "Science Hall", abbreviation: "SCI", category: .academic),
            CampusBuilding(id: UUID(), name: "Math Building", abbreviation: "MATH", category: .academic),
            CampusBuilding(id: UUID(), name: "Student Union", abbreviation: "SU", category: .recreation),
            CampusBuilding(id: UUID(), name: "Central Library", abbreviation: "LIB", category: .library),
            CampusBuilding(id: UUID(), name: "North Dining", abbreviation: "ND", category: .dining),
            CampusBuilding(id: UUID(), name: "West Residence Hall", abbreviation: "WRH", category: .housing)
        ]
    }
}

@MainActor
final class AssistantViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping = false
    @Published var statusMessage: String?

    init() {
        messages = [
            ChatMessage(
                id: UUID(),
                content: "Hi! I'm your Smart Campus Assistant. You can ask me about your schedule, assignments, exams, or where your next class is. You can also upload a photo of a syllabus or record a voice note!",
                isFromUser: false,
                timestamp: Date()
            )
        ]
    }

    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isTyping else { return }

        messages.append(
            ChatMessage(id: UUID(), content: trimmed, isFromUser: true, timestamp: Date())
        )
        inputText = ""
        statusMessage = nil

        isTyping = true
        let question = trimmed

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            let reply = self.generateReply(for: question)
            self.messages.append(
                ChatMessage(id: UUID(), content: reply, isFromUser: false, timestamp: Date())
            )
            self.isTyping = false
        }
    }

    func uploadImage() {
        statusMessage = "Image upload coming soon — paste syllabus text in chat for now."
    }

    func recordVoice() {
        statusMessage = "Voice notes coming soon — type your question below for now."
    }

    private func generateReply(for question: String) -> String {
        let lowercased = question.lowercased()

        if lowercased.contains("next class") || lowercased.contains("where is my class") {
            return "Your next class is BBT3105 Cost Accounting at 4:15 PM in STM-B F1-02. Would you like directions?"
        }
        if lowercased.contains("assignment") || lowercased.contains("due") {
            return "You have 3 assignments due this week: Cost Accounting Case Study (3 days), IT Project Sprint Report (5 days), and Database Normalization Quiz (7 days). Check Assignments for details."
        }
        if lowercased.contains("exam") || lowercased.contains("test") {
            return "Your upcoming exams: Business Process Management midterm next Tuesday, and Database Systems quiz on Friday. Want me to add reminders?"
        }
        if lowercased.contains("schedule") || lowercased.contains("timetable") {
            return "Today's classes: BBT2203 Database Systems at 10:30 AM (STM-B F1-05), BBT3105 Cost Accounting at 4:15 PM (STM-B F1-02), and BBT 2204 IT Project I at 7:15 PM (Online)."
        }
        if lowercased.contains("dining") || lowercased.contains("food") || lowercased.contains("eat") {
            return "Main Dining Hall is open until 9 PM. Campus Café in Library Plaza serves sandwiches and coffee until 6 PM."
        }
        if lowercased.contains("library") {
            return "Central Library is open until 11 PM on weekdays. Study rooms can be reserved from the library portal."
        }
        if lowercased.contains("hello") || lowercased.contains("hi") {
            return "Hello! I'm here to help with anything about campus — classes, assignments, exams, buildings, or dining. What would you like to know?"
        }

        return "I'm your campus AI assistant and I can help with schedules, assignments, exams, class locations, dining, and more. Try asking \"Where is my next class?\" or \"What assignments are due?\""
    }
}
