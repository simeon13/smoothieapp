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
    @State var calcium = "Calcium"
    @State var fiber = "Fiber"
    @State var iron = "Iron"
    @State var magnesium = "Magnesium"
    @State var potassium = "Potassium"
    @State var protein = "Protein"
    @State var vitaminA = "Vitamin A"
    @State var vitaminB12 = "Vitamin B12"
    @State var vitaminC = "Vitamin C"
    @State var vitaminD = "Vitamin D"
    @State var vitaminE = "Vitamin E"
    @State var vitaminK = "Vitamin K"
    @State var zinc = "Zinc"
    
    var body: some View {
        ScrollView{
            VStack{
                Group {
                    progressBar(total: $userInfo.total_values.calcium, max: $userInfo.max_values.calcium, name: $calcium)
                    
                    progressBar(total: $userInfo.total_values.fiber, max: $userInfo.max_values.fiber, name: $fiber)

                    progressBar(total: $userInfo.total_values.iron, max: $userInfo.max_values.iron, name: $iron)

                    progressBar(total: $userInfo.total_values.magnesium, max: $userInfo.max_values.magnesium, name: $magnesium)

                    progressBar(total: $userInfo.total_values.potassium, max: $userInfo.max_values.potassium, name: $potassium)

                    progressBar(total: $userInfo.total_values.protein, max: $userInfo.max_values.protein, name: $protein)
                    
                    progressBar(total: $userInfo.total_values.zinc, max: $userInfo.max_values.zinc, name: $zinc)
                }

                Group {
                    progressBar(total: $userInfo.total_values.vitaminA, max: $userInfo.max_values.vitaminA, name: $vitaminA)

                    progressBar(total: $userInfo.total_values.vitaminB12, max: $userInfo.max_values.vitaminB12, name: $vitaminB12)

                    progressBar(total: $userInfo.total_values.vitaminC, max: $userInfo.max_values.vitaminC, name: $vitaminC)

                    progressBar(total: $userInfo.total_values.vitaminD, max: $userInfo.max_values.vitaminD, name: $vitaminD)

                    progressBar(total: $userInfo.total_values.vitaminE, max: $userInfo.max_values.vitaminE, name: $vitaminE)
        
                    progressBar(total: $userInfo.total_values.vitaminK, max: $userInfo.max_values.vitaminK, name: $vitaminK)
                }
            }
            .navigationBarTitle("Nutrient Levels", displayMode: .inline)
        }
    }
}

struct NutrientView_Previews: PreviewProvider {
    static var previews: some View {
        NutrientView().environmentObject(userSettings())
    }
}

struct progressBar : View {
    @Binding var total : CGFloat
    @Binding var max : CGFloat
    @Binding var name : String
    
    var body : some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 10)
                    .padding(.top, 10.0)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.blue)
                    .frame(width: 300*(total/max), height: 10)
                    .padding(.top, 10.0)

            }
            Text("\(name): \(total) / \(max)")
                .padding(.leading, 35.0)
                .padding(.bottom, 15.0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
