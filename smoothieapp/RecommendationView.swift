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
                Section (header: Text("Most Needed Nutrients")){
                    ForEach(userInfo.user_profile.needed_nutrients, id: \.self){ i in
                        NeededRow(nutrient: i)
                    }
                }

                Section (header: Text("Current Recommendations")){
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
