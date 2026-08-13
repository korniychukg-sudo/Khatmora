import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: KHStore

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
                KHBadgeToast(badge: badge)
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
            } else if let seal = store.pendingSeal {
                SealCelebration(juz: seal)
            }
        }
        .animation(.easeOut(duration: 0.3), value: store.newBadge != nil)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabButton(0, "Hoy") { c in AnyView(TodayTabIcon(size: 24, color: c)) }
            tabButton(1, "Mushaf") { c in AnyView(MushafTabIcon(size: 24, color: c)) }
            tabButton(2, "Suras") { c in AnyView(SurahTabIcon(size: 24, color: c)) }
            tabButton(3, "Aprender") { c in AnyView(LearnTabIcon(size: 24, color: c)) }
            tabButton(4, "Diario") { c in AnyView(JournalTabIcon(size: 24, color: c)) }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(
            KHTheme.card
                .overlay(Rectangle().fill(KHTheme.line).frame(height: 1), alignment: .top)
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    private func tabButton(_ index: Int, _ label: String, icon: @escaping (Color) -> AnyView) -> some View {
        let active = store.activeTab == index
        let color = active ? KHTheme.indigo : KHTheme.inkFaint
        return Button {
            if store.activeTab != index {
                store.activeTab = index
                KHHaptics.tap()
            }
        } label: {
            VStack(spacing: 3) {
                icon(color)
                Text(label)
                    .font(KHTheme.text(10, active ? .semibold : .medium))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(active ? KHTheme.indigo.opacity(0.09) : Color.clear)
                    .padding(.horizontal, 8)
            )
        }
        .buttonStyle(PressScaleStyle())
    }
}

struct SealCelebration: View {
    @EnvironmentObject var store: KHStore
    let juz: Int

    var body: some View {
        ZStack {
            KHTheme.ink.opacity(0.35).ignoresSafeArea()
            VStack(spacing: 14) {
                ZStack {
                    MedallionRosette(tint: KHTheme.gold, petals: 10)
                        .frame(width: 104, height: 104)
                    OctoStar(points: 8)
                        .fill(KHTheme.gold)
                        .frame(width: 40, height: 40)
                    Text("\(juz)")
                        .font(KHTheme.round(15))
                        .foregroundColor(.white)
                }
                Text("Yuz \(juz) completado")
                    .font(KHTheme.serif(25))
                    .foregroundColor(KHTheme.ink)
                Text("Has dejado atrás \(QuranMap.juzOpenings[juz - 1]). Quedan \(30 - juz) parte\(30 - juz == 1 ? "" : "s"). El sello se añade a tu colección en la pestaña Mushaf.")
                    .font(KHTheme.text(13))
                    .foregroundColor(KHTheme.inkSoft)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                Button {
                    store.pendingSeal = nil
                } label: {
                    Text("Seguir leyendo")
                        .font(KHTheme.text(15, .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 11)
                        .background(Capsule().fill(KHTheme.indigo))
                }
                .buttonStyle(PressScaleStyle())
            }
            .padding(26)
            .frame(maxWidth: 400)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(KHTheme.paper)
                    .shadow(color: KHTheme.ink.opacity(0.25), radius: 20, x: 0, y: 8)
            )
            .padding(.horizontal, 34)
        }
    }
}

struct KhatmCelebration: View {
    @EnvironmentObject var store: KHStore

    var body: some View {
        ZStack {
            KHTheme.ink.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 16) {
                ZStack {
                    MedallionRosette(tint: KHTheme.gold, petals: 12)
                        .frame(width: 130, height: 130)
                    OctoStar(points: 8)
                        .fill(KHTheme.gold)
                        .frame(width: 44, height: 44)
                }
                Text("Jatm completado")
                    .font(KHTheme.serif(28))
                    .foregroundColor(KHTheme.ink)
                Text("Has leído las 604 páginas, desde Al-Fatihah hasta An-Nas. La lectura está completa y ha quedado guardada en tu diario.")
                    .font(KHTheme.text(14))
                    .foregroundColor(KHTheme.inkSoft)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                Button {
                    store.closeCompletedKhatm()
                    store.activeTab = 0
                } label: {
                    Text("Comenzar el siguiente")
                        .font(KHTheme.text(15, .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(KHTheme.indigo))
                }
                .buttonStyle(PressScaleStyle())
                Button {
                    store.celebrateKhatm = false
                } label: {
                    Text("Ahora no")
                        .font(KHTheme.text(13, .medium))
                        .foregroundColor(KHTheme.inkFaint)
                }
            }
            .padding(28)
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(KHTheme.paper)
                    .shadow(color: KHTheme.ink.opacity(0.25), radius: 20, x: 0, y: 8)
            )
            .padding(.horizontal, 30)
        }
    }
}
