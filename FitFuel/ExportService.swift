import Foundation
import UIKit
import SwiftUI
import PDFKit

struct ExportService {
    
    static func exportAsCSV(meals: [Meal]) -> URL? {
        let fileName = "MealHistory.csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        var csvText = "Title,Calories,Date\n"

        for meal in meals {
            let dateStr = ISO8601DateFormatter().string(from: meal.date)
            csvText += "\(meal.title),\(meal.calories),\(dateStr)\n"
        }

        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("❌ Failed to write CSV: \(error.localizedDescription)")
            return nil
        }
    }

    static func exportAsPDF(meals: [Meal]) -> URL? {
        let fileName = "MealHistory.pdf"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let pdfMetaData = [
            kCGPDFContextCreator: "FitFuel",
            kCGPDFContextAuthor: "FitFuel App"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        do {
            try renderer.writePDF(to: path) { context in
                context.beginPage()
                let title = "FitFuel Meal History"
                let titleFont = UIFont.boldSystemFont(ofSize: 24)
                title.draw(at: CGPoint(x: 72, y: 72), withAttributes: [.font: titleFont])

                var y = 120
                for meal in meals {
                    let dateStr = DateFormatter.localizedString(from: meal.date, dateStyle: .medium, timeStyle: .short)
                    let line = "\(meal.title) - \(meal.calories) kcal on \(dateStr)"
                    line.draw(at: CGPoint(x: 72, y: CGFloat(y)), withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
                    y += 24
                }
            }
            return path
        } catch {
            print("❌ Failed to create PDF: \(error.localizedDescription)")
            return nil
        }
    }
}
