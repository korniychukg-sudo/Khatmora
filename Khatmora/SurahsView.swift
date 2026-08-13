import SwiftUI

struct SurahsView: View {
    @EnvironmentObject var store: KHStore
    @State private var query = ""
    @State private var filter = 0
    @State private var pendingJump: SurahInfo? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                TextField("Buscar por nombre o significado", text: $query)
                    .font(KHTheme.text(14))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(KHTheme.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(KHTheme.line, lineWidth: 1)
                            )
                    )
                HStack(spacing: 6) {
                    filterButton("Todas", 0)
                    filterButton("Mecanas", 1)
                    filterButton("Medinenses", 2)
                    Spacer()
                }
                LazyVStack(spacing: 8) {
                    ForEach(filtered) { surah in
                        surahRow(surah)
                    }
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Las 114 suras")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
            }
        }
        .alert(item: $pendingJump) { surah in
            Alert(
                title: Text("¿Mover el marcador a \(surah.translit)?"),
                message: Text("Tu posición pasará al inicio de \(surah.translit), página \(surah.startPage), como si todo lo anterior ya estuviera leído."),
                primaryButton: .default(Text("Mover aquí")) {
                    store.setPosition(surah.startPage - 1)
                    KHHaptics.milestone()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func filterButton(_ label: String, _ idx: Int) -> some View {
        Button {
            filter = idx
            KHHaptics.tap()
        } label: {
            Text(label)
                .font(KHTheme.text(12, .semibold))
                .foregroundColor(filter == idx ? .white : KHTheme.inkSoft)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(filter == idx ? KHTheme.indigo : KHTheme.card))
                .overlay(Capsule().strokeBorder(filter == idx ? Color.clear : KHTheme.line, lineWidth: 1))
        }
        .buttonStyle(PressScaleStyle())
    }

    private var filtered: [SurahInfo] {
        var list = QuranCatalog.surahs
        if filter == 1 { list = list.filter { !$0.medinan } }
        if filter == 2 { list = list.filter { $0.medinan } }
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            list = list.filter {
                $0.translit.lowercased().contains(q)
                    || $0.meaning.lowercased().contains(q)
                    || String($0.number) == q
            }
        }
        return list
    }

    private var position: Int { store.state.plan?.position ?? 0 }

    private func surahRow(_ surah: SurahInfo) -> some View {
        let range = QuranMap.surahRange(surah)
        let fullyRead = position >= range.upperBound
        let reading = position + 1 >= range.lowerBound && !fullyRead
        return Button {
            pendingJump = surah
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    OctoStar(points: 8)
                        .fill(fullyRead ? KHTheme.sage.opacity(0.25) : KHTheme.indigoSoft.opacity(0.7))
                        .frame(width: 40, height: 40)
                    Text("\(surah.number)")
                        .font(KHTheme.round(13))
                        .foregroundColor(KHTheme.ink)
                }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(surah.translit)
                            .font(KHTheme.text(15, .semibold))
                            .foregroundColor(KHTheme.ink)
                        if fullyRead { KHCheck(size: 12) }
                        if reading { KHChip(text: "Leyendo", tint: KHTheme.gold) }
                    }
                    Text("\(surah.meaning) · \(surah.ayahs) aleyas · \(surah.medinan ? "medinense" : "mecana")")
                        .font(KHTheme.text(11))
                        .foregroundColor(KHTheme.inkSoft)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    if store.state.showArabicNames {
                        Text(surah.arabic)
                            .font(KHTheme.arabic(17))
                            .foregroundColor(KHTheme.indigo)
                    }
                    Text("pág. \(surah.startPage)")
                        .font(KHTheme.round(11))
                        .foregroundColor(KHTheme.inkFaint)
                }
            }
            .padding(11)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(reading ? KHTheme.goldSoft.opacity(0.3) : KHTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(reading ? KHTheme.gold.opacity(0.45) : KHTheme.line, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PressScaleStyle())
    }
}
