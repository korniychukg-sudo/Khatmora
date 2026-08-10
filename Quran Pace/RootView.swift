import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: QPStore

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Group {
                    switch store.activeTab {
                    case 0:
                        NavigationView { TodayView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 1:
                        NavigationView { MushafView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 2:
                        NavigationView { SurahsView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 3:
                        NavigationView { LearnView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    default:
                        NavigationView { JournalView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                tabBar
            }
            if let badge = store.newBadge {
                QPBadgeToast(badge: badge)
                    .padding(.bottom, 84)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                            withAnimation(.easeIn(duration: 0.3)) {
                                if store.newBadge?.id == badge.id {
                                    store.newBadge = nil
                                }
                            }
                        }
                    }
            }
            if store.celebrateKhatm {
                KhatmCelebration()
            }
        }
        .animation(.easeOut(duration: 0.3), value: store.newBadge != nil)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton(0, "Today") { c in AnyView(TodayTabIcon(size: 24, color: c)) }
            tabButton(1, "Mushaf") { c in AnyView(MushafTabIcon(size: 24, color: c)) }
            tabButton(2, "Surahs") { c in AnyView(SurahTabIcon(size: 24, color: c)) }
            tabButton(3, "Learn") { c in AnyView(LearnTabIcon(size: 24, color: c)) }
            tabButton(4, "Journal") { c in AnyView(JournalTabIcon(size: 24, color: c)) }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(
            QPTheme.card
                .overlay(Rectangle().fill(QPTheme.line).frame(height: 1), alignment: .top)
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    private func tabButton(_ index: Int, _ label: String, icon: @escaping (Color) -> AnyView) -> some View {
        let active = store.activeTab == index
        let color = active ? QPTheme.indigo : QPTheme.inkFaint
        return Button {
            if store.activeTab != index {
                store.activeTab = index
                QPHaptics.tap()
            }
        } label: {
            VStack(spacing: 3) {
                icon(color)
                Text(label)
                    .font(QPTheme.text(10, active ? .semibold : .medium))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(active ? QPTheme.indigo.opacity(0.09) : Color.clear)
                    .padding(.horizontal, 8)
            )
        }
        .buttonStyle(PressScaleStyle())
    }
}

struct KhatmCelebration: View {
    @EnvironmentObject var store: QPStore

    var body: some View {
        ZStack {
            QPTheme.ink.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 16) {
                ZStack {
                    MedallionRosette(tint: QPTheme.gold, petals: 12)
                        .frame(width: 130, height: 130)
                    OctoStar(points: 8)
                        .fill(QPTheme.gold)
                        .frame(width: 44, height: 44)
                }
                Text("Khatm sealed")
                    .font(QPTheme.serif(28))
                    .foregroundColor(QPTheme.ink)
                Text("Every one of the 604 pages, from Al-Fatihah to An-Nas. The reading is complete and recorded in your journal.")
                    .font(QPTheme.text(14))
                    .foregroundColor(QPTheme.inkSoft)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                Button {
                    store.closeCompletedKhatm()
                    store.activeTab = 0
                } label: {
                    Text("Begin the next")
                        .font(QPTheme.text(15, .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(QPTheme.indigo))
                }
                .buttonStyle(PressScaleStyle())
                Button {
                    store.celebrateKhatm = false
                } label: {
                    Text("Not yet")
                        .font(QPTheme.text(13, .medium))
                        .foregroundColor(QPTheme.inkFaint)
                }
            }
            .padding(28)
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(QPTheme.paper)
                    .shadow(color: QPTheme.ink.opacity(0.25), radius: 20, x: 0, y: 8)
            )
            .padding(.horizontal, 30)
        }
    }
}
