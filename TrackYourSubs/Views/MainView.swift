//
//  MainView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/18/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var subViewModel: SubViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        // Home
        TabView {
            ListView()
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.3.group")
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SubViewModel())
            .environmentObject(NotificationManager())
    }
}
