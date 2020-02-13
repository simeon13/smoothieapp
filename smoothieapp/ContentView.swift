//
//  ContentView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 1/16/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userInfo = starting()
    
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

class starting : ObservableObject {
    @Published var user_profile: UserProfile
    @Published var total_values = [TotalValues]()
    @Published var max_values = [MaxValues]()
    
    init(){
        // grab whatever you can and add to user profile
        user_profile = UserProfile(id: "id", first_name: "John", last_name: "Doe", age: 20, gender: "Male", allergies: [String](), health_options: [String]())
        
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

struct MaxValues : Identifiable {
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
