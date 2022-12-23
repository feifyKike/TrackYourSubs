//
//  TrackYourSubsApp.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/4/22.
//

import SwiftUI

@main
struct TrackYourSubsApp: App {
    
    @StateObject var subViewModel: SubViewModel = SubViewModel()
    @StateObject var notificationManager: NotificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(subViewModel)
                .environmentObject(notificationManager)
        }
    }
}
