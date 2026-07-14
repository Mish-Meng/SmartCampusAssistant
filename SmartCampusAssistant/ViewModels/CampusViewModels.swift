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

    init() {
        messages = [
            ChatMessage(
                id: UUID(),
                content: "Hi! I'm your campus assistant. Ask me about classes, dining, events, or buildings.",
                isFromUser: false,
                timestamp: Date()
            )
        ]
    }

    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        messages.append(
            ChatMessage(id: UUID(), content: trimmed, isFromUser: true, timestamp: Date())
        )
        inputText = ""

        let reply = generateReply(for: trimmed)
        messages.append(
            ChatMessage(id: UUID(), content: reply, isFromUser: false, timestamp: Date())
        )
    }

    private func generateReply(for question: String) -> String {
        let lowercased = question.lowercased()

        if lowercased.contains("dining") || lowercased.contains("food") || lowercased.contains("eat") {
            return "Main Dining Hall is open until 9 PM. Campus Café in Library Plaza serves sandwiches and coffee until 6 PM."
        }
        if lowercased.contains("class") || lowercased.contains("schedule") {
            return "Your next class is CS 301 Data Structures in Science Hall 204. Check the Schedule tab for your full day."
        }
        if lowercased.contains("library") {
            return "Central Library (LIB) is open until 11 PM on weekdays. Study rooms can be reserved from the library website."
        }
        if lowercased.contains("event") {
            return "There's a Career Fair in the Student Union Ballroom in two days, and intramural soccer tomorrow at North Field."
        }

        return "I can help with schedules, dining hours, campus buildings, and events. Try asking something like \"What's open for dinner?\" or \"Where is my next class?\""
    }
}
