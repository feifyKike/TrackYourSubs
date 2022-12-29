//
//  OnboardingView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/29/22.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var onboarding: Bool
    
    var body: some View {
        TabView {
            OnboardingPageView(
                title: "Track Subscriptions",
                description: "Store all your subscriptions locally on your device. No need to connect any accounts or store data in the cloud.",
                image: "OnboardingImg1",
                showDismiss: false,
                onboarding: $onboarding
            )
            OnboardingPageView(
                title: "Organize & Budget",
                description: "Use budgeting and organizational features to keep track of your multi-dimensional list of expenses. ",
                image: "OnboardingImg2",
                showDismiss: false,
                onboarding: $onboarding
            )
            OnboardingPageView(
                title: "Assess Visually",
                description: "Visually inspect the big picture of your subscription portfolio.",
                image: "OnboardingImg3",
                showDismiss: true,
                onboarding: $onboarding
            )
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onAppear() {
            UIPageControl.appearance().currentPageIndicatorTintColor = .label
            UIPageControl.appearance().pageIndicatorTintColor = .secondaryLabel
        }
       
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onboarding: .constant(true))
    }
}
