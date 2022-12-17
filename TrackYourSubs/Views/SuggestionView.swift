//
//  SuggestionView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/16/22.
//

import SwiftUI

struct SuggestionView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    
    var body: some View {
        let budgetToUse = subViewModel.budgetType == "monthly" ? subViewModel.ribbonData()[0] : subViewModel.ribbonData()[1]
        if budgetToUse >= subViewModel.budget * 2 && !subViewModel.subscriptions.isEmpty {
            VStack {
                Text("Budget set too low.")
            }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 5)
            
        }  else if budgetToUse > subViewModel.budget {
            let toRemove: [SubItem] = subViewModel.save()
            
            VStack {
                Text("Drop \(subViewModel.remFormatted(subs: toRemove)) to meet set budget")
                Button(action: {subViewModel.acceptSuggestion(toRemove: toRemove)}, label: {Text("Accept")}).foregroundColor(.green)
            }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 5)
                .padding([.leading, .trailing])
            
        }
    }
}

struct SuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionView()
            .previewLayout(.sizeThatFits)
            .environmentObject(SubViewModel())
    }
}
