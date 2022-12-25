//
//  LegendView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/20/22.
//

import SwiftUI
import SwiftUICharts

struct LegendView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    let keys: [ColorGradient]
    let keyCount: Int
    let showCategories: Bool
    
    var body: some View {
        let categories = subViewModel.categories
        VStack(alignment: .leading) {
            ForEach(0..<keyCount, id:\.self) { i in
                let percent = subViewModel.percentage(of: showCategories ? subViewModel.spendingByCategory() : subViewModel.spendingByRank(), pos: i)
                HStack {
                    PieChart()
                        .data([1])
                        .chartStyle(ChartStyle(backgroundColor: .clear,
                                               foregroundColor: keys[i]))
                        .frame(width: 25, height: 25)
                    Text(showCategories ? categories[i] : String(i+1)).foregroundColor(.primary)
                    Text("\(percent == 0 ? "-" : String(percent))%").foregroundColor(.secondary)
                }
            }
        }.padding()
    }
}

struct LegendView_Previews: PreviewProvider {
    static var previews: some View {
        let gradients: [ColorGradient] = [ColorGradient(Color("Teal"), Color("Peach")), ColorGradient(Color("Peach"), Color("Red")), ColorGradient(Color("Teal"), Color("Red"))]
        LegendView(keys: gradients, keyCount: gradients.count, showCategories: true)
            .environmentObject(SubViewModel())
    }
}
