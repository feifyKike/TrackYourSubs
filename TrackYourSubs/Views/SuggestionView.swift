//
//  SuggestionView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/16/22.
//

import SwiftUI

struct SuggestionView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let budgetToUse = subViewModel.budgetType == "monthly" ? subViewModel.ribbonData()[0] : subViewModel.ribbonData()[1]
        NavigationView {
            VStack {
                if budgetToUse >= subViewModel.budget * 2 && !subViewModel.subscriptions.isEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                        Text("Budget set too low.")
                        Spacer()
                    }
                        .padding()
                        .background(Color("Tiles"))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(radius: 5)
                    Spacer()
                }  else if budgetToUse > subViewModel.budget {
                    let toRemove: [SubItem] = subViewModel.save()
                    
                    HStack {
                        Text("Drop the following subscriptions to meet your set budget")
                        Spacer()
                        Button(action: {
                            subViewModel.acceptSuggestion(toRemove: toRemove)
                            dismiss()
                        }, label: {
                            Text("Drop All")
                        }).foregroundColor(.red)
                    }
                        .padding()
                        .background(Color("Tiles"))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(radius: 5)
                        .padding([.leading, .trailing, .top])
                    
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
                        Text("Warning! Dropping all or any single subcription is a irreversible action.")
                    }.padding()
                    
                    ForEach(toRemove, id:\.id) { sub in
                        HStack {
                            Button(action: {
                                removeSub(subID: sub.id)
                            }, label: {
                                Label("", systemImage: "minus.circle").foregroundColor(.red)
                            })
                            VStack(alignment: .leading) {
                                Text(sub.name).font(.title3).fontWeight(.semibold)
                                Text(sub.freq.capitalized).foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("$" + String(sub.amount)).font(.title3)
                        }
                    }
                        .padding()
                        .background(Color("Tiles"))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(radius: 5)
                        .padding([.leading, .trailing])
                    Spacer()
                } else {
                    VStack(alignment: .center) {
                        Image(systemName: "lightbulb.slash").font(.largeTitle)
                        Text("No Suggestions").font(.title)
                        Text("Suggestions to meet budget will show here.").frame(width: 200)
                    }
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
                .navigationBarTitle(Text("Suggestions"), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
    }
    
    func removeSub(subID: String) {
        subViewModel.deleteSub(id: subID)
    }
}

struct SuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionView()
            .environmentObject(SubViewModel())
    }
}
