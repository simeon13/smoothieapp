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
    @ObservedObject var recipes = observer()
    
    var body: some View {
        NavigationView {
            List {
                // Recipes
                Section(header: Text("Recipes")) {
                    ForEach(recipes.data){i in
                        NavigationLink(destination: RecipeView(recipe: i)) {
                            RecipeRow(recipe: i)
                        }
                    }
                }
                
                // Foods
            }
            .navigationBarTitle("Food")
            .listStyle(GroupedListStyle())
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}

struct RecipeView: View {
    var recipe: Recipe
    var body: some View {
        Text("Working")
    }
}

struct RecipeRow: View {
    var recipe: Recipe
    var body: some View {
        Text(recipe.name)
    }
}

class observer : ObservableObject {
    @Published var data = [Recipe]()
    
    init(){
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
                self.data.append(info)
            }
        })
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
