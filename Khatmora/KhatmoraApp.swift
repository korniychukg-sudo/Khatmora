import SwiftUI

@main
struct KhatmoraApp: App {
    @StateObject private var store = KHStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if Self.isScreenshotMode || store.state.onboarded {
                    RootView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(store)
            .environment(\.locale, Locale(identifier: "es_ES"))
            .preferredColorScheme(.light)
            .task {
                #if DEBUG
                if Self.isScreenshotMode {
                    store.prepareScreenshotStateIfNeeded()
                }
                #endif
            }
        }
    }

    private static var isScreenshotMode: Bool {
        #if DEBUG
        ProcessInfo.processInfo.arguments.contains("-screenshot")
        #else
        false
        #endif
    }
}
