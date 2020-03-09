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
                Section (header: Text("Current Recommendations")){
                    ForEach(userInfo.user_profile.ranked_recipes){i in
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
