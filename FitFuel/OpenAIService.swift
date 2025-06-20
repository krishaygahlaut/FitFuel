import Foundation

class OpenAIService {
    static let shared = OpenAIService()

    func estimateCalories(from text: String, completion: @escaping (String) -> Void) {
        // ✅ MOCK LOGIC – Offline Simulation
        let mockCalorieMap: [String: Int] = [
            "egg": 78,
            "boiled egg": 78,
            "banana": 105,
            "rice": 200,
            "chicken": 250,
            "milk": 150,
            "toast": 120,
            "peanut butter": 180
        ]

        var total = 0
        let lowercasedText = text.lowercased()

        for (item, kcal) in mockCalorieMap {
            if lowercasedText.contains(item) {
                total += kcal
            }
        }

        // Default if no match
        if total == 0 {
            total = Int.random(in: 200...600)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            completion("\(total)") // No "kcal" to stay consistent
        }
    }
}
