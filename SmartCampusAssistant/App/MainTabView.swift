import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }

            CampusMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            DiningView()
                .tabItem {
                    Label("Dining", systemImage: "fork.knife")
                }

            AssistantView()
                .tabItem {
                    Label("Assistant", systemImage: "bubble.left.and.bubble.right.fill")
                }
        }
        .tint(AppTheme.purple)
    }
}

#Preview {
    MainTabView()
}
