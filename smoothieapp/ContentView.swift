//
//  ContentView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 1/16/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userInfo : userSettings
    
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
                        .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                    .frame(height: 5.0)
                    
                    
                    Text("Hello \(userInfo.user_profile.first_name)!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    .frame(height: 25.0)
                    
                    NavigationLink(destination: FoodView()){
                            Text("Food Information")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.all)
                                .frame(width: 250.0)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .center)
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
                                .frame(maxWidth: .infinity, alignment: .center)
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
                                .frame(maxWidth: .infinity, alignment: .center)
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
                                .frame(maxWidth: .infinity, alignment: .center)
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

class userSettings : ObservableObject {
    @Published var user_profile: UserProfile
    @Published var total_values: TotalValues
    @Published var max_values: MaxValues
    
    init(){
        // grab whatever you can and add to user profile
        // HARDCODED VALUES
        user_profile = UserProfile(id: "id", first_name: "John", last_name: "Doe", age: 20, gender: "Male", allergies: [String](), health_options: [String]())
            
        total_values = TotalValues(id: "id", calcium: 0.0, fiber: 0.0, iron: 0.0, magnesium: 0.0, potassium: 0.0, protein: 0.0, vitaminA: 0.0, vitaminB12: 0.0, vitaminC: 0.0, vitaminD: 0.0, vitaminE: 0.0, vitaminK: 0.0, zinc: 0.0)
        
        
        max_values = MaxValues(id: "id", calcium: 100.0, fiber: 100.0, iron: 100.0, magnesium: 100.0, potassium: 100.0, protein: 100.0, vitaminA: 100.0, vitaminB12: 100.0, vitaminC: 100.0, vitaminD: 100.0, vitaminE: 100.0, vitaminK: 100.0, zinc: 100.0)
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

struct TotalValues : Identifiable {
    var id : String
    var calcium : CGFloat
    var fiber : CGFloat
    var iron : CGFloat
    var magnesium : CGFloat
    var potassium : CGFloat
    var protein : CGFloat
    var vitaminA : CGFloat
    var vitaminB12 : CGFloat
    var vitaminC : CGFloat
    var vitaminD : CGFloat
    var vitaminE : CGFloat
    var vitaminK : CGFloat
    var zinc : CGFloat
}

struct MaxValues : Identifiable {
    var id : String
    var calcium : CGFloat
    var fiber : CGFloat
    var iron : CGFloat
    var magnesium : CGFloat
    var potassium : CGFloat
    var protein : CGFloat
    var vitaminA : CGFloat
    var vitaminB12 : CGFloat
    var vitaminC : CGFloat
    var vitaminD : CGFloat
    var vitaminE : CGFloat
    var vitaminK : CGFloat
    var zinc : CGFloat
}
