//
//  SettingsView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/28/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    let version: String = "0.9.9"
    let filter: String
    let order: String
    let budgetSelection: String
    let notificationsAllowed: Bool
    let reminder: Int
    let currency: String
    @State var newCategory: String = ""
    @State var filterOption: String = ""
    @State var orderOption: String = ""
    @State var budgetOption: String = ""
    @State var notificationsStatus: Bool = false
    @State var reminderOption: Int = 0
    @State var currencyCode: String = ""
    
    init(filter: String, order: String, budgetSelection: String, notificationsAllowed: Bool, reminder: Int, currency: String) {
        self.filter = filter
        self.order = order
        self.budgetSelection = budgetSelection
        self.notificationsAllowed = notificationsAllowed
        self.reminder = reminder
        self.currency = currency
        _filterOption = State(initialValue: self.filter)
        _orderOption = State(initialValue: self.order)
        _budgetOption = State(initialValue: self.budgetSelection)
        _notificationsStatus = State(initialValue: self.notificationsAllowed)
        _reminderOption = State(initialValue: self.reminder)
        _currencyCode = State(initialValue: self.currency)
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
            Section(footer: Text("The filter is engaged when a second gear appears in the preferences icon for this page.")) {
                Picker(selection: $filterOption, label: Text("Filter by")) {
                    Text("All").tag("")
                    ForEach(subViewModel.categories, id: \.self) { category in
                        Text("Category: \(category)").tag(category)
                    }
                }
                .onChange(of: filterOption) { _ in
                    subViewModel.setFilter(newFilter: filterOption)
                }
                Picker(selection: $orderOption, label: Text("Order by")) {
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
            Section(header: Text("Currency")) {
                Picker(selection: $currencyCode, label: Text("Currency")) {
                    Label("Dollar", systemImage: "dollarsign").tag("USD")
                    Label("Euro", systemImage: "eurosign").tag("EUR")
                    Label("Yen", systemImage: "yensign").tag("JPY")
                    Label("Sterling", systemImage: "sterlingsign").tag("GBP")
                    Label("Rupee", systemImage: "indianrupeesign").tag("INR")
                }
            }
            .onChange(of: currencyCode) { _ in
                subViewModel.currency = currencyCode
            }
            Section(header: Text("Notifications"), footer: Text("Notifications will be sent out on the indicated day at 7:00AM.")) {
                Toggle("Allow Notifications", isOn: $notificationsStatus)
                    .onChange(of: notificationsStatus) { _ in
                        subViewModel.notifications = notificationsStatus
                        updateNotifications()
                    }
                Stepper(value: $reminderOption, in: 0...7) {
                    Text("Remind \(reminderOption > 0 ? "\(reminderOption < 2 ? "1 day before" : "\(reminderOption) days before")" : "on due date")")
                }
                .disabled(!notificationsStatus)
                .onChange(of: reminderOption) { _ in
                    subViewModel.reminder = reminderOption
                    updateNotifications()
                }
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
    
    func updateNotifications() {
        notificationManager.requestAuthorization()
        
        if subViewModel.notifications {
            notificationManager.scheduleAllNotifications(subs: subViewModel.subscriptions, remindBefore: subViewModel.reminder)
        } else {
            notificationManager.cancelAllNotifications()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var filter: String = "frequencyM"
    static var order: String  = "priceDown"
    static var budget: String = "monthly"
    
    static var previews: some View {
        NavigationView {
            SettingsView(filter: filter, order: order, budgetSelection: budget, notificationsAllowed: false, reminder: 0, currency: "USD")
        }.environmentObject(SubViewModel())
    }
}
