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
        if !subViewModel.tutorial {
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
        } else {
            // Tutorial
            NavigationView {
                VStack {
                    Text("To a place where you can manage subscriptions, lower your bills, and stay on top of your financial spending. With this simple to use app you will not want to go back to making spreadsheets.").padding()
                    
                    NavigationLink(destination: AddView(), label: {
                        Text("Get Started").font(.title3)
                    }).buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                .navigationTitle("🎉 Welcome!")
                .onAppear {
                    notificationManager.requestAuthorization()
                }
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
