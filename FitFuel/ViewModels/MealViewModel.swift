import Foundation
import SwiftUI

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = [] {
        didSet {
            saveMeals()
        }
    }

    init() {
        loadMeals()
    }

    func addMeal(title: String, calories: Int, category: MealCategory, image: UIImage? = nil, date: Date = Date()) {
        let newMeal = Meal(title: title, calories: calories, category: category, image: image, date: date)
        meals.append(newMeal)
    }

    func clearMeals() {
        meals.removeAll()
    }

    func totalCalories(for date: Date) -> Int {
        meals
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .reduce(0) { $0 + $1.calories }
    }

    // MARK: - Persistence

    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: "meals")
        }
    }

    private func loadMeals() {
        if let savedData = UserDefaults.standard.data(forKey: "meals"),
           let decoded = try? JSONDecoder().decode([Meal].self, from: savedData) {
            meals = decoded
        }
    }
}
