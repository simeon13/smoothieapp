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
    @ObservedObject var recipes = recipes_observer()

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
                Section (header: Text("Current Recommendations")){
                    ForEach(recipes.ranked){i in
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

class recipes_observer : ObservableObject {
    @Published var data = [Recipe]()
    @Published var ranked = [Recipe]()

    init(){
        // RECIPES
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
                let vitaminA = value?["vitaminA"] as? CGFloat ?? 0.0
                let vitaminB12 = value?["vitaminB12"] as? CGFloat ?? 0.0
                let vitaminC = value?["vitaminC"] as? CGFloat ?? 0.0
                let vitaminD = value?["vitaminD"] as? CGFloat ?? 0.0
                let vitaminE = value?["vitaminE"] as? CGFloat ?? 0.0
                let vitaminK = value?["vitaminK"] as? CGFloat ?? 0.0
                let zinc = value?["zinc"] as? CGFloat ?? 0.0
                // create new recipe object
                let healthLabels = value?["health-labels"] as? [String] ?? [""]
                let ingredientLines = value?["ingredient-lines"] as? [String] ?? [""]
                 // create new recipe object
                let info = Recipe(id: name, name: name, url: url, image: image, calcium: calcium, fiber: fiber, iron: iron, magnesium: magnesium, potassium: potassium, protein: protein, vitaminA: vitaminA, vitaminB12: vitaminB12, vitaminC: vitaminC, vitaminD: vitaminD, vitaminE: vitaminE, vitaminK: vitaminK, zinc: zinc,  healthLabels: healthLabels, ingredientLines : ingredientLines)
                var insert = true
                
                // loop through and filter the health options
//                for recipe in self.data {
//                    for option in recipe.healthLabels {
//                        if check_label(userInfo: self.userInfo, option: option) == false {
//                            // if label isn't toggled, don't
//                            insert = false
//                        }
//                    }
//                }
                
                if insert == true {
                    self.data.append(info)
                }
            }
            
            // ALGORITHM
            for i in self.data {
                self.ranked.append(i)
            }
        //            self.ranked.append(self.data[0])
        //            self.ranked.append(self.data[1])
        //            self.ranked.append(self.data[2])
        })
    }
    
}

func check_label(userInfo: userSettings, option: String) -> Bool {
    for i in userInfo.user_profile.health_options {
        if i.name == option {
            // check for that option is toggled
            if i.toggle == true {
                return true
            }
            else {
                return false
            }
        }
    }
    return true
}
