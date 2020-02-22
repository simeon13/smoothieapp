//
//  PreferencesView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var userInfo: userSettings
    @State var options: [String] = ["Vegan", "Balanced", "Vegetarian", "Tree-Nut-Free", "Low-Carb", "Peanut-Free", "Low-Fat"]
    @State var selections: [String] = []
    @State var allergies = ""
    @State var healthoptions = ""
    
    var body: some View {
        NavigationView {
                Form {
                    Section (header: Text("Personal Info")) {
                        TextField("Your first name", text: $userInfo.user_profile.first_name)
                        TextField("Your last name", text: $userInfo.user_profile.last_name)
                        
                        Picker("Gender", selection: $userInfo.user_profile.gender) {
                            Text("Female").tag("Female")
                            Text("Male").tag("Male")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        // convert age to string
                        Picker("Age", selection: $userInfo.user_profile.age) {
                            ForEach(9..<100) { i in
                                Text(String(i)).tag(String(i))
                            }
                        }
                    }
                    
                    List {
                        Section(header: Text("Health Options")) {
                            ForEach(userInfo.user_profile.health_options, id: \.id){ item in
                                MultipleToggle(title: item.id, toggle: item.toggle)
                            }
                        }
                    }
            }.navigationBarTitle("Preferences")
        }
    }
}

struct MultipleToggle : View {
    @State var title: String
    @State var toggle : Bool
    
    var body: some View {
       List {
        Toggle(isOn: $toggle){
                Text(self.title)
            }
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView().environmentObject(userSettings())
    }
}
