import SwiftUI

struct JournalView: View {
    @EnvironmentObject var store: KHStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                summaryRow
                recordsCard
                weekChart
                heatmapCard
                archiveCard
                badgesCard
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Text("Ajustes")
                            .font(KHTheme.serif(16))
                            .foregroundColor(KHTheme.ink)
                        Spacer()
                        KHArrow()
                    }
                    .qpCard(padding: 14)
                }
                .buttonStyle(PressScaleStyle())
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Diario")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
            }
        }
    }

    private var summaryRow: some View {
        HStack(spacing: 10) {
            statCard("\(store.todayRead)", "páginas hoy", KHTheme.indigo)
            statCard("\(store.streak)", "días de racha", KHTheme.gold)
            statCard("\(store.state.totalPagesEver)", "páginas en total", KHTheme.rose)
        }
    }

    private func statCard(_ value: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(KHTheme.round(24))
                .foregroundColor(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(KHTheme.text(11))
                .foregroundColor(KHTheme.inkSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(KHTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(KHTheme.line, lineWidth: 1)
                )
        )
    }

    private var recordsCard: some View {
        Group {
            if !store.state.sittings.isEmpty || store.state.bestDayPages > 0 {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Récords de lectura")
                        .font(KHTheme.serif(16))
                        .foregroundColor(KHTheme.ink)
                    HStack(spacing: 8) {
                        recordCol(
                            store.state.bestDayPages > 0 ? "\(store.state.bestDayPages)" : "\u{2014}",
                            "mejor día, páginas"
                        )
                        recordCol(
                            store.longestSittingMinutes > 0 ? "\(store.longestSittingMinutes)m" : "\u{2014}",
                            "sesión más larga"
                        )
                        recordCol(
                            store.totalReadingMinutes >= 60
                                ? String(format: "%.1fh", Double(store.totalReadingMinutes) / 60)
                                : "\(store.totalReadingMinutes)m",
                            "tiempo de lectura"
                        )
                        recordCol(
                            store.minutesPerPage.map { String(format: "%.1f", $0) } ?? "\u{2014}",
                            "min por página"
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .qpCard()
            }
        }
    }

    private func recordCol(_ value: String, _ label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(KHTheme.round(17))
                .foregroundColor(KHTheme.indigo)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(KHTheme.text(9))
                .foregroundColor(KHTheme.inkFaint)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(KHTheme.indigoSoft.opacity(0.35))
        )
    }

    private var weekChart: some View {
        let cal = Calendar.current
        let days: [(String, Int)] = (0..<7).reversed().map { back in
            let d = cal.date(byAdding: .day, value: -back, to: Date())!
            let label = String(Self.weekdayFormatter.string(from: d).prefix(2))
            return (label, store.heatValue(for: d))
        }
        let maxVal = max(1, days.map { $0.1 }.max() ?? 1)
        let goal = store.pace().todayGoal
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Los últimos siete días")
                    .font(KHTheme.serif(16))
                    .foregroundColor(KHTheme.ink)
                Spacer()
                if goal > 0 {
                    KHChip(text: "meta \(goal)/día", tint: KHTheme.gold)
                }
            }
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(days.enumerated()), id: \.offset) { i, day in
                    VStack(spacing: 4) {
                        Text(day.1 > 0 ? "\(day.1)" : "")
                            .font(KHTheme.round(10))
                            .foregroundColor(KHTheme.indigo)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(i == days.count - 1 ? KHTheme.gold : KHTheme.indigo.opacity(day.1 > 0 ? 0.8 : 0.15))
                            .frame(height: max(6, CGFloat(day.1) / CGFloat(maxVal) * 80))
                        Text(day.0)
                            .font(KHTheme.text(10))
                            .foregroundColor(KHTheme.inkFaint)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .qpCard()
    }

    static let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_ES")
        f.dateFormat = "EEE"
        return f
    }()

    private var heatmapCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cinco semanas de lectura")
                .font(KHTheme.serif(16))
                .foregroundColor(KHTheme.ink)
            KHHeatGrid()
            HStack(spacing: 10) {
                Text("menos")
                    .font(KHTheme.text(10))
                    .foregroundColor(KHTheme.inkFaint)
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(qpHeatColor(i))
                        .frame(width: 14, height: 14)
                }
                Text("más")
                    .font(KHTheme.text(10))
                    .foregroundColor(KHTheme.inkFaint)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .qpCard()
    }

    private var archiveCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Jatms completados")
                .font(KHTheme.serif(16))
                .foregroundColor(KHTheme.ink)
            if store.state.archive.isEmpty {
                Text("Todavía ninguno. El primer cierre espera en la página 604.")
                    .font(KHTheme.text(13))
                    .foregroundColor(KHTheme.inkSoft)
            } else {
                ForEach(store.state.archive) { rec in
                    HStack(spacing: 12) {
                        ZStack {
                            MedallionRosette(tint: KHTheme.gold, petals: 8)
                                .frame(width: 44, height: 44)
                            OctoStar()
                                .fill(KHTheme.gold)
                                .frame(width: 16, height: 16)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(KHStore.niceDate.string(from: rec.started)) \u{2013} \(KHStore.niceDate.string(from: rec.finished))")
                                .font(KHTheme.text(13, .semibold))
                                .foregroundColor(KHTheme.ink)
                            Text("\(rec.days) días · \(String(format: "%.1f", 604.0 / Double(max(1, rec.days)))) páginas al día")
                                .font(KHTheme.text(11))
                                .foregroundColor(KHTheme.inkSoft)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .qpCard()
    }

    private var badgesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Logros")
                    .font(KHTheme.serif(16))
                    .foregroundColor(KHTheme.ink)
                Spacer()
                KHChip(text: "\(store.state.earned.count) de \(KHCatalog.badges.count)", tint: KHTheme.gold)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 8)], spacing: 8) {
                ForEach(KHCatalog.badges) { badge in
                    let earned = store.state.earned.contains(badge.id)
                    VStack(spacing: 5) {
                        OctoStar(points: 8)
                            .fill(earned ? KHTheme.gold : KHTheme.line.opacity(0.7))
                            .frame(width: 26, height: 26)
                        Text(badge.title)
                            .font(KHTheme.text(10, .semibold))
                            .foregroundColor(earned ? KHTheme.ink : KHTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        Text(badge.detail)
                            .font(KHTheme.text(8))
                            .foregroundColor(KHTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, minHeight: 92)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(earned ? KHTheme.goldSoft.opacity(0.35) : KHTheme.paperDeep.opacity(0.5))
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .qpCard()
    }
}

func qpHeatColor(_ level: Int) -> Color {
    switch level {
    case 0: return KHTheme.line.opacity(0.35)
    case 1: return KHTheme.indigo.opacity(0.3)
    case 2: return KHTheme.indigo.opacity(0.6)
    default: return KHTheme.indigo
    }
}

struct KHHeatGrid: View {
    @EnvironmentObject var store: KHStore

    var body: some View {
        let days = lastDays(35)
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(days, id: \.self) { day in
                let v = store.heatValue(for: day)
                RoundedRectangle(cornerRadius: 4)
                    .fill(qpHeatColor(levelFor(v)))
                    .frame(height: 22)
                    .overlay(
                        Group {
                            if Calendar.current.isDateInToday(day) {
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(KHTheme.gold, lineWidth: 1.5)
                            }
                        }
                    )
            }
        }
    }

    private func levelFor(_ v: Int) -> Int {
        switch v {
        case 0: return 0
        case 1..<4: return 1
        case 4..<10: return 2
        default: return 3
        }
    }

    private func lastDays(_ n: Int) -> [Date] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return (0..<n).reversed().compactMap { cal.date(byAdding: .day, value: -$0, to: today) }
    }
}
