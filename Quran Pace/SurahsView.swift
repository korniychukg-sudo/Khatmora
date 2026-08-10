import SwiftUI

struct SurahsView: View {
    @EnvironmentObject var store: QPStore
    @State private var query = ""
    @State private var filter = 0
    @State private var pendingJump: SurahInfo? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                TextField("Search by name or meaning", text: $query)
                    .font(QPTheme.text(14))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(QPTheme.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(QPTheme.line, lineWidth: 1)
                            )
                    )
                HStack(spacing: 6) {
                    filterButton("All", 0)
                    filterButton("Meccan", 1)
                    filterButton("Medinan", 2)
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
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("The 114 Surahs")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
        .alert(item: $pendingJump) { surah in
            Alert(
                title: Text("Move bookmark to \(surah.translit)?"),
                message: Text("Your position becomes the start of \(surah.translit), page \(surah.startPage) — as if everything before it is read."),
                primaryButton: .default(Text("Move it")) {
                    store.setPosition(surah.startPage - 1)
                    QPHaptics.milestone()
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func filterButton(_ label: String, _ idx: Int) -> some View {
        Button {
            filter = idx
            QPHaptics.tap()
        } label: {
            Text(label)
                .font(QPTheme.text(12, .semibold))
                .foregroundColor(filter == idx ? .white : QPTheme.inkSoft)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(filter == idx ? QPTheme.indigo : QPTheme.card))
                .overlay(Capsule().strokeBorder(filter == idx ? Color.clear : QPTheme.line, lineWidth: 1))
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
                        .fill(fullyRead ? QPTheme.sage.opacity(0.25) : QPTheme.indigoSoft.opacity(0.7))
                        .frame(width: 40, height: 40)
                    Text("\(surah.number)")
                        .font(QPTheme.round(13))
                        .foregroundColor(QPTheme.ink)
                }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(surah.translit)
                            .font(QPTheme.text(15, .semibold))
                            .foregroundColor(QPTheme.ink)
                        if fullyRead { QPCheck(size: 12) }
                        if reading { QPChip(text: "Reading", tint: QPTheme.gold) }
                    }
                    Text("\(surah.meaning) \u{00B7} \(surah.ayahs) verses \u{00B7} \(surah.medinan ? "Medinan" : "Meccan")")
                        .font(QPTheme.text(11))
                        .foregroundColor(QPTheme.inkSoft)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    if store.state.showArabicNames {
                        Text(surah.arabic)
                            .font(QPTheme.arabic(17))
                            .foregroundColor(QPTheme.indigo)
                    }
                    Text("p. \(surah.startPage)")
                        .font(QPTheme.round(11))
                        .foregroundColor(QPTheme.inkFaint)
                }
            }
            .padding(11)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(reading ? QPTheme.goldSoft.opacity(0.3) : QPTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(reading ? QPTheme.gold.opacity(0.45) : QPTheme.line, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PressScaleStyle())
    }
}
