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
    @State private var showInfo: Bool = false
    let colors = [Color("Teal"), Color("Peach"), Color("Red"), Color("Blue"), Color("DarkBlue")]
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("\(subViewModel.importanceIndex())%")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    Text("Importance Index").font(.headline).foregroundColor(.secondary)
                    Spacer()
                    Button(action: {
                        showInfo.toggle()
                    }, label: {
                        Label("More Info", systemImage: "questionmark.circle").foregroundColor(.accentColor)
                    })
                        .sheet(isPresented: $showInfo) {
                            DefinitionView(term: "👉 Importance Index", definition: "This is metric that determines the overall importance or volume of important subscriptions that you have added. The value is calculated by specified importance by the total that is possible. The greater the % or grade the better.")
                        }
                }
                    .padding()
                    .background(Color("Tiles"))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .shadow(radius: 5)
                    .padding([.leading, .trailing])
                // Pie Chart
                let spending = subViewModel.spendingByCategory()
                let gradients = createGradients()
                CardView {
                    if spending.count < 1 {
                        VStack(alignment: .center) {
                            Image(systemName: "exclamationmark.circle").font(.title)
                            Text("No Data.").font(.title)
                            Text("Add a subscription to see stats.")
                        }
                        .frame(width: 200)
                        .foregroundColor(.secondary)
                    } else {
                        VStack {
                            ChartLabel("Spending", type: .subTitle, format: "$%.01f")
                            PieChart()
                                .padding([.leading, .trailing])
                            LegendView(keys: gradients)
                        }
                        .background(Color("PieChartTile"))
                    }
                }
                    .data(spending)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                           foregroundColor: gradients))
                    .frame(height: 600)
                    .shadow(radius: 0.5)
                    .padding()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("🔥10 months")
                }
            }
        }
        
    }
    
    func createGradients() -> [ColorGradient] {
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
