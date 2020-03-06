//
//  PreferencesView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct PreferencesView: View {
    @EnvironmentObject var userInfo: userSettings
    @State var allergies = ""
    @State var healthoptions = ""
    
    var body: some View {
        VStack() {
            Divider()
            UpdateButton()
            Form {
                    Section (header: Text("Personal Info")) {
                        TextField("Your first name", text: $userInfo.user_profile.first_name)
                        TextField("Your last name", text: $userInfo.user_profile.last_name)
                        
                        Picker("Gender", selection: $userInfo.user_profile.gender) {
                            Text("Female").tag("Female")
                            Text("Male").tag("Male")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Picker("Age", selection: $userInfo.user_profile.age) {
                            ForEach(9..<100) { i in
                                Text(String(i)).tag(String(i))
                            }
                        }
                    }

                    
                    Section(header: Text("Health Options")) {
                        List {
                            ForEach (0..<6){ i in
                                Toggle(isOn: self.$userInfo.user_profile.health_options[i].toggle){
                                    Text(self.userInfo.user_profile.health_options[i].name)
                                }
                            } 
                        }
                    }
            }
            .navigationBarTitle("Preferences")
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView().environmentObject(userSettings())
    }
}

struct UpdateButton : View {
    @EnvironmentObject var userInfo: userSettings
    @State private var alertSaved = false

    var body: some View {
        Button(action: {
            // UPDATE ALL VALUES
            let gstring = get_guidelines(gender: self.userInfo.user_profile.gender, str_age: self.userInfo.user_profile.age)
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
                
                self.userInfo.max_values.calcium = calcium
                self.userInfo.max_values.fiber = fiber
                self.userInfo.max_values.iron = iron
                self.userInfo.max_values.magnesium = magnesium
                self.userInfo.max_values.potassium = potassium
                self.userInfo.max_values.protein = protein
                self.userInfo.max_values.vitaminA = vitaminA
                self.userInfo.max_values.vitaminB12 = vitaminB12
                self.userInfo.max_values.vitaminC = vitaminC
                self.userInfo.max_values.vitaminD = vitaminD
                self.userInfo.max_values.vitaminE = vitaminE
                self.userInfo.max_values.vitaminK = vitaminK
                self.userInfo.max_values.zinc = zinc
            })
            //
            self.alertSaved = true
        }) {
            Text("Update Health Values")
        }
        .padding(10)
        .font(.callout)
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(30)
        
        .alert(isPresented: $alertSaved){() -> Alert in
            Alert (title: Text("Saved!"), message: Text("Health Values Updated Based on Gender and Age."))
        }
    }
    
}
