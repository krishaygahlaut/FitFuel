import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 10) {
                Text("FitFuel")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                Text("Project by Krishay Gahlaut")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
}
