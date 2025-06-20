import SwiftUI

struct SplashView: View {
    @EnvironmentObject var viewModel: MealViewModel
    @State private var isActive = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.9), .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("AppIcon") // Ensure this matches your Asset Catalog name
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 10)

                Text("FitFuel")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Text("Project by Krishay Gahlaut")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .opacity(isActive ? 0 : 1)
            .animation(.easeInOut(duration: 1.0), value: isActive)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            MainTabView()
                .environmentObject(viewModel)
        }
    }
}
