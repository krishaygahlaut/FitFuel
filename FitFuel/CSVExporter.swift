import Foundation

struct CSVExporter {
    static func export(meals: [Meal]) -> URL? {
        let fileName = "FitFuel_Meals.csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        var csvText = "Title,Calories,Category,Date\n"

        for meal in meals {
            let title = meal.title.replacingOccurrences(of: ",", with: " ")
            let calories = "\(meal.calories)"
            let category = meal.category.rawValue
            let date = DateFormatter.localizedString(from: meal.date, dateStyle: .short, timeStyle: .short)
            let line = "\(title),\(calories),\(category),\(date)\n"
            csvText += line
        }

        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("❌ Failed to write CSV: \(error)")
            return nil
        }
    }
}
