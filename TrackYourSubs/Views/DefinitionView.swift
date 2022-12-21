//
//  DefinitionView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/20/22.
//

import SwiftUI

struct DefinitionView: View {
    @Environment(\.dismiss) var dismiss
    var term: String
    var definition: String
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text(term).font(.title).padding()
                    Text(definition).foregroundColor(.secondary)
                }.padding()
                Spacer()
            }
            .navigationBarTitle(Text("Definition"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        DefinitionView(term: "Importance Index", definition: "This is metric that determines the overall importance or volume of important subscriptions that you have added. The value is calculated by specified importance by the total that is possible.\n\nCalculation: (Ascribed Importance / Overall Importance) * 100 = %")
    }
}
