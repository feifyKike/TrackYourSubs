//
//  SettingsView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/28/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    let version: String = "1.0.0"
    let filter: String
    let order: String
    let budgetSelection: String
    @State var newCategory: String = ""
    @State var filterOption: String = ""
    @State var orderOption: String = ""
    @State var budgetOption: String = ""
    @State var notificationsAllowed: Bool = false
    
    init(filter: String, order: String, budgetSelection: String) {
        self.filter = filter
        self.order = order
        self.budgetSelection = budgetSelection
        _filterOption = State(initialValue: self.filter)
        _orderOption = State(initialValue: self.order)
        _budgetOption = State(initialValue: self.budgetSelection)
    }
    
    var body: some View {
        Form() {
            Section(header: Text("Categories")) {
                ForEach(subViewModel.categories, id: \.self) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        if category != "Uncategorized" {
                            Image(systemName: "trash").foregroundColor(.red)
                                .onTapGesture {
                                    removeCatButtonPressed(category: category)
                                }
                        }
                    }
                }
                HStack {
                    TextField("New Category", text: $newCategory)
                    Button(action: addCatButtonPressed, label: {Text("Add")})
                        .disabled(newCategory.isEmpty)
                }
            }
            Section() {
                Picker(selection: $filterOption, label: Text("Filter by:")) {
                    Text("All").tag("")
                    ForEach(subViewModel.categories, id: \.self) { category in
                        Text("Category: \(category)").tag(category)
                    }
                }
                .onChange(of: filterOption) { _ in
                    subViewModel.setFilter(newFilter: filterOption)
                }
                Picker(selection: $orderOption, label: Text("Order by:")) {
                    Text("Price: descending").tag("priceDown")
                    Text("Price: ascending").tag("priceUp")
                    Text("Rank: descending").tag("rankDown")
                    Text("Rank: ascending").tag("rankUp")
                }.onChange(of: orderOption) { _ in
                    subViewModel.setOrder(newOrder: orderOption)
                    subViewModel.determineOrder()
                }
            }
            Section(header: Text("Budgeting")) {
                Picker(selection: $budgetOption, label: Text("Choose Budget Type: ")) {
                    Text("Monthly").tag("monthly")
                    Text("Annually").tag("annually")
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: budgetOption) { _ in
                subViewModel.budgetType = budgetOption
            }
            Section(header: Text("Notifications"), footer: Text("A notification will be sent out the day of the due date for each subscription.")) {
                Toggle("Allow Notifications", isOn: $notificationsAllowed)
            }
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(version)
                }
            }
        }
        .navigationTitle("Preferences")
    }
    
    func removeCatButtonPressed(category: String) {
        let index = subViewModel.categories.firstIndex(where: {$0 == category})!
        subViewModel.removeCategory(categoryIndex: index)
        
        for s in subViewModel.subscriptions {
            if s.category == category {
                subViewModel.updateSub(sub: s, newName: s.name, newAmount: s.amount, newFreq: s.freq, newPurchaseDate: s.purchaseDate, newCat: "Uncategorized", newRank: s.rank)
            }
        }
    }
    
    func addCatButtonPressed() {
        subViewModel.addCategory(newCategory: newCategory)
        newCategory = ""
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var filter: String = "frequencyM"
    static var order: String  = "priceDown"
    static var budget: String = "monthly"
    
    static var previews: some View {
        NavigationView {
            SettingsView(filter: filter, order: order, budgetSelection: budget)
        }.environmentObject(SubViewModel())
    }
}
