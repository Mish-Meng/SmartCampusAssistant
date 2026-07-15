import Foundation

@MainActor
final class JoinClassViewModel: ObservableObject {
    @Published var classes: [VirtualClass] = []
    @Published var errorMessage: String?

    init() {
        loadSampleData()
    }

    func joinClass(_ virtualClass: VirtualClass) -> URL? {
        guard let url = virtualClass.joinURL else {
            errorMessage = "No join link available for this class yet."
            return nil
        }
        errorMessage = nil
        return url
    }

    private func loadSampleData() {
        classes = [
            VirtualClass(
                id: UUID(),
                courseTitle: "BBT3102 Operating Systems (LECTURE SYSTEM)",
                platform: .teams,
                lecturer: "Janice Gichuhi",
                meetingID: "31181189962824",
                passcode: "CV2Gm7DQ",
                joinURL: URL(string: "https://teams.microsoft.com/l/meetup-join/19%3ameeting_31181189962824%40thread.v2/0?context=%7B%22Tid%22%3A%22campus%22%7D")
            ),
            VirtualClass(
                id: UUID(),
                courseTitle: "BBT3105 Cost Accounting for I",
                platform: .unknown,
                lecturer: "Robinson Kambi",
                meetingID: nil,
                passcode: nil,
                joinURL: nil
            ),
            VirtualClass(
                id: UUID(),
                courseTitle: "BBT 3111 Operating Systems (LECTURE SYSTEM)",
                platform: .zoom,
                lecturer: "Janice Gichuhi",
                meetingID: "311 811 189 962 824",
                passcode: "CV2gm7DQ",
                joinURL: URL(string: "https://zoom.us/j/311811189962824?pwd=CV2gm7DQ")
            ),
            VirtualClass(
                id: UUID(),
                courseTitle: "BBT 2204 IT Project I (Regular)",
                platform: .googleMeet,
                lecturer: "Dr. Chen",
                meetingID: nil,
                passcode: nil,
                joinURL: URL(string: "https://meet.google.com/abc-defg-hij")
            )
        ]
    }
}
