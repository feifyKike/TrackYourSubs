//
//  SubViewModel.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/4/22.
//

import Foundation
import SwiftUI

typealias CategorySums = [(String, Double)]
class SubViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    @Published var subscriptions: [SubItem] = [] {
        didSet {
            saveSub()
        }
    }
    @Published var budget: Double = 0.0 {
        didSet {
            defaults.set(budget, forKey: "budgetKey")
        }
    }
    @Published var categories: [String] = ["Uncategorized"] {
        didSet {
            saveCategories()
        }
    }
    @Published var order: String = "" {
        didSet {
            defaults.set(order, forKey: "orderKey")
        }
    }
    @Published var filter: String = "" {
        didSet {
            defaults.set(filter, forKey: "filterKey")
        }
    }
    @Published var tutorial = true {
        didSet {
            defaults.set(tutorial, forKey: "tutorial")
        }
    }
    @Published var budgetType = "" {
        didSet {
            defaults.set(budgetType, forKey: "budgetTypeKey")
        }
    }
    let threshold: Int = 7
    var combinations: [[SubItem]] = []
    let subsKey: String = "subscription_key"
    
    init() {
        self.tutorial = defaults.bool(forKey: "tutorial")
        self.budget = defaults.double(forKey: "budgetKey")
        self.budgetType = defaults.string(forKey: "budgetTypeKey") ?? "monthly"
        self.categories = defaults.object(forKey: "categoriesKey") as? [String] ?? ["Uncategorized"]
        self.order = defaults.string(forKey: "orderKey") ?? ""
        self.filter = defaults.string(forKey: "filterKey") ?? ""
        getSubs()
    }
    
    // Working with Subscriptions
    func getSubs() {
//        let newSubs = [
//            SubItem(name: "Youtube", amount: 12.0, freq: "monthly", purchaseDate: Date(), category: "Uncategorized", rank: 3),
//            SubItem(name: "Google Domains", amount: 7.0, freq: "yearly", purchaseDate: Date(), category: "Uncategorized", rank: 1)
//        ]
//        subscriptions.append(contentsOf: newSubs)
        guard
            let data = UserDefaults.standard.data(forKey: subsKey),
            let savedItems = try? JSONDecoder().decode([SubItem].self, from: data)
        else { return }
        self.subscriptions = savedItems
    }
    
    func getSub(sub: SubItem) -> SubItem {
        return subscriptions[subscriptions.firstIndex(where: {$0.id == sub.id})!]
    }
    
    func deleteSub(id: String) {
        if let index = subscriptions.firstIndex(where: {$0.id == id}){
            subscriptions.remove(at: index)
        }
    }
    
    func addSub(name: String, amount: Double, freq: String, purchaseDate: Date, category: String, rank: Int) {
        let newSub = SubItem(name: name, amount: amount, freq: freq, purchaseDate: purchaseDate, category: category, rank: rank)
        subscriptions.append(newSub)
    }
    
    func updateSub(sub: SubItem, newName: String, newAmount: Double, newFreq: String, newPurchaseDate: Date, newCat: String, newRank: Int) {
        if let index = subscriptions.firstIndex(where: { $0.id == sub.id}) {
            subscriptions[index] = sub.update(newName: newName, newAmount: newAmount, newFreq: newFreq, newPurchaseDate: newPurchaseDate, newCat: newCat, newRank: newRank)
        }
    }
    
    func saveSub() {
        if let encodeData = try? JSONEncoder().encode(subscriptions) {
            UserDefaults.standard.set(encodeData, forKey: subsKey)
        }
    }
    
    // Filtering & Ordering
    func orderByPrice() {
        // order by price - descending
        subscriptions = subscriptions.sorted().reversed()
    }
    
    func orderByAscending() {
        // order price - ascending
        subscriptions = subscriptions.sorted()
    }
    
    func orderByRankA() {
        subscriptions = subscriptions.sorted {
            return $0.rank < $1.rank
        }
    }
    
    func orderByRankD() {
        subscriptions = subscriptions.sorted {
            return $0.rank > $1.rank
        }
    }
    
    func setOrder(newOrder: String) {
        order = newOrder
    }
    
    func determineOrder() {
        if order == "priceDown" {
            orderByPrice()
        } else if order == "priceUp" {
            orderByAscending()
        } else if order == "rankDown" {
            orderByRankA()
        } else if order == "rankUp" {
            orderByRankD()
        }
    }
    
    func setFilter(newFilter: String) {
        filter = newFilter
    }
    
    func filterSubs() -> [SubItem] {
        if categories.contains(filter) {
            return subscriptions.filter {$0.category == filter}
        }
        return subscriptions
    }
    
    // Budgeting & Other Stats
    func ribbonData() -> [Double] {
        // monthly, yearly
        var data: [Double] = [0.0, 0.0]
        for s in subscriptions {
            if s.freq.lowercased() == "monthly" {
                data[0] += s.amount
                data[1] += s.amount * 12.0
            }
            else if s.freq.lowercased() == "yearly" {
                data[1] += s.amount
                data[0] += s.amount / 12.0
            }
        }
        return data
    }
    
    func setBudget(newBudget: Double) {
        budget = newBudget
    }
    
    func budgetMargin() -> Double {
        var margin = budget - ribbonData()[0]
        if budgetType == "annually" {
            margin = budget - ribbonData()[1]
        }
        return margin
    }
    
    func determineUpcoming() -> [SubItem: Int] {
        var dict: [SubItem: Int] = [:]
        let calendar = Calendar.current
        let currDate = calendar.startOfDay(for: Date.now)
        
        for subscription in subscriptions {
            let pDate = calendar.startOfDay(for: subscription.purchaseDate)
            let delta = calendar.dateComponents([.year, .month, .day], from: pDate, to: currDate)
            let years = delta.year!
            let months = delta.month!
            let days = delta.day!
            
            // some refactoring needed
            if subscription.freq == "monthly" {
                if months > 0 {
                    let daysLeft = days % 30 == 0 ? 0 : (30 - (days % 30))
                    if daysLeft <= threshold {
                        dict[subscription] = daysLeft
                    }
                } else {
                    if 30 - days <= threshold {
                        dict[subscription] = 30 - days
                    }
                }
            } else if subscription.freq == "yearly" {
                if years > 0 {
                    let daysLeft = days % 365 == 0 ? days & 365 : (365 - (days % 365))
                    if daysLeft <= threshold {
                        dict[subscription] = daysLeft
                    }
                } else {
                    if 365 - days <= 7 {
                        dict[subscription] = 365 - days
                    }
                }
            }
        }
        return dict
    }
    
    // Categories
    func removeCategory(categoryIndex: Int) {
        categories.remove(at: categoryIndex)
    }
    
    func addCategory(newCategory: String) {
        categories.append(newCategory)
    }
    
    func saveCategories() {
        defaults.set(categories, forKey: "categoriesKey")
    }
    
    // Suggestion Algorithm
    func sumComb(arr: [SubItem], target: Double, partial: [SubItem]) {
        var sum: Double = 0.0
        for fee in partial {
            sum += fee.amount
        }
        if sum >= target {
            combinations.append(partial)
            return
        }
        for i in 0..<arr.count {
            var remaining: [SubItem] = []
            let val: SubItem = arr[i]
            for j in i+1..<arr.count {
                remaining.append(arr[j])
            }
            var partial_rec: [SubItem] = partial
            partial_rec.append(val)
            sumComb(arr: remaining, target: target, partial: partial_rec)
        }
    }
    
    func save() -> [SubItem] {
        let rData: [Double] = ribbonData()
        var target: Double = 0.0
        let emptyArr: [SubItem] = []
        var arrToUse: [SubItem] = []
        if budgetType == "monthly" {
            target = rData[0] - budget
            arrToUse = subscriptions.filter { $0.freq == "monthly" }
            let addition = subscriptions.filter { $0.freq == "yearly" }.map {
                $0.update(newName: $0.name, newAmount: $0.amount / 12.0, newFreq: $0.freq, newPurchaseDate: $0.purchaseDate, newCat: $0.category, newRank: $0.rank)
            }
            arrToUse += addition
        } else if budgetType == "annually" {
            target = rData[1] - budget
            arrToUse = subscriptions.filter { $0.freq == "yearly" }
            let addition = subscriptions.filter { $0.freq == "monthly" }.map {
                $0.update(newName: $0.name, newAmount: $0.amount * 12.0, newFreq: $0.freq, newPurchaseDate: $0.purchaseDate, newCat: $0.category, newRank: $0.rank)
            }
            arrToUse += addition
        }
        sumComb(arr: arrToUse, target: target, partial: emptyArr)
        
        var min: Double = Double(Int.max)
        var closest: Double = Double(Int.max)
        var minIndex: Int = 0
        
        for i in 0..<combinations.count {
            var curr: Int = 0
            var curr2: Double = 0.0
            for fee in combinations[i] {
                curr += fee.rank
                curr2 += fee.amount
            }
            let average: Double = Double(curr / combinations.count)
            if average <= min && curr2 < closest {
                min = Double(curr)
                closest = curr2
                minIndex = i
            }
        }
        
        return combinations[minIndex]
    }
    
    func remFormatted(subs: [SubItem]) -> String {
        var formattedString = ""
        for i in 0..<subs.count {
            formattedString += subs[i].name
            if i != subs.count - 1 {
                formattedString += ", "
            }
        }
        return formattedString
    }
    
    func acceptSuggestion(toRemove: [SubItem]) {
        for item in toRemove {
            if let index = subscriptions.firstIndex(where: {$0.id == item.id}) {
                subscriptions.remove(at: index)
            }
        }
    }
    
    func extractPrice(priceStr: String) -> String {
        let range = NSRange(location: 0, length: priceStr.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]+(.[0-9]+)?")
        let match = regex.firstMatch(in: priceStr, options: [], range: range)!.range
        let formattedPrice = String(priceStr[priceStr.startIndex..<priceStr.index(priceStr.startIndex, offsetBy: match.upperBound)])

        return formattedPrice
    }
    
    // Stats Page Calculations
    func spendingByCategory() -> CategorySums {
        guard !subscriptions.isEmpty else { return [] }
        
        var categorySums = CategorySums()
        
        for category in categories {
            let matchingSubs = subscriptions.filter {
                $0.category == category
            }.map { $0.amount }
            
           categorySums.append((category, matchingSubs.reduce(0, +)))
        }
        
        return categorySums
    }
    
    func importanceIndex() -> Int {
        let totalImportance = Double(subscriptions.count) * 5.0
        
        if totalImportance == 0 {
            return 0
        }
        
        var calcImportance = 0.0
        for sub in subscriptions {
            calcImportance += Double(sub.rank)
        }
        
        return Int((calcImportance / totalImportance) * 100.0)
    }
    
    // Paying Subscriptions Logic
    func addPayStamp(sub: SubItem) {
        if let index = subscriptions.firstIndex(where: { $0.id == sub.id}) {
            if sub.payStamp.isEmpty || Calendar.current.compare(Date.now, to: sub.payStamp.last ?? Date.now, toGranularity: .day) != .orderedSame {
                subscriptions[index] = sub.update(newName: sub.name, newAmount: sub.amount, newFreq: sub.freq, newPurchaseDate: sub.purchaseDate, newCat: sub.category, newRank: sub.rank, payStamp: sub.payStamp + [Date.now])
            }
        }
    }
    
    func isPayed(sub: SubItem) -> Bool {
        let calendar = Calendar.current
        let currDate = calendar.startOfDay(for: Date.now)
        let lastPay = calendar.startOfDay(for: sub.payStamp.last ?? Date.now)
        let delta = Calendar.current.dateComponents([.year, .month], from: lastPay, to: currDate)
        let empty = sub.payStamp.isEmpty
        
        if !empty && sub.freq == "monthly" && delta.month! < 1 {
            return true
        } else if !empty && sub.freq == "yearly" && delta.year! < 1 {
            return true
        }
       
        return false
    }
    
    func bellBadge() -> Bool {
        if determineUpcoming().filter({ $0.value < 1}).isEmpty {
            return false
        }
        
        var unpaid = false
        
        for subscription in subscriptions {
            if !isPayed(sub: subscription) {
                unpaid = true
                break
            }
        }
        
        return unpaid
    }
    
    func suggestionBadge() -> Bool {
        if subscriptions.isEmpty {
            return false
        }
        let totalToUse = budgetType == "monthly" ? ribbonData()[0] : ribbonData()[1]
        
        return totalToUse >= budget * 2 || totalToUse > budget
    }
}
