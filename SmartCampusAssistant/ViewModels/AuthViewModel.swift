import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    var displayName: String {
        if email.isEmpty { return "Michelle Jelimo" }
        let localPart = email.split(separator: "@").first.map(String.init) ?? email
        return localPart
            .replacingOccurrences(of: ".", with: " ")
            .split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }

    var displayEmail: String {
        email.isEmpty ? "michellejelimo32@gmail.com" : email
    }

    func signIn() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        guard trimmedEmail.contains("@"), trimmedEmail.contains(".") else {
            errorMessage = "Please enter a valid university email."
            return
        }

        isLoading = true
        errorMessage = nil

        // Placeholder until a real auth backend is connected.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.isLoading = false
            self?.isAuthenticated = true
        }
    }

    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.isLoading = false
            self?.isAuthenticated = true
        }
    }

    func signOut() {
        isAuthenticated = false
        email = ""
        password = ""
        errorMessage = nil
    }
}
