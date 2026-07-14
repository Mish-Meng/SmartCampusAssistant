import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.courses) { course in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(course.code)
                            .font(.headline)
                        Spacer()
                        Text(course.timeRange)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.campusGreen)
                    }

                    Text(course.name)
                        .font(.subheadline)

                    Label(course.location, systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(course.instructor)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Schedule")
        }
    }
}

#Preview {
    ScheduleView()
}
