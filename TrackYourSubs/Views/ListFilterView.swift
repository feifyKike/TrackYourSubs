//
//  ListFilterView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/11/22.
//

import SwiftUI

struct ListFilterView: View {
    @State var budgetOption: String = ""
    var body: some View {
        HStack {
            Picker(selection: $budgetOption, label: Text("Choose Budget Type: ")) {
                Text("Monthly").tag("monthly")
                Text("Annually").tag("annually")
            }.pickerStyle(.segmented)
        
            Spacer()
            Menu("Filter") {
                Text("text")
            }
                .font(.headline)
                .frame(maxWidth:100)
                .background(.thickMaterial)
                .clipShape(Capsule())
//            Label {
//                Text("Paul Hudson")
//                    .foregroundColor(.primary)
//                    .font(.largeTitle)
//                    .padding()
//                    .background(.gray.opacity(0.2))
//                    .clipShape(Capsule())
//            } icon: {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(.blue)
//                    .frame(width: 64, height: 64)
//            }
            // Label("", systemImage: "chevron.down")
            Menu("Order") {
                Text("text")
            }
                .font(.headline)
                .frame(maxWidth:100)
                .background(.thickMaterial)
                .clipShape(Capsule())
            
        }
    }
}

struct ListFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ListFilterView()
            .previewLayout(.sizeThatFits)
    }
}
