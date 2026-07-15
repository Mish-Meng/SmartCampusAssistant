import Foundation

enum MeetingPlatform: String, CaseIterable {
    case teams = "Teams"
    case zoom = "Zoom"
    case googleMeet = "Google Meet"
    case webex = "Webex"
    case unknown = "Online"

    var icon: String {
        switch self {
        case .teams: return "video.fill"
        case .zoom: return "video.fill"
        case .googleMeet: return "video.fill"
        case .webex: return "video.fill"
        case .unknown: return "video.slash"
        }
    }

    var badgeColor: String {
        switch self {
        case .teams: return "purple"
        case .zoom: return "blue"
        case .googleMeet: return "green"
        case .webex: return "orange"
        case .unknown: return "gray"
        }
    }
}

struct VirtualClass: Identifiable, Hashable {
    let id: UUID
    let courseTitle: String
    let platform: MeetingPlatform
    let lecturer: String
    let meetingID: String?
    let passcode: String?
    let joinURL: URL?

    var hasJoinLink: Bool {
        joinURL != nil
    }

    var joinDetailsSummary: String {
        if hasJoinLink { return "Ready to join" }
        if meetingID != nil || passcode != nil { return "Details available below" }
        return "No join details assigned"
    }
}
