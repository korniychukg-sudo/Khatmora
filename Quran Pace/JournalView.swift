import SwiftUI

struct JournalView: View {
    @EnvironmentObject var store: QPStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                summaryRow
                weekChart
                heatmapCard
                archiveCard
                badgesCard
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Text("Settings")
                            .font(QPTheme.serif(16))
                            .foregroundColor(QPTheme.ink)
                        Spacer()
                        QPArrow()
                    }
                    .qpCard(padding: 14)
                }
                .buttonStyle(PressScaleStyle())
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Journal")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
    }

    private var summaryRow: some View {
        HStack(spacing: 10) {
            statCard("\(store.todayRead)", "pages today", QPTheme.indigo)
            statCard("\(store.streak)", "day streak", QPTheme.gold)
            statCard("\(store.state.totalPagesEver)", "pages in all", QPTheme.rose)
        }
    }

    private func statCard(_ value: String, _ label: String, _ tint: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(QPTheme.round(24))
                .foregroundColor(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(QPTheme.text(11))
                .foregroundColor(QPTheme.inkSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(QPTheme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(QPTheme.line, lineWidth: 1)
                )
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
                Text("The last seven days")
                    .font(QPTheme.serif(16))
                    .foregroundColor(QPTheme.ink)
                Spacer()
                if goal > 0 {
                    QPChip(text: "goal \(goal)/day", tint: QPTheme.gold)
                }
            }
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(days.enumerated()), id: \.offset) { i, day in
                    VStack(spacing: 4) {
                        Text(day.1 > 0 ? "\(day.1)" : "")
                            .font(QPTheme.round(10))
                            .foregroundColor(QPTheme.indigo)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(i == days.count - 1 ? QPTheme.gold : QPTheme.indigo.opacity(day.1 > 0 ? 0.8 : 0.15))
                            .frame(height: max(6, CGFloat(day.1) / CGFloat(maxVal) * 80))
                        Text(day.0)
                            .font(QPTheme.text(10))
                            .foregroundColor(QPTheme.inkFaint)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .qpCard()
    }

    static let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEE"
        return f
    }()

    private var heatmapCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Five weeks of reading")
                .font(QPTheme.serif(16))
                .foregroundColor(QPTheme.ink)
            QPHeatGrid()
            HStack(spacing: 10) {
                Text("less")
                    .font(QPTheme.text(10))
                    .foregroundColor(QPTheme.inkFaint)
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(qpHeatColor(i))
                        .frame(width: 14, height: 14)
                }
                Text("more")
                    .font(QPTheme.text(10))
                    .foregroundColor(QPTheme.inkFaint)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .qpCard()
    }

    private var archiveCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sealed khatms")
                .font(QPTheme.serif(16))
                .foregroundColor(QPTheme.ink)
            if store.state.archive.isEmpty {
                Text("None yet. The first seal is waiting at page 604.")
                    .font(QPTheme.text(13))
                    .foregroundColor(QPTheme.inkSoft)
            } else {
                ForEach(store.state.archive) { rec in
                    HStack(spacing: 12) {
                        ZStack {
                            MedallionRosette(tint: QPTheme.gold, petals: 8)
                                .frame(width: 44, height: 44)
                            OctoStar()
                                .fill(QPTheme.gold)
                                .frame(width: 16, height: 16)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(QPStore.niceDate.string(from: rec.started)) \u{2013} \(QPStore.niceDate.string(from: rec.finished))")
                                .font(QPTheme.text(13, .semibold))
                                .foregroundColor(QPTheme.ink)
                            Text("\(rec.days) days \u{00B7} \(String(format: "%.1f", 604.0 / Double(max(1, rec.days)))) pages a day")
                                .font(QPTheme.text(11))
                                .foregroundColor(QPTheme.inkSoft)
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
                Text("Badges")
                    .font(QPTheme.serif(16))
                    .foregroundColor(QPTheme.ink)
                Spacer()
                QPChip(text: "\(store.state.earned.count) of \(QPCatalog.badges.count)", tint: QPTheme.gold)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 8)], spacing: 8) {
                ForEach(QPCatalog.badges) { badge in
                    let earned = store.state.earned.contains(badge.id)
                    VStack(spacing: 5) {
                        OctoStar(points: 8)
                            .fill(earned ? QPTheme.gold : QPTheme.line.opacity(0.7))
                            .frame(width: 26, height: 26)
                        Text(badge.title)
                            .font(QPTheme.text(10, .semibold))
                            .foregroundColor(earned ? QPTheme.ink : QPTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        Text(badge.detail)
                            .font(QPTheme.text(8))
                            .foregroundColor(QPTheme.inkFaint)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, minHeight: 92)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(earned ? QPTheme.goldSoft.opacity(0.35) : QPTheme.paperDeep.opacity(0.5))
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
    case 0: return QPTheme.line.opacity(0.35)
    case 1: return QPTheme.indigo.opacity(0.3)
    case 2: return QPTheme.indigo.opacity(0.6)
    default: return QPTheme.indigo
    }
}

struct QPHeatGrid: View {
    @EnvironmentObject var store: QPStore

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
                                    .strokeBorder(QPTheme.gold, lineWidth: 1.5)
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
