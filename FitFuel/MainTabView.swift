import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: MealViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            MealHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
