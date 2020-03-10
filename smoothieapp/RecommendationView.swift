//
//  RecommendationView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI
import FirebaseDatabase


struct RecommendationView: View {
    @EnvironmentObject var userInfo : userSettings
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var now = Date()
    var body: some View {
        VStack(){
            Spacer()
            .frame(height: 20.0)
            Text("Here are your current recommendations for...")
                .font(.callout)
                .fontWeight(.thin)
                
            Text("\(now, formatter: self.dateFormatter)")
                .font(.headline)
                .fontWeight(.semibold)
            
            List {
                Section (header: Text("Most Needed Nutrients: Top 3")){
                    ForEach(userInfo.user_profile.needed_nutrients, id: \.self){ i in
                        NeededRow(nutrient: i)
                    }
                }

                Section (header: Text("Current Recommendations: Top 3")){
                    ForEach(userInfo.user_profile.ranked_recipes){ i in
                        NavigationLink(destination: RecipeView(recipe: i)) {
                            RecipeRow(recipe: i)
                        }
                    }
                }
            }
            .navigationBarTitle("Notifications")
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView().environmentObject(userSettings())
    }
}

struct NeededRow: View {
    var nutrient: String
    var body: some View {
        Text(nutrient)
    }
}

func grab_recommendations(userInfo: userSettings){
    var data = [Recipe]()
    userInfo.user_profile.ranked_recipes.removeAll()
    userInfo.user_profile.needed_nutrients.removeAll()
    
    let ref = Database.database().reference(withPath: "recipes")
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
        for child in snapshot.children.allObjects as! [DataSnapshot] {
            let value = child.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let url = value?["url"] as? String ?? ""
            let image = value?["image"] as? String ?? ""
            let calcium = value?["calcium"] as? CGFloat ?? 0.0
            let fiber = value?["fiber"] as? CGFloat ?? 0.0
            let iron = value?["iron"] as? CGFloat ?? 0.0
            let magnesium = value?["magnesium"] as? CGFloat ?? 0.0
            let potassium = value?["potassium"] as? CGFloat ?? 0.0
            let protein = value?["protein"] as? CGFloat ?? 0.0
            let vitaminA = value?["vitamin-A"] as? CGFloat ?? 0.0
            let vitaminB12 = value?["vitamin-B12"] as? CGFloat ?? 0.0
            let vitaminC = value?["vitamin-C"] as? CGFloat ?? 0.0
            let vitaminD = value?["vitamin-D"] as? CGFloat ?? 0.0
            let vitaminE = value?["vitamin-E"] as? CGFloat ?? 0.0
            let vitaminK = value?["vitamin-K"] as? CGFloat ?? 0.0
            let zinc = value?["zinc"] as? CGFloat ?? 0.0
            let healthLabels = value?["health-labels"] as? [String] ?? [""]
            let ingredientLines = value?["ingredient-lines"] as? [String] ?? [""]
            let dict = value as! Dictionary<String, Any>
            // create new recipe object
            let info = Recipe(id: name, name: name, url: url, image: image, calcium: calcium, fiber: fiber, iron: iron, magnesium: magnesium, potassium: potassium, protein: protein, vitaminA: vitaminA, vitaminB12: vitaminB12, vitaminC: vitaminC, vitaminD: vitaminD, vitaminE: vitaminE, vitaminK: vitaminK, zinc: zinc,  healthLabels: healthLabels, ingredientLines: ingredientLines, dict: dict)
                    
            // FILTER BY HEALTH LABELS
            if check_label(userInfo: userInfo, healthLabels: healthLabels) == true {
                data.append(info)
            }
        }
        
        // START RANKING ALL THE RECIPES
        let nutrients_dict = nutrient_rank(userInfo: userInfo)
        var ranked_dict = [String : CGFloat]()
        var iter = 0
        for (nutrient, percent) in (nutrients_dict.sorted { $0.1 < $1.1 }) {
            userInfo.user_profile.needed_nutrients.append(nutrient)
            ranked_dict[nutrient] = percent
            iter += 1
            if iter == 3 { break }
        }
        // rank recipes based on top 3 nutrients
        rank_recipes(userInfo: userInfo, recipes: data, dict: ranked_dict)
    })
}

func check_label(userInfo: userSettings, healthLabels: [String]) -> Bool {
    for option in userInfo.user_profile.health_options {
        // if toggled, check if it is healthLabels
        if option.toggle == true {
            // if it does not contain it, return false
            if !healthLabels.contains(option.name){
                return false
            }
        }
    }
    return true
}

