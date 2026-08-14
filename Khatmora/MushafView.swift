import SwiftUI

struct MushafView: View {
    @EnvironmentObject var store: KHStore
    @State private var section = 0
    @State private var selectedPage: Int? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    picker
                    if section == 0 {
                        juzList
                    } else {
                        pageGrid
                    }
                }
                .padding(16)
                .padding(.bottom, selectedPage == nil ? 12 : 90)
            }
            if let page = selectedPage {
                setBar(page)
            }
        }
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("El Mushaf")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
            }
        }
    }

    private var picker: some View {
        HStack(spacing: 8) {
            pickButton("Treinta partes", 0)
            pickButton("604 páginas", 1)
            Spacer()
        }
    }

    private func pickButton(_ label: String, _ idx: Int) -> some View {
        Button {
            section = idx
            selectedPage = nil
            KHHaptics.tap()
        } label: {
            Text(label)
                .font(KHTheme.text(13, .semibold))
                .foregroundColor(section == idx ? .white : KHTheme.indigo)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(section == idx ? KHTheme.indigo : KHTheme.indigoSoft.opacity(0.6)))
        }
        .buttonStyle(PressScaleStyle())
    }

    private var position: Int { store.state.plan?.position ?? 0 }

    private var juzList: some View {
        VStack(spacing: 10) {
            sealsCard
            ForEach(1...30, id: \.self) { juz in
                juzCard(juz)
            }
        }
    }

    private var sealsCard: some View {
        let sealed = store.state.sealedJuz
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Los treinta sellos")
                    .font(KHTheme.serif(16))
                    .foregroundColor(KHTheme.ink)
                Spacer()
                KHChip(text: "\(sealed.count) de 30", tint: KHTheme.gold)
            }
            Text("Se obtiene un sello cada vez que se lee una parte completa hasta su última página.")
                .font(KHTheme.text(11))
                .foregroundColor(KHTheme.inkFaint)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 10), spacing: 8) {
                ForEach(1...30, id: \.self) { j in
                    let done = sealed.contains(j)
                    ZStack {
                        OctoStar(points: 8)
                            .fill(done ? KHTheme.gold : KHTheme.line.opacity(0.45))
                            .frame(width: 26, height: 26)
                        Text("\(j)")
                            .font(KHTheme.round(9))
                            .foregroundColor(done ? .white : KHTheme.inkFaint)
                    }
                    .frame(height: 28)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .khCard(padding: 14)
    }

    private func juzCard(_ juz: Int) -> some View {
        let range = QuranMap.juzRange(juz)
        let total = range.count
        let done = max(0, min(total, position - range.lowerBound + 1))
        let fraction = Double(done) / Double(total)
        let active = position + 1 >= range.lowerBound && position < range.upperBound
        return HStack(spacing: 14) {
            ZStack {
                KhatmoraRing(progress: fraction, lineWidth: 5, tint: fraction >= 1 ? KHTheme.sage : KHTheme.indigo)
                    .frame(width: 52, height: 52)
                Text("\(juz)")
                    .font(KHTheme.round(17))
                    .foregroundColor(KHTheme.ink)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(QuranMap.juzOpenings[juz - 1])
                    .font(KHTheme.text(15, .semibold))
                    .foregroundColor(KHTheme.ink)
                Text("Páginas \(range.lowerBound)–\(range.upperBound) · desde \(QuranMap.surah(forPage: range.lowerBound).translit)")
                    .font(KHTheme.text(12))
                    .foregroundColor(KHTheme.inkSoft)
                HStack(spacing: 5) {
                    ForEach(0..<4, id: \.self) { q in
                        let qEnd = range.lowerBound + (range.count * (q + 1)) / 4 - 1
                        Circle()
                            .fill(position >= qEnd ? KHTheme.gold : KHTheme.line.opacity(0.6))
                            .frame(width: 6, height: 6)
                    }
                    Text("cuartos")
                        .font(KHTheme.text(9))
                        .foregroundColor(KHTheme.inkFaint)
                }
            }
            Spacer()
            if fraction >= 1 {
                KHCheck()
            } else if active {
                KHChip(text: "Leyendo", tint: KHTheme.gold)
            } else if done > 0 {
                Text("\(done)/\(total)")
                    .font(KHTheme.round(12))
                    .foregroundColor(KHTheme.indigo)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(active ? KHTheme.goldSoft.opacity(0.35) : KHTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(active ? KHTheme.gold.opacity(0.5) : KHTheme.line, lineWidth: 1)
                )
        )
    }

    private var pageGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 20)
        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                legendDot(KHTheme.indigo, "leído")
                legendDot(KHTheme.gold, "siguiente")
                legendDot(KHTheme.line.opacity(0.5), "pendiente")
            }
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(1...QuranMap.totalPages, id: \.self) { page in
                    pageCell(page)
                }
            }
            Text("Toca una página para mover allí el marcador. Las filas divisorias señalan cada nuevo yuz.")
                .font(KHTheme.text(11))
                .foregroundColor(KHTheme.inkFaint)
        }
    }

    private func pageCell(_ page: Int) -> some View {
        let read = page <= position
        let isNext = page == position + 1
        let isJuzStart = QuranMap.juzStartPages.contains(page)
        let selected = selectedPage == page
        return RoundedRectangle(cornerRadius: 2.5)
            .fill(read ? KHTheme.indigo : (isNext ? KHTheme.gold : KHTheme.line.opacity(0.5)))
            .overlay(
                Group {
                    if isJuzStart {
                        RoundedRectangle(cornerRadius: 2.5)
                            .strokeBorder(KHTheme.rose.opacity(0.8), lineWidth: 1)
                    }
                    if selected {
                        RoundedRectangle(cornerRadius: 2.5)
                            .strokeBorder(KHTheme.ink, lineWidth: 1.6)
                    }
                }
            )
            .aspectRatio(0.72, contentMode: .fit)
            .onTapGesture {
                selectedPage = page
                KHHaptics.tap()
            }
    }

    private func legendDot(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 12, height: 14)
            Text(label)
                .font(KHTheme.text(11))
                .foregroundColor(KHTheme.inkSoft)
        }
    }

    private func setBar(_ page: Int) -> some View {
        let surah = QuranMap.surah(forPage: page)
        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Página \(page)")
                    .font(KHTheme.text(14, .semibold))
                    .foregroundColor(KHTheme.ink)
                Text("Yuz \(QuranMap.juz(forPage: page)) · \(surah.translit)")
                    .font(KHTheme.text(11))
                    .foregroundColor(KHTheme.inkSoft)
            }
            Spacer()
            Button {
                store.setPosition(page)
                selectedPage = nil
                KHHaptics.milestone()
            } label: {
                Text("He leído hasta aquí")
                    .font(KHTheme.text(13, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
            Button {
                selectedPage = nil
            } label: {
                Text("Cancelar")
                    .font(KHTheme.text(12, .medium))
                    .foregroundColor(KHTheme.inkFaint)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(KHTheme.card)
                .shadow(color: KHTheme.ink.opacity(0.2), radius: 12, x: 0, y: 5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}
