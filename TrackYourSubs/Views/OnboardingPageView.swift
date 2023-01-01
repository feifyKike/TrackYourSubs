//
//  OnboardingPageView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/29/22.
//

import SwiftUI

struct OnboardingPageView: View {
    let title: String
    let description: String
    let image: String
    let greeting: Bool
    let showDismiss: Bool
    @Binding var onboarding: Bool
    
    var body: some View {
        VStack {
            if greeting {
                Text("Welcome to TrackYourSubs!")
                    .font(.largeTitle)
                    .fontWeight(.light)
            }
            Image(image)
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text(description)
                .padding([.leading, .trailing])
            if showDismiss {
                Button(action: {
                    onboarding.toggle()
                }, label: {
                    Text("Get Started")
                        .font(.title2)
                })
                .buttonStyle(.borderedProminent)
                .padding([.top])
            }
        }
        .multilineTextAlignment(.center)
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(
            title: "Track Subscriptions",
            description: "Store all your subscriptions locally with",
            image: "OnboardingImg1",
            greeting: true,
            showDismiss: true,
            onboarding: .constant(true)
        )
    }
}
