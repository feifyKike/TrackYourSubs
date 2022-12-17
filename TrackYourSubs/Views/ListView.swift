//
//  ListView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/4/22.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    @State private var action: Bool = false
    @State private var firstAction: Bool = false
    
    init() {
        // Remove any spacing between list
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    var body: some View {
        if !subViewModel.tutorial {
            VStack {
                // Budget Section
                NavigationLink(destination: EditBudgetView(), isActive: $action) {
                    EmptyView()
                }
                VStack {
                    let margin = subViewModel.budgetMargin()
                    HStack {
                        if margin > 0 {
                            Image(systemName: "arrow.up").foregroundColor(.green)
                        } else {
                            Image(systemName: "arrow.down").foregroundColor(.red)
                        }
                        HStack(spacing: 0) {
                            Text("Budget: $\(subViewModel.budget, specifier: "%.2f")")
                                .font(.title)
                            Text("\(subViewModel.budgetType == "monthly" ? "/m" : "/yr")")
                                .foregroundColor(.secondary)
                
                        }
                        Spacer()
                        Text("Edit")
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                self.action.toggle()
                        }
                    }
                    HStack {
                        let indicator = margin > 0 ? "remaining" : "over"
                        Text("$\(abs(margin), specifier: "%.2f") \(indicator)").foregroundColor(.secondary)
                        Spacer()
                    }
                }
                    .padding()
                    .background(Color("Tiles"))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .shadow(radius: 5)
                    .padding([.leading, .trailing])
                
                // Upcoming Payments - all within a week
                let upcomingDict = subViewModel.determineUpcoming()
                if !upcomingDict.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(upcomingDict.sorted { return $0.value < $1.value }, id: \.key) { key, value in
                                UpcomingView(days: value, sub: key)
                            }
                        }
                    }.padding().shadow(radius: 5)
                }
                
                // Subscriptions
                if subViewModel.filterSubs().isEmpty {
                    Text("No Subscriptions for this filter.")
                        .foregroundColor(.secondary)
                        .padding()
                } else if !subViewModel.subscriptions.isEmpty {
                    ListHeaderView()
                    VStack {
                        ForEach(Array(subViewModel.filterSubs().enumerated()), id:\.offset) { i, sub in
                            NavigationLink(destination: EditView(sub: sub)) {
                                ListRowView(sub: sub)
                            }.foregroundColor(.primary)
                            if (i != subViewModel.filterSubs().count - 1) {
                                Divider().frame(height: 0.5).overlay(Color.secondary)
                            }
                        }
                    }
                        .padding()
                        .background(Color("Tiles"))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(radius: 5)
                        .padding([.trailing, .leading])
                } else {
                    Text("No subscriptions yet. Press + in the top right corner to add one.")
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
            }
            .navigationTitle("Your Subscriptions")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView(filter: subViewModel.filter, order: subViewModel.order, budgetSelection: subViewModel.budgetType), label: {
                        Label("Preferences", systemImage: "gearshape")
                    })
                    Menu {
                        SuggestionView()
                    }
                    label: {
                        Label("Suggestion", systemImage: "lightbulb")
                            .foregroundColor(Color.accentColor)
                    }
                    
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Label("Suggestion", systemImage: "bell").foregroundColor(Color.accentColor)
                    NavigationLink(destination: AddView(), label: {
                        Label("Add", systemImage: "plus.circle")
                    })
                    
                }
            }
        } else {
            // Tutorial
            VStack {
                NavigationLink(destination: AddView(), isActive: $firstAction) {
                    EmptyView()
                }
                Text("To a place where you can manage subscriptions, lower your bills, and stay on top of your financial spending. With this simple to use app you will not want to go back to making spreadsheets.").padding()
                Button("Get Started", action: {
                    self.firstAction.toggle()
                })
                    .buttonStyle(.borderedProminent)
                    .font(.title3)
                Spacer()
            }
            .navigationTitle("🎉 Welcome!")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
        .preferredColorScheme(.dark)
        .environmentObject(SubViewModel())
        
    }
}
