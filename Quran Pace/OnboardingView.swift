import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var store: QPStore
    @State private var page = 0

    private let pages: [(art: String, title: String, text: String)] = [
        ("onboard-1", "The logbook beside your mushaf", "Quran Pace holds no Quran text. You read from the copy you love — paper or app — and this keeps the map: the bookmark, the daily portion, the pace."),
        ("onboard-2", "All 604 pages, mapped", "The whole mushaf as a grid of pages and thirty parts. Tap where you stopped and the map fills in behind your bookmark, juz by juz."),
        ("onboard-3", "A pace that tells the truth", "Pick a finish date and get the honest daily portion — recomputed when life intervenes. Or fix your pages a day and watch the forecast date walk closer."),
        ("onboard-4", "On your Lock Screen", "Widgets carry today's portion and the khatm ring to the Lock Screen, Home Screen and StandBy — the next page is always in sight.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                ForEach(0..<pages.count, id: \.self) { i in
                    VStack(spacing: 20) {
                        Spacer(minLength: 10)
                        PaceArtImage(name: pages[i].art)
                            .frame(maxWidth: 460, maxHeight: 340)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .strokeBorder(QPTheme.line, lineWidth: 1)
                            )
                            .padding(.horizontal, 26)
                        Text(pages[i].title)
                            .font(QPTheme.serif(25))
                            .foregroundColor(QPTheme.ink)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        Text(pages[i].text)
                            .font(QPTheme.text(15))
                            .foregroundColor(QPTheme.inkSoft)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                            .padding(.horizontal, 34)
                        Spacer()
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            HStack(spacing: 7) {
                ForEach(0..<pages.count, id: \.self) { i in
                    Capsule()
                        .fill(i == page ? QPTheme.indigo : QPTheme.line)
                        .frame(width: i == page ? 22 : 7, height: 7)
                        .animation(.easeOut(duration: 0.25), value: page)
                }
            }
            .padding(.bottom, 18)
            Button {
                if page < pages.count - 1 {
                    withAnimation { page += 1 }
                } else {
                    store.finishOnboarding()
                    QPHaptics.success()
                }
            } label: {
                Text(page < pages.count - 1 ? "Continue" : "Open the map")
                    .font(QPTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 340)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 12)
            if page < pages.count - 1 {
                Button {
                    store.finishOnboarding()
                } label: {
                    Text("Skip")
                        .font(QPTheme.text(13, .medium))
                        .foregroundColor(QPTheme.inkFaint)
                }
                .padding(.bottom, 14)
            } else {
                Color.clear.frame(height: 33)
            }
        }
        .background(QPTheme.paper.ignoresSafeArea())
    }
}
