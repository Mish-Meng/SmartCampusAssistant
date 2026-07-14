import Foundation

struct Course: Identifiable, Hashable {
    let id: UUID
    let code: String
    let name: String
    let location: String
    let startTime: Date
    let endTime: Date
    let instructor: String

    var timeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: startTime)) – \(formatter.string(from: endTime))"
    }
}

struct CampusEvent: Identifiable, Hashable {
    let id: UUID
    let title: String
    let location: String
    let date: Date
    let category: EventCategory

    enum EventCategory: String, CaseIterable {
        case academic = "Academic"
        case social = "Social"
        case sports = "Sports"
        case club = "Club"
    }
}

struct DiningLocation: Identifiable, Hashable {
    let id: UUID
    let name: String
    let building: String
    let isOpen: Bool
    let hours: String
    let menuHighlights: [String]
}

struct CampusBuilding: Identifiable, Hashable {
    let id: UUID
    let name: String
    let abbreviation: String
    let category: BuildingCategory

    enum BuildingCategory: String, CaseIterable {
        case academic = "Academic"
        case dining = "Dining"
        case recreation = "Recreation"
        case housing = "Housing"
        case library = "Library"
    }
}

struct ChatMessage: Identifiable, Hashable {
    let id: UUID
    let content: String
    let isFromUser: Bool
    let timestamp: Date
}
