//
//  UpcomingView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/25/22.
//

import SwiftUI

struct UpcomingView: View {
    let days: Int
    let sub: SubItem
    let currency: String
    
    var body: some View {
        VStack {
            Text(sub.name.capitalized + " (\(sub.amount.formatted(.currency(code: currency))))")
                .font(.title3)
            Text("due \(days == 0 ? "today" : "in \(days) day\(days > 1 ? "s" : "")")")
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color("Tiles"))
        .clipShape(Capsule())
    }
}

struct UpcomingView_Previews: PreviewProvider {
    static var days: Int = 1
    static var sub1 = SubItem(name: "Youtube", amount: 12.0, freq: "monthly", purchaseDate: Date(), category: "Entertainment", rank: 3)
    
    
    static var previews: some View {
        UpcomingView(days: days, sub: sub1, currency: "USD")
            .previewLayout(.sizeThatFits)
    }
}
