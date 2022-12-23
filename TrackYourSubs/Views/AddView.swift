//
//  AddView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/4/22.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var subViewModel: SubViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    @State var subName: String = ""
    @State var subAmount: String = ""
    @State var subFreq: String = ""
    @State var subPurchaseDate = Date()
    @State var subCategory: String = "Uncategorized"
    @State var subRank: Int = 1
    @State var priceOptions: [String] = []
    @State private var showAlert = false
    @State private var newCategory = ""
    let limit = 5
    
    var body: some View {
        Form {
            Section(footer: Text("Press search to retrieve results. Press and hold to view.")) {
                HStack {
                    TextField("Name", text: $subName)
                    Menu("search") {
                        ForEach(priceOptions, id: \.self) { option in
                            Button(option, action: {
                                execOption(priceInput: option)
                            })
                        }
                    } primaryAction: {
                        autofillExecute()
                    }
                    .disabled(subName.isEmpty || subName.count < 3)
                }
            }
            TextField("Cost", text: $subAmount).keyboardType(.decimalPad) // display amount
            Picker(selection: $subFreq, label: Text("Payment Frequency")) {
                Text("Yearly").tag("yearly")
                Text("Monthly").tag("monthly")
            }.pickerStyle(.segmented)
            DatePicker("Purchase Date", selection: $subPurchaseDate, displayedComponents: [.date])
            
            Picker(selection: $subCategory, label: Text("Choose Category")) {
                ForEach(subViewModel.categories, id: \.self) { c in
                    Text(c).tag(c)
                }
            }
            // level of importance 1-5
            Stepper(value: $subRank, in: 1...5) {
                Text("Importance | \(subRank) ")
            }
            Button(action: addButtonPressed, label: {Text("Add")}).disabled(subName.isEmpty || subAmount.isEmpty || subFreq.isEmpty)
        }
        .navigationTitle("Add a Subscription")
        .alert("Connection Error", isPresented: $showAlert) {
            Button("dismiss", role: .cancel) {}
        } message: {
            Text("There is a poor network connection.")
        }
        
    }
    
    func addButtonPressed() {
        if subViewModel.tutorial {
            subViewModel.tutorial = false
        }
        
        subViewModel.addSub(name: subName, amount: Double(subAmount) ?? 0.0, freq: subFreq, purchaseDate: subPurchaseDate, category: subCategory, rank: subRank)
        
        subViewModel.determineOrder()
        
        if subViewModel.notifications {
            notificationManager.scheduleNofitication(id: subViewModel.subscriptions.first(where: {$0.name == subName})?.id ?? UUID().uuidString,
                                                     title: subName,
                                                     body: "The following subscription is due \(subViewModel.reminder > 0 ? "\(subViewModel.reminder == 1 ? "tomorrow" : "\(subViewModel.reminder) days")" : "today").",
                                                     date: notificationManager.nextPay(purchaseDate: subPurchaseDate, freq: subFreq),
                                                     remindBefore: subViewModel.reminder)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func autofillExecute() {
        // to be implemented
        let url: String = "https://www.google.com/search?q=\(subName.replacingOccurrences(of: " ", with: "+"))+help+center+price"
        var content: NSString = ""
        let task = URLSession.shared.dataTask(with: URL(string: url)!) {
            (data, response, error) -> Void in
            if error == nil {
                content = (NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString?)!
                
                // determine price / frequency
                extractData(content: content as String)
            
                print("Successful!")
            } else {
                print("Unsuccessful!")
                showAlert = true
            }
        }
        task.resume()
    }
    
    func extractData(content: String) {
        // Add all unique prices to list and display (order the prices from least to greatest; limit to top 10)
        let cleanedData = content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        for (i, char) in cleanedData.enumerated() {
            if char == "$" {
                let dollarIndex = cleanedData.index(cleanedData.startIndex, offsetBy: i)
                let tagPrice = cleanedData[dollarIndex..<cleanedData.index(dollarIndex, offsetBy: 15)]
                var price = String(subViewModel.extractPrice(priceStr: String(tagPrice)))
                
                if tagPrice.contains("/y") || tagPrice.contains("/Y") || tagPrice.contains("year") {
                    price += " yearly"
                } else {
                    price += " monthly"
                }
            
                if !priceOptions.contains(price) {
                    priceOptions.append(price)
                }
            }
        }
        
    }
    
    func execOption(priceInput: String) {
        let priceComponents: [String] = priceInput.components(separatedBy: " ")
        subAmount = String(priceComponents[0].dropFirst())
        subFreq = priceComponents[1]
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView()
        }.environmentObject(SubViewModel())
    }
}
