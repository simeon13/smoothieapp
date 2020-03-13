//
//  FoodView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//.

import SwiftUI
import FirebaseDatabase

// for string formatting
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


struct FoodView: View {
    @EnvironmentObject var userInfo : userSettings
    @ObservedObject var data = observer()
    
    @State private var searchTerm : String = ""
    @State var pickerselection = 0
    
    var body: some View {
            List {
                //search bar
                SearchBar(text: $searchTerm)
                
                Picker(selection: $pickerselection, label: Text("Stats"))
                {
                    Text("All").tag(0)
                    Text("Recipes").tag(1)
                    Text("Vegetables").tag(2)
                    Text("Dairy").tag(3)
                    
                    }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 10).colorInvert()
                
                Picker(selection: $pickerselection, label: Text("Stats"))
                {
                    Text("Fish").tag(4)
                    Text("Fruits").tag(5)
                    Text("Grains").tag(6)
                    Text("Poultry").tag(7)
                    
                    }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 10).colorInvert()
                
                // Recipes
                if pickerselection == 0 || pickerselection == 1{
                Section(header: Text("Recipes")) {
                    ForEach(self.data.recipe_names.filter{
                        self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
                    }, id: \.self){name in
                        ForEach(self.data.recipe_data){ i in
                            if name == i.name{
                                NavigationLink(destination: RecipeView(recipe: i)) {
                                    RecipeRow(recipe: i)
                                }
                            }
                        }
                    }
                }
                }

                // Foods
                if pickerselection == 0 || pickerselection == 2{
                Section(header: Text("Vegetables")) {
                    ForEach(self.data.vegetable_names.filter{
                        self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
                    }, id: \.self){name in
                        ForEach(self.data.vegetable_data){i in
                            if name == i.name{
                                NavigationLink(destination: FoodItemView(foodItem: i)) {
                                    FoodItemRow(foodItem: i)
                                }
                            }
                        }
                    }
                }
                }

                if pickerselection == 0 || pickerselection == 3{
                Section(header: Text("Dairy")) {
                    ForEach(self.data.dairy_names.filter{
                        self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
                    }, id: \.self){name in
                        ForEach(self.data.dairy_data){i in
                            if name == i.name{
                                NavigationLink(destination: FoodItemView(foodItem: i)) {
                                    FoodItemRow(foodItem: i)
                                }
                            }
                        }
                    }
                }
                }

                if pickerselection == 0 || pickerselection == 4{
                Section(header: Text("Fish")) {
                    ForEach(self.data.fish_names.filter{
                        self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
                    }, id: \.self){name in
                        ForEach(self.data.fish_data){i in
                            if name == i.name{
                                NavigationLink(destination: FoodItemView(foodItem: i)) {
                                    FoodItemRow(foodItem: i)
                                }
                            }
                        }
                    }
                }
                }

                if pickerselection == 0 || pickerselection == 5{
                Section(header: Text("Fruits")) {
                    ForEach(data.fruit_names.filter{
                        self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
                    }, id: \.self){name in
                        ForEach(self.data.fruit_data){i in
                            if name == i.name{
                                NavigationLink(destination: FoodItemView(foodItem: i)) {
                                    FoodItemRow(foodItem: i)
                                }
                            }
                        }
                    }
                }
                }

                if pickerselection == 0 || pickerselection == 6{
                Section(header: Text("Grains")) {
                    ForEach(data.grain_names.filter{
                        self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
                    }, id: \.self){name in
                        ForEach(self.data.grain_data){i in
                            if name == i.name{
                                NavigationLink(destination: FoodItemView(foodItem: i)) {
                                    FoodItemRow(foodItem: i)
                                }
                            }
                        }
                    }
                }
                }
                
                if pickerselection == 0 || pickerselection == 7{
                Section(header: Text("Poultry")) {
                    ForEach(self.data.poultry_names.filter{
                        self.searchTerm.isEmpty ? true : $0.localizedStandardContains(self.searchTerm)
                    }, id: \.self){name in
                        ForEach(self.data.poultry_data){i in
                            if name == i.name{
                                NavigationLink(destination: FoodItemView(foodItem: i)) {
                                    FoodItemRow(foodItem: i)
                                }
                            }
                        }
                    }
                }
                }
            }
            .navigationBarTitle("Database Items")
            .listStyle(GroupedListStyle())
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView().environmentObject(userSettings())
    }
}

