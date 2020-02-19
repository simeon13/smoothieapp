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
    @State var gender = 1
    @State var firstName = ""
    @State var lastName = ""
    @State var allergies = ""
    @State var healthoptions = ""
    @State var age = 0
    @State var save = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                TextField("Your first name", text: $firstName)
                TextField("Your last name", text: $lastName)
                    Picker(selection: $gender, label: Text("Gender")) {
                    Text("Male").tag(1)
                    Text("Female").tag(2)
                }
                TextField("Age", int: $age)
                }
                List {
                    Section(header: Text("Health Options")) {
                        ForEach(self.options, id: \.self) { item in
                            MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                                if self.selections.contains(item) {
                                    self.selections.removeAll(where: { $0 == item })
                                }
                                else {
                                    self.selections.append(item)
                                }
                            }
                        }
                    }
                }

                Section {
                Button(action: {self.save.toggle()}) {
                    Text("Save")
                    self.userInfo.user_profile.first_name = firstName
                    self.userInfo.user_profile.last_name = lastName
                    self.userInfo.user_profile.age = age
                    self.userInfo.user_profile.health_options = selections
                }
                }
            }.navigationBarTitle("Preferences")
        }
    }
}
struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView().environmentObject(userSettings())
    }
}
