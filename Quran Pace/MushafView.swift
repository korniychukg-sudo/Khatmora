import SwiftUI

struct MushafView: View {
    @EnvironmentObject var store: QPStore
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
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("The Mushaf")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
    }

    private var picker: some View {
        HStack(spacing: 8) {
            pickButton("Thirty parts", 0)
            pickButton("604 pages", 1)
            Spacer()
        }
    }

    private func pickButton(_ label: String, _ idx: Int) -> some View {
        Button {
            section = idx
            selectedPage = nil
            QPHaptics.tap()
        } label: {
            Text(label)
                .font(QPTheme.text(13, .semibold))
                .foregroundColor(section == idx ? .white : QPTheme.indigo)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(section == idx ? QPTheme.indigo : QPTheme.indigoSoft.opacity(0.6)))
        }
        .buttonStyle(PressScaleStyle())
    }

    private var position: Int { store.state.plan?.position ?? 0 }

    private var juzList: some View {
        VStack(spacing: 10) {
            ForEach(1...30, id: \.self) { juz in
                juzCard(juz)
            }
        }
    }

    private func juzCard(_ juz: Int) -> some View {
        let range = QuranMap.juzRange(juz)
        let total = range.count
        let done = max(0, min(total, position - range.lowerBound + 1))
        let fraction = Double(done) / Double(total)
        let active = position + 1 >= range.lowerBound && position < range.upperBound
        return HStack(spacing: 14) {
            ZStack {
                PaceRing(progress: fraction, lineWidth: 5, tint: fraction >= 1 ? QPTheme.sage : QPTheme.indigo)
                    .frame(width: 52, height: 52)
                Text("\(juz)")
                    .font(QPTheme.round(17))
                    .foregroundColor(QPTheme.ink)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(QuranMap.juzOpenings[juz - 1])
                    .font(QPTheme.text(15, .semibold))
                    .foregroundColor(QPTheme.ink)
                Text("Pages \(range.lowerBound)\u{2013}\(range.upperBound) \u{00B7} \(QuranMap.surah(forPage: range.lowerBound).translit) onward")
                    .font(QPTheme.text(12))
                    .foregroundColor(QPTheme.inkSoft)
            }
            Spacer()
            if fraction >= 1 {
                QPCheck()
            } else if active {
                QPChip(text: "Reading", tint: QPTheme.gold)
            } else if done > 0 {
                Text("\(done)/\(total)")
                    .font(QPTheme.round(12))
                    .foregroundColor(QPTheme.indigo)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(active ? QPTheme.goldSoft.opacity(0.35) : QPTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(active ? QPTheme.gold.opacity(0.5) : QPTheme.line, lineWidth: 1)
                )
        )
    }

    private var pageGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 20)
        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                legendDot(QPTheme.indigo, "read")
                legendDot(QPTheme.gold, "next page")
                legendDot(QPTheme.line.opacity(0.5), "ahead")
            }
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(1...QuranMap.totalPages, id: \.self) { page in
                    pageCell(page)
                }
            }
            Text("Tap a page to move your bookmark there. Divider rows mark each new juz.")
                .font(QPTheme.text(11))
                .foregroundColor(QPTheme.inkFaint)
        }
    }

    private func pageCell(_ page: Int) -> some View {
        let read = page <= position
        let isNext = page == position + 1
        let isJuzStart = QuranMap.juzStartPages.contains(page)
        let selected = selectedPage == page
        return RoundedRectangle(cornerRadius: 2.5)
            .fill(read ? QPTheme.indigo : (isNext ? QPTheme.gold : QPTheme.line.opacity(0.5)))
            .overlay(
                Group {
                    if isJuzStart {
                        RoundedRectangle(cornerRadius: 2.5)
                            .strokeBorder(QPTheme.rose.opacity(0.8), lineWidth: 1)
                    }
                    if selected {
                        RoundedRectangle(cornerRadius: 2.5)
                            .strokeBorder(QPTheme.ink, lineWidth: 1.6)
                    }
                }
            )
            .aspectRatio(0.72, contentMode: .fit)
            .onTapGesture {
                selectedPage = page
                QPHaptics.tap()
            }
    }

    private func legendDot(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 5) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 12, height: 14)
            Text(label)
                .font(QPTheme.text(11))
                .foregroundColor(QPTheme.inkSoft)
        }
    }

    private func setBar(_ page: Int) -> some View {
        let surah = QuranMap.surah(forPage: page)
        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Page \(page)")
                    .font(QPTheme.text(14, .semibold))
                    .foregroundColor(QPTheme.ink)
                Text("Juz \(QuranMap.juz(forPage: page)) \u{00B7} \(surah.translit)")
                    .font(QPTheme.text(11))
                    .foregroundColor(QPTheme.inkSoft)
            }
            Spacer()
            Button {
                store.setPosition(page)
                selectedPage = nil
                QPHaptics.milestone()
            } label: {
                Text("Read to here")
                    .font(QPTheme.text(13, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
            Button {
                selectedPage = nil
            } label: {
                Text("Cancel")
                    .font(QPTheme.text(12, .medium))
                    .foregroundColor(QPTheme.inkFaint)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(QPTheme.card)
                .shadow(color: QPTheme.ink.opacity(0.2), radius: 12, x: 0, y: 5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}
