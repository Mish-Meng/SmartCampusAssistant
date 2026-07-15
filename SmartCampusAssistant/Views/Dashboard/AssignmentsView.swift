import SwiftUI

struct AssignmentsView: View {
    @StateObject private var viewModel = AssignmentsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isGoogleClassroomConnected {
                assignmentsSearchBar
            }

            ScrollView {
                classroomAssignmentsCard
                    .padding(16)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    private var assignmentsSearchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search assignments...", text: $viewModel.searchText)
                .font(.subheadline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.top, 10)
    }

    private var classroomAssignmentsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            cardHeader

            Divider()
                .padding(.horizontal, 16)

            if viewModel.isSyncing {
                syncingState
            } else if viewModel.isEmpty {
                emptyState
            } else {
                assignmentsList
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(16)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
    }

    private var cardHeader: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "book.closed.fill")
                .font(.title3)
                .foregroundStyle(.green)
                .frame(width: 44, height: 44)
                .background(Color.green.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text("Classroom Assignments")
                    .font(.headline)
                    .fontWeight(.bold)

                Text("All synced assignments from Google Classroom")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let synced = viewModel.lastSyncedAt {
                    Text("Last synced \(synced.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2)
                        .foregroundStyle(.green)
                }
            }

            Spacer()

            Button {
                viewModel.syncNew()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                    Text("Sync New")
                }
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .foregroundStyle(.primary)
            .disabled(viewModel.isSyncing)
        }
        .padding(16)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 48))
                .foregroundStyle(Color(.systemGray3))

            Text("No Assignments Yet")
                .font(.headline)
                .fontWeight(.semibold)

            Text("Sync your Google Classroom to see your assignments here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button {
                viewModel.syncWithGoogleClassroom()
            } label: {
                Text("Sync Now")
                    .fontWeight(.semibold)
                    .frame(maxWidth: 200)
                    .padding(.vertical, 12)
                    .foregroundStyle(.white)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(viewModel.isSyncing)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private var syncingState: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Syncing with Google Classroom...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }

    private var assignmentsList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.filteredAssignments) { assignment in
                AssignmentRowView(assignment: assignment)

                if assignment.id != viewModel.filteredAssignments.last?.id {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct AssignmentRowView: View {
    let assignment: ClassroomAssignment

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(assignment.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(assignment.courseName)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Label(assignment.dueDateText, systemImage: "calendar")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    if let points = assignment.maxPoints {
                        Text("\(points) pts")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            Text(assignment.status.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.15))
                .foregroundStyle(statusColor)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var statusColor: Color {
        switch assignment.status {
        case .assigned: return .blue
        case .turnedIn: return .green
        case .missing: return .red
        case .graded: return AppTheme.purple
        }
    }
}

#Preview {
    AssignmentsView()
}
