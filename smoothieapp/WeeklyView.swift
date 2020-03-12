//
//  WeeklyView.swift
//  smoothieapp
//
//  Created by Simeon Lam on 2/14/20.
//  Copyright © 2020 cs125. All rights reserved.
//
import SwiftUI

struct WeeklyView: View {
    @EnvironmentObject var userInfo : userSettings
    @State var pickerselection = 0
    @State var nutrients : [String] = [
    "Vitamin-A", "Vitamin-B12", "Vitamin-C", "Vitamin-D",
    "Vitamin-E", "Vitamin-K", "Calcium", "Fiber",
    "Iron", "Magnesium", "Potassium", "Protein",
    "Zinc"]
    @State var values : [[CGFloat]] = []
    
    var body: some View {
        ZStack{
            Color(.black).edgesIgnoringSafeArea(.all)
            VStack{
                Text("Nutrients")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    

                Picker(selection: $pickerselection, label: Text("Stats"))
                    {
                        Text("Vitamin-A").tag(0)
                        Text("Vitamin-B12").tag(1)
                        Text("Vitamin-C").tag(2)
                        Text("Vitamin-D").tag(3)
                        
                    }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 10)
                //
                Picker(selection: $pickerselection, label: Text("Stats2"))
                {
                    Text("Vitamin-E").tag(4)
                    Text("Vitamin-K").tag(5)
                    Text("Calcium").tag(6)
                    Text("Fiber").tag(7)
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 10)
                Picker(selection:$pickerselection, label: Text("Stats3"))
                {
                    Text("Iron").tag(8)
                    Text("Magnesium").tag(9)
                    Text("Potassium").tag(10)
                    Text("Protein").tag(11)
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 10)
                Picker(selection: $pickerselection, label: Text("Stats3"))
                {
                    Text("Zinc").tag(12)
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 160)
                //
                HStack(alignment: .center, spacing: 10)
                {
                    ForEach(userInfo.user_profile.weekly[pickerselection], id: \.self){
                        data in
                        
                        BarView(value: data, cornerRadius: CGFloat(integerLiteral: 1*self.pickerselection))
                    }
                }.padding(.top, 24).animation(.default)
                Text(nutrients[pickerselection])
                    .font(.title)
                    .foregroundColor(Color.white)
            }
        }
    }
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .darkGray
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
    }
}

struct BarView: View{

    var value: CGFloat
    var cornerRadius: CGFloat
    
    var body: some View {
        VStack {

            ZStack (alignment: .bottom) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 30, height: 200).foregroundColor(.black)
                RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(gradient: Gradient(colors:[.red, .purple, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 30, height: value).foregroundColor(.green)
                
            }.padding(.bottom, 8)
        }
    }
}

struct WeeklyView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyView()
    }
}

func updateValues(userInfo: userSettings){
    
}
