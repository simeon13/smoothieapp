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
                Spacer()
                .frame(height: 50.0)
                
                Group {
                    progressBar(total: $userInfo.total_values.calcium, max: $userInfo.max_values.calcium, name: $calcium, unit: $userInfo.nutrient_units.calcium)
                    
                    progressBar(total: $userInfo.total_values.fiber, max: $userInfo.max_values.fiber, name: $fiber, unit: $userInfo.nutrient_units.fiber)

                    progressBar(total: $userInfo.total_values.iron, max: $userInfo.max_values.iron, name: $iron, unit: $userInfo.nutrient_units.iron)

                    progressBar(total: $userInfo.total_values.magnesium, max: $userInfo.max_values.magnesium, name: $magnesium, unit: $userInfo.nutrient_units.magnesium)

                    progressBar(total: $userInfo.total_values.potassium, max: $userInfo.max_values.potassium, name: $potassium, unit: $userInfo.nutrient_units.potassium)

                    progressBar(total: $userInfo.total_values.protein, max: $userInfo.max_values.protein, name: $protein, unit: $userInfo.nutrient_units.protein)
                    
                    progressBar(total: $userInfo.total_values.zinc, max: $userInfo.max_values.zinc, name: $zinc, unit: $userInfo.nutrient_units.zinc)
                }

                Group {
                    progressBar(total: $userInfo.total_values.vitaminA, max: $userInfo.max_values.vitaminA, name: $vitaminA, unit: $userInfo.nutrient_units.vitaminA)

                    progressBar(total: $userInfo.total_values.vitaminB12, max: $userInfo.max_values.vitaminB12, name: $vitaminB12, unit: $userInfo.nutrient_units.vitaminB12)

                    progressBar(total: $userInfo.total_values.vitaminC, max: $userInfo.max_values.vitaminC, name: $vitaminC, unit: $userInfo.nutrient_units.vitaminC)

                    progressBar(total: $userInfo.total_values.vitaminD, max: $userInfo.max_values.vitaminD, name: $vitaminD, unit: $userInfo.nutrient_units.vitaminD)

                    progressBar(total: $userInfo.total_values.vitaminE, max: $userInfo.max_values.vitaminE, name: $vitaminE, unit: $userInfo.nutrient_units.vitaminE)
        
                    progressBar(total: $userInfo.total_values.vitaminK, max: $userInfo.max_values.vitaminK, name: $vitaminK, unit: $userInfo.nutrient_units.vitaminK)
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
    @Binding var unit : String
    
    var body : some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 10)
                    .padding(.top, 10.0)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.blue)
                    .frame(width: min(300*(total/max), 300), height: 10)
                    .padding(.top, 10.0)

            }
            HStack {
                Text("\(name):")
                    .padding(.leading, 35.0)
                    .padding(.bottom, 15.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(format(total: total, max: max, unit: unit))
                    .padding(.trailing, 35.0)
                    .padding(.bottom, 15.0)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
        }
    }
}

func format(total: CGFloat, max: CGFloat, unit: String) -> String{
    let formatted = String(format: "%.2f / %.f \(unit)", total, max)
    return formatted
}
