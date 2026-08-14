import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var store: KHStore
    @State private var page = 0

    private let pages: [(art: String, title: String, text: String)] = [
        ("onboard-1", "El cuaderno junto a tu mushaf", "Khatmora no contiene el texto coránico. Lees en el ejemplar que prefieras, impreso o digital, y aquí conservas el mapa, el marcador, la porción diaria y el ritmo."),
        ("onboard-2", "Las 604 páginas, en un mapa", "Todo el mushaf aparece como una cuadrícula de páginas y treinta partes. Toca el punto donde te detuviste y el mapa se completa detrás del marcador, yuz a yuz."),
        ("onboard-3", "Un ritmo que dice la verdad", "Elige una fecha final y recibe una porción diaria realista, recalculada cuando la vida se interpone. O fija las páginas diarias y observa cómo se acerca la fecha prevista."),
        ("onboard-4", "El anillo del jatm", "Cada página registrada llena un poco más el anillo de la lectura completa. Las treinta partes se sellan una a una y el diario guarda tus rachas, tu ritmo y cada jatm terminado.")
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                ForEach(0..<pages.count, id: \.self) { i in
                    VStack(spacing: 20) {
                        Spacer(minLength: 10)
                        KhatmoraArtImage(name: pages[i].art)
                            .frame(maxWidth: 460, maxHeight: 340)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .strokeBorder(KHTheme.line, lineWidth: 1)
                            )
                            .padding(.horizontal, 26)
                        Text(pages[i].title)
                            .font(KHTheme.serif(25))
                            .foregroundColor(KHTheme.ink)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        Text(pages[i].text)
                            .font(KHTheme.text(15))
                            .foregroundColor(KHTheme.inkSoft)
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
                        .fill(i == page ? KHTheme.indigo : KHTheme.line)
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
                    KHHaptics.success()
                }
            } label: {
                Text(page < pages.count - 1 ? "Continuar" : "Abrir el mapa")
                    .font(KHTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 340)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 12)
            if page < pages.count - 1 {
                Button {
                    store.finishOnboarding()
                } label: {
                    Text("Omitir")
                        .font(KHTheme.text(13, .medium))
                        .foregroundColor(KHTheme.inkFaint)
                }
                .padding(.bottom, 14)
            } else {
                Color.clear.frame(height: 33)
            }
        }
        .background(KHTheme.paper.ignoresSafeArea())
    }
}
