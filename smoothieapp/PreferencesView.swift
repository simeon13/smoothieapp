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
    @State var selection = 1
    @State var name = ""
    @State var allergies = ""
    @State var healthoptions = ""
    @State var age = ""
    @State var save = false
    var body: some View {
        NavigationView {
            Form {
                Section {
                TextField("Your name", text: $name)
                Picker(selection: $selection, label: Text("Gender")) {
                    Text("Male").tag(1)
                    Text("Female").tag(2)
                }
                TextField("Age", text: $age)
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
