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
                // Line Graph
                let monthlySpending = subViewModel.spendingByMonth()
                CardView {
                    if monthlySpending.count < 1 || monthlySpending.allSatisfy({$0 == monthlySpending[0]}){
                        VStack(alignment: .center) {
                            Image(systemName: "exclamationmark.circle").font(.title)
                            Text("No Data.").font(.title)
                            Text("Too few subscriptions.")
                        }
                        .frame(width: 200)
                        .foregroundColor(.secondary)
                    } else {
                        VStack {
                            ChartLabel("Spending History", type: .subTitle, format: "$%.01f")
                            LineChart()
                        }
                    }
                }
                    .data(monthlySpending)
                    .chartStyle(ChartStyle(backgroundColor: Color("Tiles"), foregroundColor: ColorGradient(.blue, .blue)))
                    .frame(height: 200)
                    .shadow(radius: 5)
                    .padding()
                
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
                            ChartLabel("Spending (By Category)", type: .subTitle, format: "$%.01f")
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
                    .frame(height: 400)
                    .shadow(radius: 0.5)
                    .padding()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Label("Streak", systemImage: "flame")
                        Text(String(subViewModel.streak()))
                    }.foregroundColor(.red)
                    
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
