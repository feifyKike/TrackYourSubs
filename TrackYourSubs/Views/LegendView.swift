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
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(subViewModel.categories.enumerated()), id:\.offset) { i, category in
                HStack {
                    PieChart()
                        .data([1])
                        .chartStyle(ChartStyle(backgroundColor: .clear,
                                               foregroundColor: keys[i]))
                        .frame(width: 25, height: 25)
                    Text(category).foregroundColor(.primary)
                }
            }
        }.padding()
    }
}

struct LegendView_Previews: PreviewProvider {
    static var previews: some View {
        let gradients: [ColorGradient] = [ColorGradient(Color("Teal"), Color("Peach")), ColorGradient(Color("Peach"), Color("Red")), ColorGradient(Color("Teal"), Color("Red"))]
        LegendView(keys: gradients)
            .environmentObject(SubViewModel())
    }
}