class observer : ObservableObject {
    @Published var recipe_data = [Recipe]()
    @Published var vegetable_data = [FoodItem]()
    @Published var vegetable_names = [String]()
    @Published var dairy_data = [FoodItem]()
    @Published var dairy_names = [String]()
    @Published var fish_data = [FoodItem]()
    @Published var fish_names = [String]()
    @Published var fruit_data = [FoodItem]()
    @Published var fruit_names = [String]()
    @Published var grain_data = [FoodItem]()
    @Published var grain_names = [String]()
    @Published var poultry_data = [FoodItem]()
    @Published var poultry_names = [String]()
    @Published var food_data = [String]()
    @Published var items = [FoodItem]()
    @Published var recipe_names = [String]()
    
    
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
                let vitaminA = value?["vitamin-A"] as? CGFloat ?? 0.0
                let vitaminB12 = value?["vitamin-B12"] as? CGFloat ?? 0.0
                let vitaminC = value?["vitamin-C"] as? CGFloat ?? 0.0
                let vitaminD = value?["vitamin-D"] as? CGFloat ?? 0.0
                let vitaminE = value?["vitamin-E"] as? CGFloat ?? 0.0
                let vitaminK = value?["vitamin-K"] as? CGFloat ?? 0.0
                let zinc = value?["zinc"] as? CGFloat ?? 0.0
                let healthLabels = value?["health-labels"] as? [String] ?? [""]
                let ingredientLines = value?["ingredient-lines"] as? [String] ?? [""]
                let dict = value as! Dictionary<String, Any>
                // create new recipe object
                let info = Recipe(id: name, name: name, url: url, image: image, calcium: calcium, fiber: fiber, iron: iron, magnesium: magnesium, potassium: potassium, protein: protein, vitaminA: vitaminA, vitaminB12: vitaminB12, vitaminC: vitaminC, vitaminD: vitaminD, vitaminE: vitaminE, vitaminK: vitaminK, zinc: zinc,  healthLabels: healthLabels, ingredientLines : ingredientLines, dict: dict)
                self.recipe_data.append(info)
                self.recipe_names.append(info.name)
            }
        })
        
        // FOODS
        let food_list = ["Vegetables", "dairy", "fish", "fruit", "grains", "poultry"]
        for entry in food_list {
            let food_ref = Database.database().reference(withPath: entry)
            food_ref.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let value = child.value as? NSDictionary
                    let name = child.key.capitalized
                    let calcium = value?["calcium"] as? CGFloat ?? 0.0
                    let fiber = value?["fiber"] as? CGFloat ?? 0.0
                    let iron = value?["iron"] as? CGFloat ?? 0
                    let magnesium = value?["magnesium"] as? CGFloat ?? 0
                    let potassium = value?["potassium"] as? CGFloat ?? 0
                    let protein = value?["protein"] as? CGFloat ?? 0
                    let vitaminA = value?["vitamin-A"] as? CGFloat ?? 0
                    let vitaminB12 = value?["vitamin-B12"] as? CGFloat ?? 0
                    let vitaminC = value?["vitamin-C"] as? CGFloat ?? 0
                    let vitaminD = value?["vitamin-D"] as? CGFloat ?? 0
                    let vitaminE = value?["vitamin-E"] as? CGFloat ?? 0
                    let vitaminK = value?["vitamin-K"] as? CGFloat ?? 0
                    let zinc = value?["zinc"] as? CGFloat ?? 0
                    let dict = value as! Dictionary<String, Any>
                    // create new foodItem object
                    let food_item = FoodItem(id: name, name: name, calcium: calcium, fiber: fiber, iron: iron, magnesium: magnesium, potassium: potassium, protein: protein, vitaminA: vitaminA, vitaminB12: vitaminB12, vitaminC: vitaminC, vitaminD: vitaminD, vitaminE: vitaminE, vitaminK: vitaminK, zinc: zinc, dict: dict)
                    if (entry == "Vegetables"){
                        self.vegetable_data.append(food_item)
                        self.food_data.append(food_item.name)
                        self.vegetable_names.append(food_item.name)
                        self.items.append(food_item)
                    }
                    if (entry == "dairy"){
                        self.dairy_data.append(food_item)
                        self.dairy_names.append(food_item.name)
                        self.food_data.append(food_item.name)
                        self.items.append(food_item)
                    }
                    if (entry == "fish"){
                        self.fish_data.append(food_item)
                        self.fish_names.append(food_item.name)
                        self.food_data.append(food_item.name)
                        self.items.append(food_item)
                    }
                    if (entry == "fruit"){
                        self.fruit_data.append(food_item)
                        self.fruit_names.append(food_item.name)
                        self.food_data.append(food_item.name)
                        self.items.append(food_item)
                    }
                    if (entry == "grains"){
                        self.grain_data.append(food_item)
                        self.grain_names.append(food_item.name)
                        self.food_data.append(food_item.name)
                        self.items.append(food_item)
                    }
                    if (entry == "poultry"){
                        self.poultry_data.append(food_item)
                        self.poultry_names.append(food_item.name)
                        self.food_data.append(food_item.name)
                        self.items.append(food_item)
                    }
                }
            })
        }
        
        // testing use of dictionary
        // can be deleted, im playing around with it.

        
    }
}