func nutrient_rank(userInfo: userSettings) -> [String : CGFloat] {
    var dict = [String : CGFloat]()
    let calcium = (userInfo.total_values.calcium / userInfo.max_values.calcium)
    let fiber = (userInfo.total_values.fiber / userInfo.max_values.fiber)
    let iron = (userInfo.total_values.iron / userInfo.max_values.iron)
    let magnesium = (userInfo.total_values.magnesium / userInfo.max_values.magnesium)
    let potassium = (userInfo.total_values.potassium / userInfo.max_values.potassium)
    let protein = (userInfo.total_values.protein / userInfo.max_values.protein)
    let vitaminA = (userInfo.total_values.vitaminA / userInfo.max_values.vitaminA)
    let vitaminB12 = (userInfo.total_values.vitaminB12 / userInfo.max_values.vitaminB12)
    let vitaminC = (userInfo.total_values.vitaminC / userInfo.max_values.vitaminC)
    let vitaminD = (userInfo.total_values.vitaminD / userInfo.max_values.vitaminD)
    let vitaminE = (userInfo.total_values.vitaminE / userInfo.max_values.vitaminE)
    let vitaminK = (userInfo.total_values.vitaminK / userInfo.max_values.vitaminK)
    let zinc = (userInfo.total_values.zinc / userInfo.max_values.zinc)
    
    dict["Calcium"] = calcium
    dict["Fiber"] = fiber
    dict["Iron"] = iron
    dict["Magnesium"] = magnesium
    dict["Potassium"] = potassium
    dict["Protein"] = protein
    dict["VitaminA"] = vitaminA
    dict["VitaminB12"] = vitaminB12
    dict["VitaminC"] = vitaminC
    dict["VitaminD"] = vitaminD
    dict["VitaminE"] = vitaminE
    dict["VitaminK"] = vitaminK
    dict["Zinc"] = zinc
    
    return dict
}


func rank_recipes(userInfo: userSettings, recipes: [Recipe], dict: [String:CGFloat]){
    var recipe_scores = [CGFloat : Int]()
    for (index, recipe) in recipes.enumerated() {
        // compute a score for the recipe based on top 3
        var score = CGFloat(0.0)
        for (nutrient, percent) in dict.sorted(by: <) {
            // grab nutrient data and compare it to max value
            score += percent_increase(userInfo: userInfo, nutrient: nutrient, recipe: recipe)
        }
        recipe_scores[score] = index
    }

    // sort dict by keys and grab top 3 values
    var i = 0
    for (score, index) in recipe_scores.sorted(by: >){
        userInfo.user_profile.ranked_recipes.append(recipes[index])
        i += 1
        if i == 3 { break }
    }
}

func percent_increase(userInfo: userSettings, nutrient: String, recipe: Recipe) -> CGFloat {
    if nutrient == "Calcium" {
        return (recipe.calcium / userInfo.max_values.calcium)
    }
    if nutrient == "Fiber" {
        return (recipe.fiber / userInfo.max_values.fiber)
    }
    if nutrient == "Iron" {
        return (recipe.iron / userInfo.max_values.iron)
    }
    if nutrient == "Magnesium" {
        return (recipe.magnesium / userInfo.max_values.magnesium)
    }
    if nutrient == "Potassium" {
        return (recipe.potassium / userInfo.max_values.potassium)
    }
    if nutrient == "Protein" {
        return (recipe.protein / userInfo.max_values.protein)
    }
    if nutrient == "VitaminA" {
        return (recipe.vitaminA / userInfo.max_values.vitaminA)
    }
    if nutrient == "VitaminB12" {
        return (recipe.vitaminB12 / userInfo.max_values.vitaminB12)
    }
    if nutrient == "VitaminC" {
           return (recipe.vitaminC / userInfo.max_values.vitaminC)
    }
    if nutrient == "VitaminD" {
           return (recipe.vitaminD / userInfo.max_values.vitaminD)
    }
    if nutrient == "VitaminE" {
           return (recipe.vitaminE / userInfo.max_values.vitaminE)
    }
    if nutrient == "VitaminK" {
           return (recipe.vitaminK / userInfo.max_values.vitaminK)
    }
    if nutrient == "Zinc" {
           return (recipe.zinc / userInfo.max_values.zinc)
    }
    return 0
}
