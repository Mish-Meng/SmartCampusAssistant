import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                SignInView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
