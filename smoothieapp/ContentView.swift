//
//  ContentView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 1/16/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(destination: FoodView()){
                        Text("Food Information")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .padding(.all)
                            .frame(width: 250.0)
                            .background(Color.blue)
                            .cornerRadius(10)
                }.padding(.all, 10)
                
                NavigationLink(destination: NutrientView()){
                        Text("Nutrient Levels")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .padding(.all)
                            .frame(width: 250.0)
                            .background(Color.blue)
                            .cornerRadius(10)
                }.padding(.all, 10)
                
                NavigationLink(destination: RecommendationView()){
                        Text("Recommendations")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .padding(.all)
                            .frame(width: 250.0)
                            .background(Color.blue)
                            .cornerRadius(10)
                }.padding(.all, 10)
                
                NavigationLink(destination: PreferencesView()){
                        Text("Preferences")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .padding(.all)
                            .frame(width: 250.0)
                            .background(Color.blue)
                            .cornerRadius(10)
                }.padding(.all, 10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
