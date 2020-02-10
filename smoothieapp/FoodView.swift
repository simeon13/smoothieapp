//
//  FoodView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct FoodView: View {
    @ObservedObject var recipes = observer()
    
    var body: some View {
        NavigationView {
            List {
                // Recipes
                Section(header: Text("Recipes")) {
                    ForEach(recipes.data){i in
                        Text(i.name)
                    }
                }
                
                // Foods
            }
            .navigationBarTitle("Food")
            .listStyle(GroupedListStyle())
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}

class observer : ObservableObject {
    @Published var data = [Recipe]()
    
    init(){
        let ref = Database.database().reference(withPath: "recipes")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let url = value?["url"] as? String ?? ""
                let info = Recipe(id: name, name: name, url: url)
                print(name)
                self.data.append(info)
            }
        })
//            let value = snapshot.value as? NSDictionary
//            let name = value?["name"] as? String ?? ""
//            let url = value?["url"] as? String ?? ""
//            let info = Recipe(id: "hi", name: name, url: url)
//            self.data.append(info)
//           ...
//          }) { (error) in
//            print(error.localizedDescription)
//        }
    }
}

struct Recipe : Identifiable {
    var id : String
    var name : String
    var url : String
}
