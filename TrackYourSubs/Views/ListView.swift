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
    @State private var showNotifications: Bool = false
    @State private var showSuggestion: Bool = false
    
    init() {
        // Remove any spacing between list
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Budget Section
                NavigationLink(destination: EditBudgetView(), isActive: $action) {
                    EmptyView()
                }
                VStack {
                    let margin = subViewModel.budgetMargin()
                    HStack {
                        if margin > 0 {
                            Image(systemName: "arrow.up").foregroundColor(.green)
                        } else if margin < 0 {
                            Image(systemName: "arrow.down").foregroundColor(.red)
                        } else {
                            Image(systemName: "minus").foregroundColor(.yellow)
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
                if subViewModel.subscriptions.isEmpty {
                    Text("No subscriptions yet. Press + in the top right corner to add one.")
                        .foregroundColor(.gray)
                        .padding()
                } else if subViewModel.filterSubs().isEmpty {
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
                }
                Spacer()
            }
                .navigationTitle("Your Subscriptions")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        // Preferences
                        NavigationLink(destination: SettingsView(filter: subViewModel.filter, order: subViewModel.order, budgetSelection: subViewModel.budgetType), label: {
                            Label("Preferences", systemImage: "gearshape")
                        })
                        // Suggestions
                        Button(action: {
                            showSuggestion.toggle()
                        }, label: {
                            if subViewModel.suggestionBadge() {
                                Label("Suggestion", systemImage: "lightbulb.fill").foregroundColor(Color.accentColor)
                            } else {
                                Label("Suggestion", systemImage: "lightbulb").foregroundColor(Color.accentColor)
                            }
                        })
                        .sheet(isPresented: $showSuggestion) {
                            SuggestionView()
                        }
                        
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // Notification Center
                        Button(action: {
                            showNotifications.toggle()
                        }, label: {
                            if subViewModel.bellBadge() {
                                Label("Notifications", systemImage: "bell.badge")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.red, Color.accentColor)
                            } else {
                                Label("Notifications", systemImage: "bell").foregroundColor(Color.accentColor)
                            }
                        })
                        .sheet(isPresented: $showNotifications) {
                            NotificationView()
                        }
                        // Add
                        NavigationLink(destination: AddView(), label: {
                            Label("Add", systemImage: "plus.circle")
                        })
                        
                    }
                }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
        .environmentObject(SubViewModel())
        
    }
}