struct RecipeView: View {
    var recipe: Recipe
    var body: some View {
        
        VStack{
            Text(recipe.name)
            .font(.title)
            List{
                
                Group{
                    // All information from firebase (NS dict) is now
                    // accessible through dicts and arrays
                    Section(header: Text("Minerals")){
                        ForEach(recipe.mineralKeys, id: \.self){key in
                            HStack(){
                                Text(key.capitalizingFirstLetter().replacingOccurrences(of:"-", with: " "))
                                
                                Spacer()
                                
                                Text(String(format: "%.2f ", (self.recipe.dict[key] as? CGFloat ?? 0)) + (self.recipe.units[key] ?? ""))
                            }
                        }
                    }
                
                    Section(header: Text("Vitamins")){
                        ForEach(recipe.vitaminKeys, id: \.self){key in
                            HStack(){
                                Text(key.capitalizingFirstLetter().replacingOccurrences(of:"-", with: " "))
                                
                                Spacer()
                                Text(String(format: "%.2f ", (self.recipe.dict[key] as? CGFloat ?? 0)) + (self.recipe.units[key] ?? ""))
                            }
                        }
                    }
                }
                
                Group{

                    Section(header: Text("Health Labels")){
                        ForEach(recipe.healthLabels, id: \.self){label in
                            HStack(){
                                Text(label)
                            }
                        }
                    }
                    
                    Section(header: Text("Ingredient Lines")){
                        
                        ForEach(recipe.ingredientLines, id: \.self){line in
                            HStack(){
                                Text(line)
                            }
                        }
                    }
                    
                    Section(header: Text("Click button to add recipe")){
                        addRecipeButton(foodItem: recipe, ounces: 1)
                    }
                    
                }
            }
        }
    }
}

struct RecipeRow: View {
    var recipe: Recipe
    var body: some View {
        Text(recipe.name)
    }
}

class Recipe : Identifiable {
    /*All information from firebase (NS dict) is now
     accessible through dicts and arrays
     
     So essentially, we can add new nutrients to the database
     and it will automatically appear for each food (under minerals
     with mg units)
     
     */
    var id : String
    var name : String
    var url : String
    var image : String
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
    var healthLabels: [String]
    var ingredientLines: [String]
    var dict: Dictionary<String, Any>
    var vitaminKeys: [String]
    var mineralKeys: [String]
    var units: Dictionary<String, String>

    
    
