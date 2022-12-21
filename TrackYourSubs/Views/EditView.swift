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
            Text("🗓 Next Payment: \(nextPay())")
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
        presentationMode.wrappedValue.dismiss()
    }
    
    func nextPay() -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let currDate = calendar.startOfDay(for: Date.now)
        
        let pDate = calendar.startOfDay(for: sub.purchaseDate)
        let delta = calendar.dateComponents([.year, .month, .day], from: pDate, to: currDate)
        let years = delta.year!
        let months = delta.month!
        let days = delta.day!
        
        var toAdd = DateComponents()
//        if sub.freq == "monthly" && days % 30 <= 7 && months > 0 {
//            toAdd.day = days % 30
//            let upcoming = calendar.date(byAdding: toAdd, to: currDate)!
//
//            return formatter.string(from: upcoming)
//
//        } else if sub.freq == "yearly" && days % 365 <= 7 && years > 0 {
//            toAdd.day = days % 365
//            let upcoming = calendar.date(byAdding: toAdd, to: currDate)!
//
//            return formatter.string(from: upcoming)
//        }
        if sub.freq == "monthly" {
            if months > 0 {
                toAdd.day = days % 30 == 0 ? days % 30 : (30 - (days % 30))
                let upcoming = calendar.date(byAdding: toAdd, to: currDate)!
                
                return formatter.string(from: upcoming)
            } else {
                if 30 - days <= 7 {
                    toAdd.day = 30 - days
                    let upcoming = calendar.date(byAdding: toAdd, to: currDate)!
                    
                    return formatter.string(from: upcoming)
                }
            }
        } else if sub.freq == "yearly" {
            if years > 0 {
                toAdd.day = days % 365 == 0 ? days & 365 : (365 - (days % 365))
                let upcoming = calendar.date(byAdding: toAdd, to: currDate)!
                
                return formatter.string(from: upcoming)
            } else {
                if 365 - days <= 7 {
                    toAdd.day = 365 - days
                    let upcoming = calendar.date(byAdding: toAdd, to: currDate)!
                    
                    return formatter.string(from: upcoming)
                }
            }
        }
        toAdd.day = 30
        return formatter.string(from: calendar.date(byAdding: toAdd, to: currDate)!)
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
    }
}
