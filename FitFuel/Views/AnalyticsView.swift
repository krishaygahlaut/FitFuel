import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var viewModel: MealViewModel
    @State private var selectedRange: TimeRange = .week
    
    var body: some View {
        GradientBackgroundView{
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        Picker("Time Range", selection: $selectedRange) {
                            ForEach(TimeRange.allCases, id: \.self) { range in
                                Text(range.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        GroupBox(label: Text("Calories by Day")) {
                            Chart {
                                ForEach(dailySummary) { day in
                                    BarMark(
                                        x: .value("Date", day.date, unit: .day),
                                        y: .value("Total", day.total)
                                    )
                                }
                            }
                            .frame(height: 250)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Analytics")
            }
        }
        
        var filteredMeals: [Meal] {
            let now = Date()
            switch selectedRange {
            case .week:
                let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
                return viewModel.meals.filter { $0.date >= weekAgo }
            case .month:
                let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!
                return viewModel.meals.filter { $0.date >= monthAgo }
            }
        }
        
        var dailySummary: [DateTotal] {
            let grouped = Dictionary(grouping: filteredMeals) {
                Calendar.current.startOfDay(for: $0.date)
            }
            return grouped.map {
                DateTotal(date: $0.key, total: $0.value.reduce(0) { $0 + $1.calories })
            }.sorted { $0.date < $1.date }
        }
    }
    
    struct DateTotal: Identifiable {
        let id = UUID()
        let date: Date
        let total: Int
    }
    
    enum TimeRange: String, CaseIterable {
        case week, month
    }
}