    init(id: String, name: String, url: String, image: String, calcium: CGFloat, fiber: CGFloat, iron: CGFloat, magnesium: CGFloat, potassium: CGFloat, protein: CGFloat, vitaminA: CGFloat, vitaminB12: CGFloat, vitaminC: CGFloat, vitaminD: CGFloat, vitaminE: CGFloat, vitaminK: CGFloat, zinc: CGFloat,  healthLabels: [String], ingredientLines : [String], dict: Dictionary<String, Any>){

        self.id = id
        self.name = name
        self.url = url
        self.image = image
        self.calcium = calcium
        self.fiber = fiber
        self.iron = iron
        self.magnesium = magnesium
        self.potassium = potassium
        self.protein = protein
        self.vitaminA = vitaminA
        self.vitaminB12 = vitaminB12
        self.vitaminC = vitaminC
        self.vitaminD = vitaminD
        self.vitaminE = vitaminE
        self.vitaminK = vitaminK
        self.zinc = zinc
        self.vitaminKeys = []
        self.mineralKeys = []
        
        // lists
        self.healthLabels = healthLabels
        self.ingredientLines = ingredientLines
        
        // dictionary of all firebase data
        self.dict = dict
        
        self.units = ["protein":"g", "vitamin-A": "µg", "vitamin-B12": "µg", "vitamin-D": "IU", "vitamin-K": "µg"]
            
        for (key,_) in dict{
            if (dict[key] as? CGFloat) != nil{
                if (key.contains("vitamin")){
                    self.vitaminKeys.append(key)
                }
                else{
                    self.mineralKeys.append(key)
                }
                if(self.units[key] == nil){
                    self.units[key] = "mg"
                }
                
            }
            
        }
        self.vitaminKeys = vitaminKeys.sorted()
        self.mineralKeys = mineralKeys.sorted()
        
    }

}
	
struct FoodItemView: View {
    /*All information from firebase (NS dict) is now
     accessible through dicts and arrays
     
     So essentially, we can add new nutrients to the database
     and it will automatically appear for each food (under minerals
     with mg units)
     
     */
    var foodItem : FoodItem
    @State private var ounces = 0
    var body: some View {
        VStack{
            Text(foodItem.name)
            .font(.title)
            List{
            
                
                // All information from firebase (NS dict) is now
                // accessible through dicts and arrays
                Section(header: Text("Minerals")){
                    ForEach(foodItem.mineralKeys, id: \.self){key in
                        HStack(){
                            Text(key.capitalizingFirstLetter().replacingOccurrences(of:"-", with: " "))
                            
                            Spacer()
                            
                            Text(String(format: "%.2f ", (self.foodItem.dict[key] as? CGFloat ?? 0)) + (self.foodItem.units[key] ?? ""))
                        }
                    }
                }
            
                Section(header: Text("Vitamins")){
                    ForEach(foodItem.vitaminKeys, id: \.self){key in
                        HStack(){
                            Text(key.capitalizingFirstLetter().replacingOccurrences(of:"-", with: " "))
                            
                            Spacer()
                            Text(String(format: "%.2f ", (self.foodItem.dict[key] as? CGFloat ?? 0)) + (self.foodItem.units[key] ?? ""))
                        }
                    }
                }

                    
                Section(header: Text("Choose amount")){
                    HStack(){
                        Picker(selection: $ounces, label: Text("Ounces")){
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                            Text("6").tag(6)
                            Text("7").tag(7)
                            Text("8").tag(8)
                        }
                        addFoodButton(foodItem: foodItem, ounces: ounces)
                    }
                }
            }
        }
    }
}

struct FoodItemRow: View {
    var foodItem : FoodItem
    var body: some View {
        Text(foodItem.name)
    }
}


struct addFoodButton: View {
    var foodItem : FoodItem
    var ounces : Int
    @State private var alertSaved = false
    @EnvironmentObject var userInfo : userSettings
    var body: some View {
        Button(action: {
            self.userInfo.total_values.calcium += self.foodItem.calcium * CGFloat(self.ounces)
            self.userInfo.total_values.fiber += self.foodItem.fiber * CGFloat(self.ounces)
            self.userInfo.total_values.iron += self.foodItem.iron * CGFloat(self.ounces)
            self.userInfo.total_values.magnesium += self.foodItem.magnesium * CGFloat(self.ounces)
            self.userInfo.total_values.potassium += self.foodItem.potassium * CGFloat(self.ounces)
            self.userInfo.total_values.protein += self.foodItem.protein * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminA += self.foodItem.vitaminA * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminB12 += self.foodItem.vitaminB12 * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminC += self.foodItem.vitaminC * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminD += self.foodItem.vitaminD * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminE += self.foodItem.vitaminE * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminK += self.foodItem.vitaminK * CGFloat(self.ounces)
            self.userInfo.total_values.zinc += self.foodItem.zinc * CGFloat(self.ounces)
            if (self.ounces > 0){
                self.alertSaved = true
            }
            }){
                Text("add food")
                .padding()
                .background(Color.black.opacity(0.2))
                
                .alert(isPresented: $alertSaved){() -> Alert in
                    Alert (title: Text("Saved food item!"), message:	 Text("go back to items to add other foods"))
                        
                  
                }
                
                
            
        }
    }
}




