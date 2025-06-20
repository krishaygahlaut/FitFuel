import SwiftUI
import UserNotifications

@main
struct FitFuelApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var mealViewModel = MealViewModel()

    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(mealViewModel)
                .preferredColorScheme(isDarkMode ? .dark : .light) // ✅ Apply here ONLY
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print(granted ? "✅ Notification permission granted." : "❌ Notification permission denied.")
        }
    }
}
