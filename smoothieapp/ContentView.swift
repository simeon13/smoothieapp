//
//  ContentView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 1/16/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI
import HealthKit
import CloudKit

struct ContentView: View {
    @EnvironmentObject var userInfo : userSettings
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.pink.opacity(0.15)
            
                VStack(alignment: .leading) {
                    Text("Smoothie Genie")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .padding([.leading, .bottom, .trailing], 10.0)
                        .padding(.top, 50.0)
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
                    
                    NavigationLink(destination: WeeklyView()){
                            Text("Weekly Nutrients")
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
            .navigationBarTitle("Home", displayMode: .inline)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(userSettings())
    }
}


class userSettings : ObservableObject {
    @Published var user_profile: UserProfile
    @Published var total_values: TotalValues
    @Published var max_values: MaxValues
    @Published var nutrient_units : NutrientUnits
    
    init(){
        // grab age, gender, first name, and last name
        var age = "18"
        var str_gender = "Male"
        let first_name = ""
        let last_name = ""
        
        // HEALTH KIT
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here.
            let healthStore = HKHealthStore()
            // get permission
            let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)
            
            let healthKitTypesToWrite: Set<HKSampleType> = []
            let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth!,
                                                           biologicalSex!]

            healthStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
                if !success {
                    print("Error")
                }
            }
            
            do {
                let birthdayComponents =  try healthStore.dateOfBirthComponents()
                let gender = try healthStore.biologicalSex().biologicalSex.rawValue
                
                if (gender == 1){
                    str_gender = "Female"
                }
                
                //2. Use Calendar to calculate age.
                let today = Date()
                let calendar = Calendar.current
                let todayDateComponents = calendar.dateComponents([.year], from: today)
                let thisYear = todayDateComponents.year!
                age = String(thisYear - birthdayComponents.year!)
            } catch {
                print(error)
            }
        }
        
        let hlist = ["Vegan", "Balanced", "Vegetarian", "Tree-Nut-Free", "Low-Carb", "Peanut-Free", "Low-Fat"]
        var health_options = [HealthOptions]()
        for i in hlist {
            health_options.append(HealthOptions(id: "id", name: i, toggle: false))
        }
        
        
        user_profile = UserProfile(id: "id", first_name: first_name, last_name: last_name, age: age, gender: str_gender, allergies: [String](), health_options: health_options, recommendations: [Recipe]())
            
        total_values = TotalValues(id: "id", calcium: 0.0, fiber: 0.0, iron: 0.0, magnesium: 0.0, potassium: 0.0, protein: 0.0, vitaminA: 0.0, vitaminB12: 0.0, vitaminC: 0.0, vitaminD: 0.0, vitaminE: 0.0, vitaminK: 0.0, zinc: 0.0)
        
        max_values = MaxValues(id: "id", calcium: 1000.0, fiber: 28.0, iron: 18.0, magnesium: 310.0, potassium: 4700.0, protein: 46.0, vitaminA: 700, vitaminB12: 2.4, vitaminC: 75.0, vitaminD: 600.0, vitaminE: 15.0, vitaminK: 90.0, zinc: 8.0)
        
        nutrient_units =  NutrientUnits(id: "id", calcium: "mg", fiber: "g", iron: "mg", magnesium: "mg", potassium: "mg", protein: "g", vitaminA: "µg", vitaminB12: "µg", vitaminC: "mg", vitaminD: "IU", vitaminE: "mg", vitaminK: "µg", zinc: "mg")
    }
}

struct testRecipe : Identifiable {
    var id : String
    var name : String
}

struct UserProfile : Identifiable {
    var id : String
    var first_name : String
    var last_name : String
    var age : String
    var gender : String
    var allergies : [String]
    var health_options : [HealthOptions]
    var recommendations : [Recipe]
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

struct NutrientUnits : Identifiable {
    var id: String
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

struct HealthOptions : Identifiable {
    var id: String
    var name: String
    var toggle: Bool
}


func get_guidelines(gender: String, age: Int) -> String {
    // female
    var result = ""
    if (gender == "Female"){
        if (9...13).contains(age){
            result = "f9-13"
        }
        else if (14...18).contains(age){
            result = "f14-18"
        }
        else if (19...30).contains(age){
            result = "f19-30"
        }
        else if (31...50).contains(age){
            result = "f31-50"
        }
        else if (51...100).contains(age){
            result = "f51+"
        }
    }
    
    // male
    if (gender == "Male"){
        if (9...13).contains(age){
            result = "m9-13"
        }
        else if (14...18).contains(age){
            result = "m14-18"
        }
        else if (19...30).contains(age){
            result = "m19-30"
        }
        else if (31...50).contains(age){
            result = "m31-50"
        }
        else if (51...100).contains(age){
            result = "m51+"
        }
    }
    return result
}
