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
                            Text("Female").tag(0)
                            Text("Male").tag(1)
                        }
                        
                        // convert age to string
                        Picker("Age", selection: $userInfo.user_profile.age) {
                            ForEach(9..<100) { i in
                                Text(String(i))
                            }
                        }
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
