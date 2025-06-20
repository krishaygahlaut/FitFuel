import SwiftUI
import PhotosUI

struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MealViewModel

    @State private var title = ""
    @State private var calories = ""
    @State private var selectedCategory: MealCategory = .breakfast
    @State private var selectedImage: UIImage?
    @State private var date = Date()
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("🍽 Meal Title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    TextField("🔥 Calories (e.g., 450)", text: $calories)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(MealCategory.allCases) { category in
                            Text("\(category.emoji) \(category.rawValue.capitalized)")
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)

                    DatePicker("🗓 Date", selection: $date, displayedComponents: .date)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }

                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label("Select Meal Photo", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button("🧠 Estimate Calories with AI (Mock)") {
                        self.calories = String(Int.random(in: 100...700))
                    }
                    .buttonStyle(.borderedProminent)

                    Button("💾 Save Meal") {
                        if let kcal = Int(calories) {
                            viewModel.addMeal(
                                title: title,
                                calories: kcal,
                                category: selectedCategory,
                                image: selectedImage,
                                date: date
                            )
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || calories.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Add Meal")
        }
        .onChange(of: photoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.selectedImage = uiImage
                }
            }
        }
    }
}
