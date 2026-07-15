import SwiftUI

struct TaskBreakdownView: View {
    @StateObject private var viewModel = TaskBreakdownViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                inputSourceCard
                howItWorksCard
                calendarSyncCard

                if let message = viewModel.statusMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(AppTheme.purple)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(AppTheme.magenta)
                Text("AI Task Breakdown")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Text("Upload your timetable, syllabus, or record a voice note to automatically generate your standup tasks.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var inputSourceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Input Source")
                    .font(.headline)
                Text("Provide text, image, or audio")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ZStack(alignment: .topLeading) {
                if viewModel.inputText.isEmpty {
                    Text("Paste text here or use the tools below...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }

                TextEditor(text: $viewModel.inputText)
                    .font(.subheadline)
                    .frame(minHeight: 120)
                    .scrollContentBackground(.hidden)
                    .padding(4)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 1, dash: [6]))
            )

            HStack(spacing: 12) {
                InputToolButton(
                    title: "Upload Timetable",
                    icon: "photo.on.rectangle",
                    action: viewModel.uploadTimetable
                )

                InputToolButton(
                    title: "Record Voice Note",
                    icon: "mic.fill",
                    action: viewModel.recordVoiceNote
                )
            }

            Button {
                viewModel.generateTasks()
            } label: {
                HStack(spacing: 8) {
                    if viewModel.isGenerating {
                        ProgressView()
                            .tint(AppTheme.purple)
                    } else {
                        Image(systemName: "sparkles")
                    }
                    Text(viewModel.isGenerating ? "Generating..." : "Generate Standup Tasks")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(AppTheme.purple)
                .background(AppTheme.purple.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.purple.opacity(0.3), lineWidth: 1)
                )
            }
            .disabled(viewModel.isGenerating)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
    }

    private var howItWorksCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How it works")
                .font(.headline)
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 14) {
                HowItWorksStep(
                    number: 1,
                    text: "Upload a photo of your **Timetable** or **Syllabus**."
                )
                HowItWorksStep(
                    number: 2,
                    text: "Record a **Voice Note** describing your tasks for the day."
                )
                HowItWorksStep(
                    number: 3,
                    text: "Gemini extracts **Dates**, **Locations**, and **Types** automatically."
                )
                HowItWorksStep(
                    number: 4,
                    text: "Tasks with dates are automatically linked to your **Calendar**."
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.infoGradient)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var calendarSyncCard: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "calendar")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text("Calendar Sync")
                    .font(.headline)

                Text("Any task generated with a detectable date or time will be automatically placed on your calendar. Try uploading a timetable with specific room numbers and times for the best results!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.dashboardCardBorder, lineWidth: 1)
        )
    }
}

struct InputToolButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct HowItWorksStep: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(Color.white.opacity(0.25))
                .clipShape(Circle())

            Text(.init(text))
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.95))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    TaskBreakdownView()
}
