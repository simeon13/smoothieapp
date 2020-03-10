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
import FirebaseDatabase

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
                        .padding(.top, 80.0)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Hello \(userInfo.user_profile.first_name)!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    .frame(height: 10.0)
                    
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
                    }.padding(.all, 8)
                    
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
                    }.padding(.all, 8)
                    
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
                    }.padding(.all, 8)
                    
                    
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
                    }.simultaneousGesture(TapGesture().onEnded{
                        grab_recommendations(userInfo: self.userInfo)
                    })
                    .padding(.all, 8)
                    
                    NavigationLink(destination: MapView()){
                            Text("Nearby Locations")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.all)
                                .frame(width: 250.0)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .center)
                    }.padding(.all, 8)
                    
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
                    }.padding(.all, 8)
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
        
        let day = 0...4
        let nutrient = 0...12
        var weekly_values = [[CGFloat]]()
        for _ in nutrient{
            var nv = [CGFloat]()
            for _ in day{
                nv.append(CGFloat.random(in: 120..<201))
            }
            weekly_values.append(nv)
        }
        
        user_profile = UserProfile(id: "id", first_name: first_name, last_name: last_name, age: age, gender: str_gender, allergies: [String](), health_options: health_options, time: Date(), weekly: weekly_values, ranked_recipes: [Recipe]())
            
        total_values = TotalValues(id: "id", calcium: 0.0, fiber: 0.0, iron: 0.0, magnesium: 0.0, potassium: 0.0, protein: 0.0, vitaminA: 0.0, vitaminB12: 0.0, vitaminC: 0.0, vitaminD: 0.0, vitaminE: 0.0, vitaminK: 0.0, zinc: 0.0)
        
        max_values = MaxValues(id: "id", calcium: 1.0, fiber: 1.0, iron: 1.0, magnesium: 1.0, potassium: 1.0, protein: 1.0, vitaminA: 1.0, vitaminB12: 1.0, vitaminC: 1.0, vitaminD: 1.0, vitaminE: 1.0, vitaminK: 1.0, zinc: 1.0)
                
        nutrient_units =  NutrientUnits(id: "id", calcium: "mg", fiber: "g", iron: "mg", magnesium: "mg", potassium: "mg", protein: "g", vitaminA: "µg", vitaminB12: "µg", vitaminC: "mg", vitaminD: "IU", vitaminE: "mg", vitaminK: "µg", zinc: "mg")
        
        let gstring = get_guidelines(gender: str_gender, str_age: age)
        let ref = Database.database().reference(withPath: "guidelines/\(gstring)")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let calcium = value?["calcium"] as? CGFloat ?? 1.0
            let fiber = value?["fiber"] as? CGFloat ?? 1.0
            let iron = value?["iron"] as? CGFloat ?? 1.0
            let magnesium = value?["magnesium"] as? CGFloat ?? 1.0
            let potassium = value?["potassium"] as? CGFloat ?? 1.0
            let protein = value?["protein"] as? CGFloat ?? 1.0
            let vitaminA = value?["vitamin-A"] as? CGFloat ?? 1.0
            let vitaminB12 = value?["vitamin-B12"] as? CGFloat ?? 1.0
            let vitaminC = value?["vitamin-C"] as? CGFloat ?? 1.0
            let vitaminD = value?["vitamin-D"] as? CGFloat ?? 1.0
            let vitaminE = value?["vitamin-E"] as? CGFloat ?? 1.0
            let vitaminK = value?["vitamin-K"] as? CGFloat ?? 1.0
            let zinc = value?["zinc"] as? CGFloat ?? 1.0
            
            self.max_values.calcium = calcium
            self.max_values.fiber = fiber
            self.max_values.iron = iron
            self.max_values.magnesium = magnesium
            self.max_values.potassium = potassium
            self.max_values.protein = protein
            self.max_values.vitaminA = vitaminA
            self.max_values.vitaminB12 = vitaminB12
            self.max_values.vitaminC = vitaminC
            self.max_values.vitaminD = vitaminD
            self.max_values.vitaminE = vitaminE
            self.max_values.vitaminK = vitaminK
            self.max_values.zinc = zinc
        })
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
    var time: Date
    var weekly: [[CGFloat]]
    var ranked_recipes: [Recipe]
    
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

