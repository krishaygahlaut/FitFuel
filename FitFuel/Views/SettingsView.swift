import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("reminderTime") private var reminderTime: Double = 8.0
    @State private var showNotificationAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("🌓 Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Enable Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .onChange(of: isDarkMode) { newValue in
                        print("🌙 Dark Mode is now: \(newValue ? "Enabled" : "Disabled")")
                        // This triggers color scheme change via @AppStorage in FitFuelApp.swift
                    }
                }
                Section(header: Text("⏰ Meal Reminder")) {
                    HStack {
                        Label("Reminder Time", systemImage: "clock")
                        Spacer()
                        Stepper("\(Int(reminderTime)) AM", value: $reminderTime, in: 5...11)
                    }

                    Button("Set Daily Reminder") {
                        scheduleReminder()
                        showNotificationAlert = true
                    }
                }

                Section(header: Text("🔗 Links")) {
                    Link("GitHub Project", destination: URL(string: "https://github.com/krishaygahlaut/FitFuel")!)
                    Link("Contact Developer", destination: URL(string: "mailto:krishaygahlut@icloud.com")!)
                }

                Section(footer: Text("FitFuel v1.0\n© 2025 Krishay Gahlaut")) {
                    EmptyView()
                }
            }
            .navigationTitle("Settings")
            .alert("Reminder Set!", isPresented: $showNotificationAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }

    // MARK: - Local Notification Setup
    private func scheduleReminder() {
        let content = UNMutableNotificationContent()
        content.title = "🍱 Time to log your meal!"
        content.body = "Stay on track by logging your breakfast now."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = Int(reminderTime)
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyMealReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification error: \(error.localizedDescription)")
            } else {
                print("✅ Reminder scheduled at \(Int(reminderTime)):00 AM")
            }
        }
    }
}
