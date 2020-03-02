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
//                    ForEach(userInfo.user_profile.recommendations.indices, id: \.self){i in
//                        Text("\(i+1) - \(self.userInfo.user_profile.recommendations[i].name)")
//                        NavigationLink(destination: RecipeView(recipe: self.userInfo.user_profile.recommendations[i])) {
//                            RecipeRow(recipe: self.userInfo.user_profile.recommendations[i])
//                        }
//                    }
                    ForEach(recipes.data){i in
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
                let info = Recipe(id: name, name: name, url: url, image: image, calcium: calcium, fiber: fiber, iron: iron, magnesium: magnesium, potassium: potassium, protein: protein, vitaminA: vitaminA, vitaminB12: vitaminB12, vitaminC: vitaminC, vitaminD: vitaminD, vitaminE: vitaminE, vitaminK: vitaminK, zinc: zinc)
                self.data.append(info)
            }
        })
    }
}
