import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)

            Text("Welcome to FitFuel")
                .font(.largeTitle)
                .bold()

            Text("Track your meals, calories, and stay fit with ease.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Get Started") {
                hasSeenOnboarding = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
