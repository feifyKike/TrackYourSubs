//
//  StatsView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/14/22.
//

import SwiftUI
import SwiftUICharts

struct StatsView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    let colors = [Color("Teal"), Color("Peach"), Color("Red"), Color("Blue"), Color("DarkBlue")]
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    
    var body: some View {
        NavigationView {
            ScrollView {
                // Pie Chart
                let spending = subViewModel.spendingByCategory()
                let gradients = distributeGradients()
                CardView {
                    VStack {
                        ChartLabel("Spending", type: .subTitle, format: "$%.01f")
                        PieChart()
                            .padding([.leading, .trailing])
                        LegendView(keys: gradients)
                    }
                    .background(Color("Tiles"))
                }
                    .data(spending)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                           foregroundColor: gradients))
                    .frame(height: 600)
                    .shadow(radius: 5)
                    .padding()
                Spacer()

//                CardView {
//                    ChartLabel("Spending", type: .subTitle, format: "$%.01f")
//                    BarChart()
//                }
//                    .data(spending)
//                    .chartStyle(ChartStyle(backgroundColor: Color("Tiles"), foregroundColor: ColorGradient(.blue, .purple)))
//                    .frame(height: 200)
//                    .shadow(radius: 5)
//                    .padding()
//                Spacer()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("🔥")
                }
            }
        }
        
    }
    
    func distributeGradients() -> [ColorGradient] {
        var gradients: [ColorGradient] = []
        
        var i = 0
        while i < subViewModel.categories.count {
            let gradient = ColorGradient(colors[Int.random(in: 0..<colors.count)], colors[Int.random(in: 0..<colors.count)])
            if !gradients.contains(gradient) {
                gradients.append(gradient)
                i += 1
            }
        }


        return gradients
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(SubViewModel())
    }
}
