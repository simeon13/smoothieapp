//
//  FoodView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct FoodView: View {
    @ObservedObject var data = observer()
    
    var body: some View {
        NavigationView {
            List {
                // Recipes
                Section(header: Text("Recipes")) {
                    ForEach(data.recipe_data){i in
                        NavigationLink(destination: RecipeView(recipe: i)) {
                            RecipeRow(recipe: i)
                        }
                    }
                }
                
                // Foods
                Section(header: Text("Vegetables")) {
                    ForEach(data.vegetable_data){i in
                        NavigationLink(destination: FoodItemView(foodItem: i)) {
                            FoodItemRow(foodItem: i)
                        }
                    }
                }
                
                Section(header: Text("Dairy")) {
                    ForEach(data.dairy_data){i in
                        NavigationLink(destination: FoodItemView(foodItem: i)) {
                            FoodItemRow(foodItem: i)
                        }
                    }
                }
                
                Section(header: Text("Fish")) {
                    ForEach(data.fish_data){i in
                        NavigationLink(destination: FoodItemView(foodItem: i)) {
                            FoodItemRow(foodItem: i)
                        }
                    }
                }
                
                Section(header: Text("Fruits")) {
                    ForEach(data.fruit_data){i in
                        NavigationLink(destination: FoodItemView(foodItem: i)) {
                            FoodItemRow(foodItem: i)
                        }
                    }
                }
                
                Section(header: Text("Grains")) {
                    ForEach(data.grain_data){i in
                        NavigationLink(destination: FoodItemView(foodItem: i)) {
                            FoodItemRow(foodItem: i)
                        }
                    }
                }
                
                Section(header: Text("Poultry")) {
                    ForEach(data.poultry_data){i in
                        NavigationLink(destination: FoodItemView(foodItem: i)) {
                            FoodItemRow(foodItem: i)
                        }
                    }
                }
            }
            .navigationBarTitle("Items")
            .listStyle(GroupedListStyle())
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}

class observer : ObservableObject {
    @Published var recipe_data = [Recipe]()
    @Published var vegetable_data = [FoodItem]()
    @Published var dairy_data = [FoodItem]()
    @Published var fish_data = [FoodItem]()
    @Published var fruit_data = [FoodItem]()
    @Published var grain_data = [FoodItem]()
    @Published var poultry_data = [FoodItem]()
    
    
    init(){
        // RECIPES
        let ref = Database.database().reference(withPath: "recipes")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let url = value?["url"] as? String ?? ""
                let image = value?["image"] as? String ?? ""
                let calcium = value?["calcium"] as? String ?? ""
                let fiber = value?["fiber"] as? String ?? ""
                let iron = value?["iron"] as? String ?? ""
                let magnesium = value?["magnesium"] as? String ?? ""
                let potassium = value?["potassium"] as? String ?? ""
                let protein = value?["protein"] as? String ?? ""
                let vitaminA = value?["vitaminA"] as? String ?? ""
                let vitaminB12 = value?["vitaminB12"] as? String ?? ""
                let vitaminC = value?["vitaminC"] as? String ?? ""
                let vitaminD = value?["vitaminD"] as? String ?? ""
                let vitaminE = value?["vitaminE"] as? String ?? ""
                let vitaminK = value?["vitaminK"] as? String ?? ""
                let zinc = value?["zinc"] as? String ?? ""
                // create new recipe object
                let info = Recipe(id: name, name: name, url: url, image: image, calcium: calcium, fiber: fiber, iron: iron, magnesium: magnesium, potassium: potassium, protein: protein, vitaminA: vitaminA, vitaminB12: vitaminB12, vitaminC: vitaminC, vitaminD: vitaminD, vitaminE: vitaminE, vitaminK: vitaminK, zinc: zinc)
                self.recipe_data.append(info)
            }
        })
        
        // FOODS
        let food_list = ["Vegetables", "dairy", "fish", "fruit", "grains", "poultry"]
        for entry in food_list {
            let food_ref = Database.database().reference(withPath: entry)
            food_ref.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let value = child.value as? NSDictionary
                    let name = child.key.capitalized
                    let calcium = value?["calcium"] as? String ?? ""
                    let fiber = value?["fiber"] as? String ?? ""
                    let iron = value?["iron"] as? String ?? ""
                    let magnesium = value?["magnesium"] as? String ?? ""
                    let potassium = value?["potassium"] as? String ?? ""
                    let protein = value?["protein"] as? String ?? ""
                    let vitaminA = value?["vitaminA"] as? String ?? ""
                    let vitaminB12 = value?["vitaminB12"] as? String ?? ""
                    let vitaminC = value?["vitaminC"] as? String ?? ""
                    let vitaminD = value?["vitaminD"] as? String ?? ""
                    let vitaminE = value?["vitaminE"] as? String ?? ""
                    let vitaminK = value?["vitaminK"] as? String ?? ""
                    let zinc = value?["zinc"] as? String ?? ""
                    // create new foodItem object
                    let food_item = FoodItem(id: name, name: name, calcium: calcium, fiber: fiber, iron: iron, magnesium: magnesium, potassium: potassium, protein: protein, vitaminA: vitaminA, vitaminB12: vitaminB12, vitaminC: vitaminC, vitaminD: vitaminD, vitaminE: vitaminE, vitaminK: vitaminK, zinc: zinc)
                    if (entry == "Vegetables"){
                        self.vegetable_data.append(food_item)
                    }
                    if (entry == "dairy"){
                        self.dairy_data.append(food_item)
                    }
                    if (entry == "fish"){
                        self.fish_data.append(food_item)
                    }
                    if (entry == "fruit"){
                        self.fruit_data.append(food_item)
                    }
                    if (entry == "grains"){
                        self.grain_data.append(food_item)
                    }
                    if (entry == "poultry"){
                        self.poultry_data.append(food_item)
                    }
                }
            })
        }
        
    }
}

struct RecipeView: View {
    var recipe: Recipe
    var body: some View {
        Text("Recipe Working")
    }
}

struct RecipeRow: View {
    var recipe: Recipe
    var body: some View {
        Text(recipe.name)
    }
}

struct Recipe : Identifiable {
    var id : String
    var name : String
    var url : String
    var image : String
    var calcium : String
    var fiber : String
    var iron : String
    var magnesium : String
    var potassium : String
    var protein : String
    var vitaminA : String
    var vitaminB12 : String
    var vitaminC : String
    var vitaminD : String
    var vitaminE : String
    var vitaminK : String
    var zinc : String
}

struct FoodItemView: View {
    var foodItem : FoodItem
    var body: some View {
        Text("Food Item Working")
    }
}

struct FoodItemRow: View {
    var foodItem : FoodItem
    var body: some View {
        Text(foodItem.name)
    }
}

struct FoodItem : Identifiable {
    var id : String
    var name : String
    var calcium : String
    var fiber : String
    var iron : String
    var magnesium : String
    var potassium : String
    var protein : String
    var vitaminA : String
    var vitaminB12 : String
    var vitaminC : String
    var vitaminD : String
    var vitaminE : String
    var vitaminK : String
    var zinc : String
}
