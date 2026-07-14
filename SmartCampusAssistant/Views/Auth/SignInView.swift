import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showSignUp = false

    var body: some View {
        ZStack {
            AuthBackground()

            ScrollView {
                VStack(spacing: 0) {
                    signInCard
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
                .environmentObject(authViewModel)
        }
    }

    private var signInCard: some View {
        VStack(spacing: 24) {
            headerSection
            formSection
            signInButton
            orDivider
            googleButton
            signUpPrompt
            termsText
        }
        .padding(28)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            AppLogoView(size: 64)

            Text("Smart Campus Assistant")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.2))

            Text("Welcome back! Sign in to your dashboard")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            AuthField(
                label: "Email Address",
                icon: "envelope",
                placeholder: "name@university.edu",
                text: $authViewModel.email,
                isSecure: false
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)

            AuthField(
                label: "Password",
                icon: "lock",
                placeholder: "••••••••",
                text: $authViewModel.password,
                isSecure: true
            )
            .textContentType(.password)

            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }

    private var signInButton: some View {
        Button {
            authViewModel.signIn()
        } label: {
            HStack(spacing: 8) {
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(AppTheme.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: AppTheme.purple.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .disabled(authViewModel.isLoading)
    }

    private var orDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)

            Text("OR CONTINUE WITH")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .tracking(0.5)

            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)
        }
    }

    private var googleButton: some View {
        Button {
            authViewModel.signInWithGoogle()
        } label: {
            HStack(spacing: 10) {
                GoogleLogoView()
                    .frame(width: 20, height: 20)
                Text("Google")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.25))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .disabled(authViewModel.isLoading)
    }

    private var signUpPrompt: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .foregroundStyle(.secondary)

            Button("Sign Up") {
                showSignUp = true
            }
            .fontWeight(.semibold)
            .foregroundStyle(Color(red: 0.2, green: 0.45, blue: 0.95))
        }
        .font(.subheadline)
    }

    private var termsText: some View {
        Text("By continuing, you agree to our terms and privacy policy.")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

// MARK: - Reusable auth components

struct AuthBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.97, green: 0.96, blue: 0.98),
                Color(red: 0.99, green: 0.94, blue: 0.97),
                Color(red: 0.96, green: 0.95, blue: 0.99)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct AppLogoView: View {
    let size: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.22)
            .fill(AppTheme.primaryGradient)
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: "square.grid.2x2.fill")
                    .font(.system(size: size * 0.38))
                    .foregroundStyle(.white)
            }
            .shadow(color: AppTheme.purple.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct AuthField: View {
    let label: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.2))

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)

                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
}

struct GoogleLogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.25)
                .stroke(Color(red: 0.26, green: 0.52, blue: 0.96), lineWidth: 3.5)
                .rotationEffect(.degrees(-45))

            Circle()
                .trim(from: 0.0, to: 0.25)
                .stroke(Color(red: 0.98, green: 0.74, blue: 0.02), lineWidth: 3.5)
                .rotationEffect(.degrees(45))

            Circle()
                .trim(from: 0.0, to: 0.25)
                .stroke(Color(red: 0.20, green: 0.66, blue: 0.33), lineWidth: 3.5)
                .rotationEffect(.degrees(135))

            Circle()
                .trim(from: 0.0, to: 0.25)
                .stroke(Color(red: 0.92, green: 0.26, blue: 0.21), lineWidth: 3.5)
                .rotationEffect(.degrees(225))

            Text("G")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color(red: 0.26, green: 0.52, blue: 0.96))
        }
    }
}

struct SignUpView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AuthBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        AppLogoView(size: 56)

                        Text("Create Account")
                            .font(.title2)
                            .fontWeight(.bold)

                        VStack(spacing: 16) {
                            AuthField(label: "Full Name", icon: "person", placeholder: "Your name", text: $name, isSecure: false)
                            AuthField(label: "Email Address", icon: "envelope", placeholder: "name@university.edu", text: $email, isSecure: false)
                            AuthField(label: "Password", icon: "lock", placeholder: "••••••••", text: $password, isSecure: true)
                        }

                        Button {
                            authViewModel.email = email
                            authViewModel.password = password
                            authViewModel.signIn()
                            dismiss()
                        } label: {
                            Text("Create Account")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .foregroundStyle(.white)
                                .background(AppTheme.primaryGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(28)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
                    .padding(24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel())
}