struct addRecipeButton: View {
    var foodItem : Recipe
    var ounces : Int
    @State private var alertSaved = false
    @EnvironmentObject var userInfo : userSettings
    var body: some View {
        Button(action: {
            self.userInfo.total_values.calcium += self.foodItem.calcium * CGFloat(self.ounces)
            self.userInfo.total_values.fiber += self.foodItem.fiber * CGFloat(self.ounces)
            self.userInfo.total_values.iron += self.foodItem.iron * CGFloat(self.ounces)
            self.userInfo.total_values.magnesium += self.foodItem.magnesium * CGFloat(self.ounces)
            self.userInfo.total_values.potassium += self.foodItem.potassium * CGFloat(self.ounces)
            self.userInfo.total_values.protein += self.foodItem.protein * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminA += self.foodItem.vitaminA * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminB12 += self.foodItem.vitaminB12 * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminC += self.foodItem.vitaminC * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminD += self.foodItem.vitaminD * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminE += self.foodItem.vitaminE * CGFloat(self.ounces)
            self.userInfo.total_values.vitaminK += self.foodItem.vitaminK * CGFloat(self.ounces)
            self.userInfo.total_values.zinc += self.foodItem.zinc * CGFloat(self.ounces)
            if (self.ounces > 0){
                self.alertSaved = true
            }
            }){
                Text("add recipe")
                .padding()
                .background(Color.black.opacity(0.2))
                
                .alert(isPresented: $alertSaved){() -> Alert in
                    Alert (title: Text("Saved recipe!"), message:     Text("go back to items to add other foods"))
                
                  
                }
        }
    }
}



class FoodItem : Identifiable {
    var id : String
    var name : String
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
    var dict: Dictionary<String, Any>
    var vitaminKeys: [String]
    var mineralKeys: [String]
    var units: Dictionary<String, String>
    
    init(id: String, name: String, calcium: CGFloat, fiber: CGFloat, iron: CGFloat, magnesium: CGFloat, potassium: CGFloat, protein: CGFloat, vitaminA: CGFloat, vitaminB12: CGFloat, vitaminC: CGFloat, vitaminD: CGFloat, vitaminE: CGFloat, vitaminK: CGFloat, zinc: CGFloat, dict: Dictionary<String, Any> = [:]){
        self.id = id
        self.name = name

        self.calcium = calcium
        self.fiber = fiber
        self.iron = iron
        self.magnesium = magnesium
        self.potassium = potassium
        self.protein = protein
        self.vitaminA = vitaminA
        self.vitaminB12 = vitaminB12
        self.vitaminC = vitaminC
        self.vitaminD = vitaminD
        self.vitaminE = vitaminE
        self.vitaminK = vitaminK
        self.zinc = zinc
        self.dict = dict
        self.vitaminKeys = []
        self.mineralKeys = []
        
        self.units = ["protein":"g", "vitamin-A": "µg", "vitamin-B12": "µg", "vitamin-D": "IU", "vitamin-K": "µg"]
            
        for (key,_) in dict{
            if (dict[key] as? CGFloat) != nil{
                if (key.contains("vitamin")){
                    self.vitaminKeys.append(key)
                }
                else{
                    self.mineralKeys.append(key)
                }
                if(self.units[key] == nil){
                    self.units[key] = "mg"
                }
                
            }
            
        }
        self.vitaminKeys = vitaminKeys.sorted()
        self.mineralKeys = mineralKeys.sorted()
            
        
    }
}

struct SearchBar : UIViewRepresentable{
    @Binding var text : String
    class Coordinator : NSObject, UISearchBarDelegate{
        @Binding var text : String
        init(text : Binding<String>){
            _text = text
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
            text = searchText
        }
    }
    func makeCoordinator() -> SearchBar.Coordinator{
        return Coordinator(text: $text)
    }
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

