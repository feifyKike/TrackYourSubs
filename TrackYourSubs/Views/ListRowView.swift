//
//  ListRowView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/4/22.
//

import SwiftUI

struct ListRowView: View {
    let sub: SubItem
    let currency: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(sub.name).font(.title3).fontWeight(.semibold)
                Text(sub.freq.capitalized).foregroundColor(.secondary)
            }
            Spacer()
            Text(sub.amount.formatted(.currency(code: currency))).font(.title3)
            Label("", systemImage: "chevron.right.circle").foregroundColor(.accentColor)
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var sub1 = SubItem(name: "Youtube", amount: 12.0, freq: "monthly", purchaseDate: Date(), category: "Entertainment", rank: 3)
    
    static var previews: some View {
        ListRowView(sub: sub1, currency: "USD")
            .previewLayout(.sizeThatFits)
    }
}
