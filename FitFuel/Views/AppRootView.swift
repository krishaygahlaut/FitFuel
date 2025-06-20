import SwiftUI

struct AppRootView: View {
    @State private var showMain = false

    var body: some View {
        Group {
            if showMain {
                MainTabView()
                    .transition(.opacity)
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showMain = true
                            }
                        }
                    }
            }
        }
    }
}
