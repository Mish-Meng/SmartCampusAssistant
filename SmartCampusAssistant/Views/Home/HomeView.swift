import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    upcomingClassesSection
                    eventsSection
                }
                .padding()
            }
            .background(AppTheme.screenBackground)
            .navigationTitle("Campus")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out", role: .destructive) {
                        authViewModel.signOut()
                    }
                    .font(.subheadline)
                }
            }
            .refreshable {
                viewModel.refresh()
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.greeting)
                .font(.title2)
                .fontWeight(.semibold)

            Text("Here's what's happening on campus today.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var upcomingClassesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Up Next")
                .font(.headline)

            ForEach(viewModel.upcomingCourses) { course in
                CourseRowView(course: course)
            }
        }
    }

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Events")
                .font(.headline)

            ForEach(viewModel.featuredEvents) { event in
                EventRowView(event: event)
            }
        }
    }
}

struct CourseRowView: View {
    let course: Course

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(AppTheme.campusGreen)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(course.code)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(course.name)
                    .font(.headline)

                Label(course.location, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(course.timeRange)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.campusGreen)
            }

            Spacer()
        }
        .cardStyle()
    }
}

struct EventRowView: View {
    let event: CampusEvent

    private var formattedDate: String {
        event.date.formatted(date: .abbreviated, time: .shortened)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(event.category.rawValue.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.campusGreen)

            Text(event.title)
                .font(.headline)

            Label(event.location, systemImage: "location")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(formattedDate)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
