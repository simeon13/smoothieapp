//
//  RecommendationView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI

struct RecommendationView: View {
    @EnvironmentObject var userInfo : userSettings

    var body: some View {
        NavigationView {
            List {
                Section (header: Text("Current Recommendations")){
                    ForEach(userInfo.user_profile.recommendations.indices, id: \.self){i in
                        Text("\(i+1) - \(self.userInfo.user_profile.recommendations[i].name)")
                    }
                }
            }
            .navigationBarTitle("Notifications")
        }
        .navigationBarTitle("Recommendations", displayMode: .inline)
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView().environmentObject(userSettings())
    }
}
