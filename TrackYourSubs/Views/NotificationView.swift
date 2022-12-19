//
//  NotificationView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/17/22.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                let urgent = subViewModel.determineUpcoming().filter { $0.value < 1}
                if urgent.isEmpty {
                    VStack(alignment: .center) {
                        Image(systemName: "tray.fill").font(.largeTitle)
                        Text("Inbox is Empty").font(.title)
                        Text("Most urgent subscriptions will show up here.").frame(width: 200)
                    }
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(urgent.sorted { return $0.value < $1.value }, id:\.key) { key, value in
                        HStack {
                            Label("", systemImage: "hourglass.tophalf.filled")
                            VStack(alignment: .leading) {
                                Text(key.name).font(.title3).fontWeight(.semibold)
                                Text("due \(value == 0 ? "today" : "in \(value) day\(value > 1 ? "s" : "")")")
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Text("$" + String(key.amount))
                        }
                            .padding()
                            .background(Color("Tiles"))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .shadow(radius: 5)
                            .padding()
                    }
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Notifications"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .preferredColorScheme(.light)
            .environmentObject(SubViewModel())
    }
}
