import SwiftUI

struct MealHistoryView: View {
    @EnvironmentObject var viewModel: MealViewModel

    @State private var searchText = ""
    @State private var selectedCategory: MealCategory? = nil
    @State private var sortOption: SortOption = .newestFirst

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                // MARK: - Category Filter
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag(MealCategory?.none)
                    ForEach(MealCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(Optional(category))
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // MARK: - Sort Option
                Picker("Sort", selection: $sortOption) {
                    ForEach(SortOption.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)

                // MARK: - Result Count + Clear
                HStack {
                    Text("\(filteredAndSortedMeals.count) results")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .transition(.opacity)

                    Spacer()

                    if selectedCategory != nil || !searchText.isEmpty {
                        Button("Clear Filters") {
                            withAnimation {
                                selectedCategory = nil
                                searchText = ""
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 2)

                // MARK: - Meal List
                List {
                    ForEach(filteredAndSortedMeals) { meal in
                        HStack(alignment: .top, spacing: 12) {
                            if let uiImage = meal.image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 1)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .font(.title3)
                                            .foregroundColor(.gray)
                                    )
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text(meal.title)
                                    .font(.headline)

                                Text("\(meal.calories) kcal • \(meal.category.rawValue)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text(meal.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Meal History")
            .searchable(text: $searchText, prompt: "Search meals...")
        }
    }

    // MARK: - Logic
    var filteredMeals: [Meal] {
        viewModel.meals.filter { meal in
            (selectedCategory == nil || meal.category == selectedCategory) &&
            (searchText.isEmpty || meal.title.localizedCaseInsensitiveContains(searchText))
        }
    }

    var filteredAndSortedMeals: [Meal] {
        switch sortOption {
        case .newestFirst:
            return filteredMeals.sorted { $0.date > $1.date }
        case .oldestFirst:
            return filteredMeals.sorted { $0.date < $1.date }
        case .caloriesHighToLow:
            return filteredMeals.sorted { $0.calories > $1.calories }
        case .caloriesLowToHigh:
            return filteredMeals.sorted { $0.calories < $1.calories }
        }
    }

    private func delete(at offsets: IndexSet) {
        viewModel.meals.remove(atOffsets: offsets)
    }
}

// MARK: - Sort Options Enum
enum SortOption: String, CaseIterable {
    case newestFirst = "Newest First"
    case oldestFirst = "Oldest First"
    case caloriesHighToLow = "Calories ↓"
    case caloriesLowToHigh = "Calories ↑"
}
