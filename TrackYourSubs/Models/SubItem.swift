//
//  SubItem.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/4/22.
//

import Foundation

struct SubItem: Identifiable, Comparable, Codable, Hashable {
    let id: String
    let name: String
    let amount: Double
    let freq: String
    let purchaseDate: Date
    let category: String
    let rank: Int
    
    init(id: String = UUID().uuidString, name: String, amount: Double, freq: String, purchaseDate: Date, category: String, rank: Int) {
        self.id = id
        self.name = name
        self.amount = amount
        self.freq = freq
        self.purchaseDate = purchaseDate
        self.category = category
        self.rank = rank
    }
    
    func update(newName: String, newAmount: Double, newFreq: String, newPurchaseDate: Date, newCat: String, newRank: Int) -> SubItem {
        return SubItem(id: id, name: newName, amount: newAmount, freq: newFreq, purchaseDate: newPurchaseDate, category: newCat, rank: newRank)
    }
    
    static func <(lhs: SubItem, rhs: SubItem) -> Bool {
        lhs.amount < rhs.amount
    }
}
