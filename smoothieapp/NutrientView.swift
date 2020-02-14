//
//  NutrientView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/3/20.
//  Copyright © 2020 cs125. All rights reserved.
//

import SwiftUI

struct NutrientView: View {
    @EnvironmentObject var userInfo : userSettings
    
    var body: some View {
        VStack(spacing: 20){
            HStack(){
                ZStack(){

                    Circle()
                        .trim(from: 0.0, to: 0.5)
                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 12.0, dash: [8]))
                        .frame(width: 200, height: 200)
                        .rotationEffect(Angle(degrees: -180))
                    Circle()
                        .trim(from: 0.0, to: (userInfo.total_values.calcium)/(userInfo.max_values.calcium))
                        .stroke(Color.blue, lineWidth: 12.0)
                        .frame(width: 200, height: 200)
                        .rotationEffect(Angle(degrees: -180))
                }
                
            }
        }
        .navigationBarTitle("Nutrient Levels", displayMode: .inline)
    }
}

struct NutrientView_Previews: PreviewProvider {
    static var previews: some View {
        NutrientView().environmentObject(userSettings())
    }
}
