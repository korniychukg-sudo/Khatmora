import SwiftUI

@main
struct QuranPaceApp: App {
    @StateObject private var store = QPStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if store.state.onboarded {
                    RootView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(store)
            .preferredColorScheme(.light)
        }
    }
}