struct WeeklyValues : Identifiable {
    var id : String
    var calcium : [CGFloat]
    var fiber : [CGFloat]
    var iron : [CGFloat]
    var magnesium : [CGFloat]
    var potassium : [CGFloat]
    var protein : [CGFloat]
    var vitaminA : [CGFloat]
    var vitaminB12 : [CGFloat]
    var vitaminC : [CGFloat]
    var vitaminD : [CGFloat]
    var vitaminE : [CGFloat]
    var vitaminK : [CGFloat]
    var zinc : [CGFloat]
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


func get_guidelines(gender: String, str_age: String) -> String {
    // female
    let age = Int(str_age) ?? 18
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

extension Date {
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
   }

    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
}

func grab_recommendations(userInfo: userSettings){
    var data = [Recipe]()
    userInfo.user_profile.ranked_recipes.removeAll()
    
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
        rank_recipes(userInfo: userInfo, recipes: data, dict: nutrients_dict)
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

func nutrient_rank(userInfo: userSettings) -> [CGFloat : String] {
    var dict = [CGFloat : String]()
//    let calcium = (userInfo.total_values.calcium / userInfo.max_values.calcium)
//    let fiber = (userInfo.total_values.fiber / userInfo.max_values.fiber)
//    let iron = (userInfo.total_values.iron / userInfo.max_values.iron)
//    let magnesium = (userInfo.total_values.magnesium / userInfo.max_values.magnesium)
//    let potassium = (userInfo.total_values.potassium / userInfo.max_values.potassium)
//    let protein = (userInfo.total_values.protein / userInfo.max_values.protein)
//    let vitaminA = (userInfo.total_values.vitaminA / userInfo.max_values.vitaminA)
//    let vitaminB12 = (userInfo.total_values.vitaminB12 / userInfo.max_values.vitaminB12)
//    let vitaminC = (userInfo.total_values.vitaminC / userInfo.max_values.vitaminC)
//    let vitaminD = (userInfo.total_values.vitaminD / userInfo.max_values.vitaminD)
//    let vitaminE = (userInfo.total_values.vitaminE / userInfo.max_values.vitaminE)
//    let vitaminK = (userInfo.total_values.vitaminK / userInfo.max_values.vitaminK)
//    let zinc = (userInfo.total_values.zinc / userInfo.max_values.zinc)
    
    let calcium = CGFloat(0.18)
    let fiber = CGFloat(0.25)
    let iron = CGFloat(0.28)
    let magnesium = CGFloat(0.30)
    let potassium = CGFloat(0.40)
    let protein = CGFloat(0.50)
    let vitaminA = CGFloat(0.90)
    let vitaminB12 = CGFloat(0.87)
    let vitaminC = CGFloat(0.81)
    let vitaminD = CGFloat(0.75)
    let vitaminE = CGFloat(0.71)
    let vitaminK = CGFloat(0.65)
    let zinc = CGFloat(0.60)
    
    dict[calcium] = "calcium"
    dict[fiber] = "fiber"
    dict[iron] = "iron"
    dict[magnesium] = "magnesium"
    dict[potassium] = "potassium"
    dict[protein] = "protein"
    dict[vitaminA] = "vitaminA"
    dict[vitaminB12] = "vitaminB12"
    dict[vitaminC] = "vitaminC"
    dict[vitaminD] = "vitaminD"
    dict[vitaminE] = "vitaminE"
    dict[vitaminK] = "vitaminK"
    dict[zinc] = "zinc"
    
    return dict
}


func rank_recipes(userInfo: userSettings, recipes: [Recipe], dict: [CGFloat:String]){
    var recipe_scores = [CGFloat : Int]()
    for (index, recipe) in recipes.enumerated() {
        // compute a score for the recipe
        // get percentage increase for least3 nutrients (most needed)
        var score = CGFloat(0.0)
        var m = 0
        for (percent, nutrient) in dict.sorted(by: <) {
            // grab nutrient data and compare it to max value
            score += percent_increase(userInfo: userInfo, nutrient: nutrient, recipe: recipe)
            
            m += 1
            if m == 3{ // break after least3
                break
            }
        }
        recipe_scores[score] = index
    }
    
    // sort dict by keys and grab top 3 values
    var i = 0
    for (score, index) in recipe_scores.sorted(by: >){
        userInfo.user_profile.ranked_recipes.append(recipes[index])
        i += 1
        if i == 3{ // break after top3
            break
        }
    }
}

func percent_increase(userInfo: userSettings, nutrient: String, recipe: Recipe) -> CGFloat {
    if nutrient == "calcium" {
        return (recipe.calcium / userInfo.max_values.calcium)
    }
    if nutrient == "fiber" {
        return (recipe.fiber / userInfo.max_values.fiber)
    }
    if nutrient == "iron" {
        return (recipe.iron / userInfo.max_values.iron)
    }
    if nutrient == "magnesium" {
        return (recipe.magnesium / userInfo.max_values.magnesium)
    }
    if nutrient == "potassium" {
        return (recipe.potassium / userInfo.max_values.potassium)
    }
    if nutrient == "protein" {
        return (recipe.protein / userInfo.max_values.protein)
    }
    if nutrient == "vitaminA" {
        return (recipe.vitaminA / userInfo.max_values.vitaminA)
    }
    if nutrient == "vitaminB12" {
        return (recipe.vitaminB12 / userInfo.max_values.vitaminB12)
    }
    if nutrient == "vitaminC" {
           return (recipe.vitaminC / userInfo.max_values.vitaminC)
    }
    if nutrient == "vitaminD" {
           return (recipe.vitaminD / userInfo.max_values.vitaminD)
    }
    if nutrient == "vitaminE" {
           return (recipe.vitaminE / userInfo.max_values.vitaminE)
    }
    if nutrient == "vitaminK" {
           return (recipe.vitaminK / userInfo.max_values.vitaminK)
    }
    if nutrient == "zinc" {
           return (recipe.zinc / userInfo.max_values.zinc)
    }
    return 0
}
