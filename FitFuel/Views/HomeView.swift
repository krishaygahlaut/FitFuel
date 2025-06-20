import SwiftUI

struct HomeView: View {
    var body: some View {
        GradientBackgroundView{
            NavigationStack {
                ZStack {
                    LinearGradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        Image("logo") // Make sure you added a logo in assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .shadow(radius: 8)
                        
                        Text("Welcome to FitFuel")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .shadow(radius: 2)
                        
                        Text("Your personalized meal & calorie tracker")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        NavigationLink(destination: AddMealView()) {
                            Label("Log a Meal", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                                .shadow(radius: 4)
                        }
                        
                        NavigationLink(destination: MealHistoryView()) {
                            Label("View History", systemImage: "clock.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                                .shadow(radius: 4)
                        }
                        
                        NavigationLink(destination: AnalyticsView()) {
                            Label("Check Analytics", systemImage: "chart.bar.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                                .shadow(radius: 4)
                        }
                    }
                    .padding()
                }
                .navigationTitle("🏠 Home")
            }
        }
    }
}
