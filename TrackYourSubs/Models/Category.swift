//
//  Category.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/28/22.
//

import Foundation

struct Category: Identifiable {
    let id: String
    let name: String
    
    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
    
    func update(newName: String) -> Category {
        return Category(id: id, name: newName)
    }
}
