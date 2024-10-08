//
//  ListHeaderView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/17/22.
//

import SwiftUI

struct ListHeaderView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    
    var body: some View {
        let rd = subViewModel.ribbonData()
        HStack {
            Text("\(subViewModel.subscriptions.count) subscription\(subViewModel.subscriptions.count > 1 ? "s" : "")")
            Spacer()
            Text("\(rd[0].formatted(.currency(code: subViewModel.currency)))/M, \(rd[1].formatted(.currency(code: subViewModel.currency)))/YR")
            
        }
            .padding([.leading, .trailing])
            .foregroundColor(.gray)
    }
}

struct ListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderView()
            .environmentObject(SubViewModel())
            .previewLayout(.sizeThatFits)
    }
}
