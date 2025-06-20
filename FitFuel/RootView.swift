import SwiftUI

struct RootView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        SplashView()
    }
}
