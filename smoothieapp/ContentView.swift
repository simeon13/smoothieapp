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
            ZStack {
                Color.gray.opacity(0.3)
            
                VStack(alignment: .leading) {
                    Text("Smoothie Genie")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .padding([.leading, .bottom, .trailing], 10.0)
                    Spacer()
                        .frame(height: 80.0)
                    
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
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Dashboard", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UserProfile : Identifiable {
    var id : String
    var first_name : String
    var last_name : String
    var age : Int
    var gender : String
    var allergies : [String]
    var health_options : [String]
}

struct totalValues : Identifiable {
    var id : String
    var calcium : Double
    var fiber : Double
    var iron : Double
    var magnesium : Double
    var potassium : Double
    var protein : Double
    var vitaminA : Double
    var vitaminB12 : Double
    var vitaminC : Double
    var vitaminD : Double
    var vitaminE : Double
    var vitaminK : Double
    var zinc : Double
}

struct maxValues : Identifiable {
    var id : String
    var calcium : Double
    var fiber : Double
    var iron : Double
    var magnesium : Double
    var potassium : Double
    var protein : Double
    var vitaminA : Double
    var vitaminB12 : Double
    var vitaminC : Double
    var vitaminD : Double
    var vitaminE : Double
    var vitaminK : Double
    var zinc : Double
}
