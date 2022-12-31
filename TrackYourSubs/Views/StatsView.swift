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
    @State private var showCategories: Bool = true
    let colors = [Color("Teal"), Color("Peach"), Color("Red"), Color("Blue"), Color("DarkBlue")]
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Pie Chart
                let categorySpending = subViewModel.spendingByCategory()
                let rankSpending = subViewModel.spendingByRank()
                let data = showCategories ? categorySpending : rankSpending
                let keyCount = showCategories ? subViewModel.categories.count : 5
                let gradients = createGradients(num: keyCount)
                HStack {
                    Spacer()
                    Picker(selection: $showCategories, label: Text("Show")) {
                        Text("Categories").tag(true)
                        Text("Importance").tag(false)
                    }
                }.padding([.leading, .trailing])
                
                CardView {
                    if categorySpending.count < 1 {
                        VStack(alignment: .center) {
                            Image(systemName: "exclamationmark.circle").font(.title)
                            Text("No Data.").font(.title)
                            Text("Add a subscription to see stats.")
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .background(Color("PieChartTile"))
                        .foregroundColor(.secondary)
                    } else {
                        VStack {
                            ChartLabel("Spending", type: .subTitle, format: getCurrencySymbol(forCurrencyCode: subViewModel.currency) + "%.01f")
                            PieChart()
                                .padding([.leading, .trailing])
                            LegendView(keys: gradients, keyCount: keyCount, showCategories: showCategories)
                        }
                        .background(Color("PieChartTile"))
                    }
                }
                    .data(data)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                           foregroundColor: gradients))
                    .frame(height: 500)
                    .shadow(radius: 0.5)
                    .padding([.leading, .trailing])
                
                // Bar Graph
                let monthlySpending = subViewModel.spendingByMonth()
                CardView {
                    if monthlySpending.count < 1 {
                        VStack(alignment: .center) {
                            Image(systemName: "exclamationmark.circle").font(.title)
                            Text("No Data.").font(.title)
                            Text("No payments made yet.")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color("PieChartTile"))
                        .foregroundColor(.secondary)
                    } else {
                        VStack {
                            ChartLabel("Payment History", type: .subTitle, format: getCurrencySymbol(forCurrencyCode: subViewModel.currency) + "%.01f")
                            BarChart().padding([.leading, .trailing])
                            HStack {
                                let months = subViewModel.uniqueMonths()
                                ForEach(months, id:\.self) { month in
                                    Text(month)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding([.leading, .trailing, .bottom])
                                }
                            }
                        }
                        .background(Color("PieChartTile"))
                    }
                }
                    .data(monthlySpending)
                    .chartStyle(ChartStyle(backgroundColor: .white, foregroundColor: ColorGradient(.blue, .cyan)))
                    .frame(height: 200)
                    .shadow(radius: 0.5)
                    .padding([.leading, .trailing, .top])
                Text("☝️ Note: the x-axis labels are shown in the format M/Y.")
                    .foregroundColor(.secondary)
                    .padding([.leading, .trailing])
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
                        Text("\(subViewModel.streak()) M")
                    }.foregroundColor(.red)
                    
                }
            }
        }
        
    }
    
    func createGradients(num: Int) -> [ColorGradient] {
        var gradients: [ColorGradient] = []
//        let num = showCategories ? subViewModel.categories.count : 5
        
        var i = 0
        while i < num {
            let gradient = ColorGradient(colors[Int.random(in: 0..<colors.count)], colors[Int.random(in: 0..<colors.count)])
            if !gradients.contains(gradient) {
                gradients.append(gradient)
                i += 1
            }
        }


        return gradients
    }
    
    func getCurrencySymbol(forCurrencyCode code: String) -> String {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) ?? "USD"
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(SubViewModel())
    }
}
