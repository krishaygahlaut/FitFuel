import Foundation
import SwiftUI

// MARK: - Meal Category Enum
enum MealCategory: String, Codable, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"

    var id: String { self.rawValue }

    var emoji: String {
        switch self {
        case .breakfast: return "🍳"
        case .lunch:     return "🥪"
        case .dinner:    return "🍝"
        case .snack:     return "🥨"
        }
    }

    var displayName: String {
        return "\(emoji) \(self.rawValue)"
    }
}

// MARK: - Meal Model
struct Meal: Identifiable, Codable {
    let id: UUID
    var title: String
    var calories: Int
    var date: Date
    var category: MealCategory
    var imageData: Data?

    init(title: String, calories: Int, category: MealCategory, image: UIImage? = nil, date: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.calories = calories
        self.category = category
        self.date = date
        self.imageData = image?.jpegData(compressionQuality: 0.8)
    }

    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}
