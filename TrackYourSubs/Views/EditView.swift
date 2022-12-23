//
//  EditView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/8/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var subViewModel: SubViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    let sub: SubItem
    @State var subName: String
    @State var subAmount: String
    @State var subFreq: String
    @State var subPurchaseDate = Date()
    @State var subCategory: String
    @State var subRank: Int
    
    init(sub: SubItem) {
        self.sub = sub
        _subName = State(initialValue: self.sub.name.capitalized)
        _subAmount = State(initialValue: String(self.sub.amount))
        _subFreq = State(initialValue: self.sub.freq)
        _subPurchaseDate = State(initialValue: self.sub.purchaseDate)
        _subCategory = State(initialValue: self.sub.category)
        _subRank = State(initialValue: self.sub.rank)
    }
    
    var body: some View {
        Form {
            TextField(sub.name, text: $subName)
            TextField(String(sub.amount), text: $subAmount).keyboardType(.decimalPad) // display amount
            Picker(selection: $subFreq, label: Text("Payment Frequency")) {
                Text("Yearly").tag("yearly")
                Text("Monthly").tag("monthly")
            }.pickerStyle(.segmented)
            DatePicker("Purchase Date", selection: $subPurchaseDate, displayedComponents: [.date])
            Text("🗓 Next Payment: \(dateToString(date: notificationManager.nextPay(purchaseDate: sub.purchaseDate, freq: sub.freq)))")
            Picker(selection: $subCategory, label: Text("Category")) {
                ForEach(subViewModel.categories, id: \.self) { c in
                    Text(c).tag(c)
                }
            }
            // level of importance 1-5
            Stepper(value: $subRank, in: 1...5) {
                Text("Importance | \(subRank) ")
            }
            Button(action: saveButtonPressed, label: {Text("Save")}).disabled(subName.isEmpty || subAmount.isEmpty || subFreq.isEmpty)
        }
        .navigationTitle("Edit \(sub.name.capitalized)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: deleteSub, label: {
                    Label("Remove", systemImage: "minus.circle").foregroundColor(.red)
                })
            }
        }
    }
    
    func saveButtonPressed() {
        subViewModel.updateSub(sub: sub, newName: subName, newAmount: Double(subAmount) ?? 0.0, newFreq: subFreq, newPurchaseDate: subPurchaseDate, newCat: subCategory, newRank: subRank)
        
        subViewModel.determineOrder()
        
        notificationManager.cancelNotification(id: sub.id)
        
        if subViewModel.notifications {
            notificationManager.scheduleNofitication(id: sub.id, title: subName,
                                                     body: "The following subscription is due \(subViewModel.reminder > 0 ? "\(subViewModel.reminder == 1 ? "tomorrow" : "\(subViewModel.reminder) days")" : "today").",
                                                     date: notificationManager.nextPay(purchaseDate: subPurchaseDate, freq: subFreq),
                                                     remindBefore: subViewModel.reminder)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: date)
    }
    
    func deleteSub() {
        subViewModel.deleteSub(id: sub.id)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditView_Previews: PreviewProvider {
    static var sub1 = SubItem(name: "Youtube", amount: 12.0, freq: "monthly", purchaseDate: Date(), category: "Entertainment", rank: 3)
    
    static var previews: some View {
        NavigationView {
            EditView(sub: sub1)
        }
        .environmentObject(SubViewModel())
        .environmentObject(NotificationManager())
    }
}
