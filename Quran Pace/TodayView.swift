import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: QPStore
    @State private var showSetup = false
    @State private var showLogSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let plan = store.state.plan, plan.completedOn == nil {
                    activePlanContent(plan)
                } else if let plan = store.state.plan, plan.completedOn != nil {
                    sealedCard(plan)
                } else {
                    heroCard
                    startCard
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Today")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
        .sheet(isPresented: $showSetup) {
            KhatmSetupSheet()
                .environmentObject(store)
        }
        .sheet(isPresented: $showLogSheet) {
            ReadToSheet()
                .environmentObject(store)
        }
    }

    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            PaceArtImage(name: "hero-today")
                .frame(height: 210)
                .clipped()
            LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 3) {
                Text("Quran Pace")
                    .font(QPTheme.serif(26))
                    .foregroundColor(.white)
                Text("The logbook beside your mushaf")
                    .font(QPTheme.text(13))
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(16)
        }
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: QPTheme.corner, style: .continuous))
    }

    private var startCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No khatm underway")
                .font(QPTheme.serif(20))
                .foregroundColor(QPTheme.ink)
            Text("A khatm is a complete reading of the Quran, page by page. Pick a finish date or a daily portion, and this app keeps the honest arithmetic while you keep the reading.")
                .font(QPTheme.text(14))
                .foregroundColor(QPTheme.inkSoft)
                .lineSpacing(4)
            Button {
                showSetup = true
            } label: {
                HStack {
                    Spacer()
                    Text("Begin a khatm")
                        .font(QPTheme.text(15, .semibold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 13)
                .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
        .qpCard()
    }

    private func sealedCard(_ plan: KhatmPlan) -> some View {
        VStack(spacing: 14) {
            ZStack {
                MedallionRosette(tint: QPTheme.gold, petals: 12)
                    .frame(width: 110, height: 110)
                OctoStar()
                    .fill(QPTheme.gold)
                    .frame(width: 36, height: 36)
            }
            Text("This khatm is sealed")
                .font(QPTheme.serif(22))
                .foregroundColor(QPTheme.ink)
            Text("Completed \(QPStore.niceDate.string(from: plan.completedOn ?? Date())). It rests in your journal now.")
                .font(QPTheme.text(13))
                .foregroundColor(QPTheme.inkSoft)
                .multilineTextAlignment(.center)
            Button {
                store.closeCompletedKhatm()
                showSetup = true
            } label: {
                Text("Begin the next khatm")
                    .font(QPTheme.text(15, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
        .frame(maxWidth: .infinity)
        .qpCard(padding: 24)
    }

    @ViewBuilder
    private func activePlanContent(_ plan: KhatmPlan) -> some View {
        let report = store.pace()
        let page = min(QuranMap.totalPages, plan.position + 1)
        let juz = QuranMap.juz(forPage: page)
        let surah = QuranMap.surah(forPage: page)

        portionCard(report: report, plan: plan, juz: juz, surah: surah)
        logCard(report: report)
        paceCard(report: report, plan: plan)
        placeCard(plan: plan, juz: juz, surah: surah, page: page)
    }

    private func portionCard(report: PaceReport, plan: KhatmPlan, juz: Int, surah: SurahInfo) -> some View {
        let done = report.todayRead >= report.todayGoal
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                QPChip(text: "Today's portion", tint: QPTheme.indigo)
                Spacer()
                QPChip(
                    text: report.statusLine,
                    tint: report.statusKind == 0 ? QPTheme.rose : (report.statusKind == 2 ? QPTheme.sage : QPTheme.gold)
                )
            }
            HStack(alignment: .center, spacing: 18) {
                ZStack {
                    PaceRing(
                        progress: report.todayGoal > 0 ? Double(report.todayRead) / Double(report.todayGoal) : 0,
                        lineWidth: 9,
                        tint: done ? QPTheme.sage : QPTheme.indigo
                    )
                    .frame(width: 108, height: 108)
                    VStack(spacing: 0) {
                        Text("\(report.todayRead)")
                            .font(QPTheme.round(34))
                            .foregroundColor(QPTheme.ink)
                        Text("of \(report.todayGoal) pages")
                            .font(QPTheme.text(11))
                            .foregroundColor(QPTheme.inkFaint)
                    }
                }
                VStack(alignment: .leading, spacing: 7) {
                    if done {
                        Text("Portion complete")
                            .font(QPTheme.text(15, .semibold))
                            .foregroundColor(QPTheme.sage)
                        Text("Anything more today is pure gain on the plan.")
                            .font(QPTheme.text(12))
                            .foregroundColor(QPTheme.inkSoft)
                    } else {
                        Text("\(report.todayGoal - report.todayRead) pages to go")
                            .font(QPTheme.text(15, .semibold))
                            .foregroundColor(QPTheme.ink)
                        Text("Pages \(plan.position + 1)\u{2013}\(min(QuranMap.totalPages, plan.position + max(1, report.todayGoal - report.todayRead)))")
                            .font(QPTheme.text(12))
                            .foregroundColor(QPTheme.inkSoft)
                    }
                    Text("Juz \(juz) \u{00B7} \(surah.translit)")
                        .font(QPTheme.text(12, .medium))
                        .foregroundColor(QPTheme.gold)
                }
                Spacer(minLength: 0)
            }
        }
        .qpCard()
    }

    private func logCard(report: PaceReport) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Log your reading")
                .font(QPTheme.serif(16))
                .foregroundColor(QPTheme.ink)
            HStack(spacing: 8) {
                logButton("+1 page", pages: 1)
                logButton("+2", pages: 2)
                logButton("+5", pages: 5)
                Button {
                    showLogSheet = true
                } label: {
                    Text("I read to\u{2026}")
                        .font(QPTheme.text(13, .semibold))
                        .foregroundColor(QPTheme.indigo)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule().fill(QPTheme.indigoSoft.opacity(0.6))
                        )
                }
                .buttonStyle(PressScaleStyle())
            }
            if report.todayRead > 0 {
                Button {
                    store.logPages(-1)
                    QPHaptics.tap()
                } label: {
                    Text("Undo a page")
                        .font(QPTheme.text(12, .medium))
                        .foregroundColor(QPTheme.inkFaint)
                }
            }
        }
        .qpCard()
    }

    private func logButton(_ label: String, pages: Int) -> some View {
        Button {
            store.logPages(pages)
            QPHaptics.page()
        } label: {
            Text(label)
                .font(QPTheme.text(13, .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(QPTheme.indigo))
        }
        .buttonStyle(PressScaleStyle())
    }

    private func paceCard(report: PaceReport, plan: KhatmPlan) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("The whole khatm")
                    .font(QPTheme.serif(16))
                    .foregroundColor(QPTheme.ink)
                Spacer()
                Text("\(Int(report.percent * 100))%")
                    .font(QPTheme.round(16))
                    .foregroundColor(QPTheme.indigo)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(QPTheme.line.opacity(0.4))
                    Capsule()
                        .fill(QPTheme.indigo)
                        .frame(width: max(6, geo.size.width * CGFloat(report.percent)))
                }
            }
            .frame(height: 10)
            HStack {
                statCol("\(store.state.plan?.position ?? 0)", "pages read")
                Divider().frame(height: 30)
                statCol("\(report.remaining)", "remaining")
                Divider().frame(height: 30)
                statCol("\(store.streak)", "day streak")
            }
            if !report.targetLine.isEmpty || !report.forecastLine.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    if !report.targetLine.isEmpty {
                        Text(report.targetLine)
                            .font(QPTheme.text(12, .semibold))
                            .foregroundColor(QPTheme.gold)
                    }
                    if !report.forecastLine.isEmpty {
                        Text(report.forecastLine)
                            .font(QPTheme.text(12))
                            .foregroundColor(QPTheme.inkSoft)
                    }
                }
            }
        }
        .qpCard()
    }

    private func statCol(_ value: String, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(QPTheme.round(18))
                .foregroundColor(QPTheme.ink)
            Text(label)
                .font(QPTheme.text(10))
                .foregroundColor(QPTheme.inkFaint)
        }
        .frame(maxWidth: .infinity)
    }

    private func placeCard(plan: KhatmPlan, juz: Int, surah: SurahInfo, page: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Where your bookmark stands")
                .font(QPTheme.serif(16))
                .foregroundColor(QPTheme.ink)
            HStack(spacing: 12) {
                ZStack {
                    MedallionRosette(tint: QPTheme.gold, petals: 8)
                        .frame(width: 58, height: 58)
                    Text("\(juz)")
                        .font(QPTheme.round(20))
                        .foregroundColor(QPTheme.ink)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Juz \(juz) \u{00B7} \(QuranMap.juzOpenings[juz - 1])")
                        .font(QPTheme.text(14, .semibold))
                        .foregroundColor(QPTheme.ink)
                    HStack(spacing: 6) {
                        Text("Next page: \(page), in \(surah.translit)")
                            .font(QPTheme.text(12))
                            .foregroundColor(QPTheme.inkSoft)
                        if store.state.showArabicNames {
                            Text(surah.arabic)
                                .font(QPTheme.arabic(14))
                                .foregroundColor(QPTheme.indigo)
                        }
                    }
                }
                Spacer()
                Button {
                    store.activeTab = 1
                } label: {
                    QPArrow(size: 14)
                }
            }
        }
        .qpCard()
    }
}

struct ReadToSheet: View {
    @EnvironmentObject var store: QPStore
    @Environment(\.presentationMode) var presentation
    @State private var page: Double = 0

    var body: some View {
        VStack(spacing: 18) {
            Capsule().fill(QPTheme.line).frame(width: 44, height: 5).padding(.top, 10)
            Text("I read to page\u{2026}")
                .font(QPTheme.serif(22))
                .foregroundColor(QPTheme.ink)
            let current = store.state.plan?.position ?? 0
            let p = Int(page)
            let juz = QuranMap.juz(forPage: max(1, p))
            let surah = QuranMap.surah(forPage: max(1, p))
            VStack(spacing: 6) {
                Text("\(p)")
                    .font(QPTheme.round(52))
                    .foregroundColor(QPTheme.indigo)
                Text(p > 0 ? "Juz \(juz) \u{00B7} \(surah.translit)" : "Nothing read yet")
                    .font(QPTheme.text(13))
                    .foregroundColor(QPTheme.inkSoft)
                if p > current {
                    QPChip(text: "+\(p - current) pages today", tint: QPTheme.sage)
                } else if p < current {
                    QPChip(text: "Moves the bookmark back", tint: QPTheme.rose)
                }
            }
            Slider(value: $page, in: 0...Double(QuranMap.totalPages), step: 1)
                .accentColor(QPTheme.indigo)
                .padding(.horizontal, 24)
            HStack(spacing: 10) {
                ForEach([-5, -1, 1, 5], id: \.self) { d in
                    Button {
                        page = min(Double(QuranMap.totalPages), max(0, page + Double(d)))
                        QPHaptics.tap()
                    } label: {
                        Text(d > 0 ? "+\(d)" : "\(d)")
                            .font(QPTheme.text(14, .semibold))
                            .foregroundColor(QPTheme.indigo)
                            .frame(width: 56, height: 38)
                            .background(Capsule().fill(QPTheme.indigoSoft.opacity(0.6)))
                    }
                    .buttonStyle(PressScaleStyle())
                }
            }
            Button {
                store.setPosition(Int(page))
                QPHaptics.milestone()
                presentation.wrappedValue.dismiss()
            } label: {
                Text("Set bookmark")
                    .font(QPTheme.text(15, .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 320)
                    .padding(.vertical, 13)
                    .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(QPTheme.paper.ignoresSafeArea())
        .onAppear {
            page = Double(store.state.plan?.position ?? 0)
        }
    }
}

struct KhatmSetupSheet: View {
    @EnvironmentObject var store: QPStore
    @Environment(\.presentationMode) var presentation
    @State private var mode: KhatmMode = .byDate
    @State private var targetDate = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
    @State private var pagesPerDay: Double = 4
    @State private var startPage: Double = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Capsule().fill(QPTheme.line).frame(width: 44, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                Text("Begin a khatm")
                    .font(QPTheme.serif(24))
                    .foregroundColor(QPTheme.ink)
                    .frame(maxWidth: .infinity)
                HStack(spacing: 8) {
                    modeButton("By a date", .byDate)
                    modeButton("Pages a day", .perDay)
                }
                if mode == .byDate {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Finish by")
                            .font(QPTheme.text(13, .semibold))
                            .foregroundColor(QPTheme.inkSoft)
                        DatePicker(
                            "Finish by",
                            selection: $targetDate,
                            in: Date().addingTimeInterval(86400)...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .accentColor(QPTheme.indigo)
                        let days = max(1, (Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: targetDate)).day ?? 1) + 1)
                        let need = Int(ceil(Double(QuranMap.totalPages - Int(startPage)) / Double(days)))
                        QPChip(text: "About \(need) pages a day", tint: QPTheme.gold)
                    }
                    .qpCard()
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily portion: \(Int(pagesPerDay)) pages")
                            .font(QPTheme.text(14, .semibold))
                            .foregroundColor(QPTheme.ink)
                        Slider(value: $pagesPerDay, in: 1...30, step: 1)
                            .accentColor(QPTheme.indigo)
                        let days = Int(ceil(Double(QuranMap.totalPages - Int(startPage)) / pagesPerDay))
                        if let eta = Calendar.current.date(byAdding: .day, value: days, to: Date()) {
                            QPChip(text: "Finishes about \(QPStore.niceDate.string(from: eta))", tint: QPTheme.gold)
                        }
                    }
                    .qpCard()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Starting from page \(Int(startPage))")
                        .font(QPTheme.text(14, .semibold))
                        .foregroundColor(QPTheme.ink)
                    Text(Int(startPage) == 0 ? "The very beginning" : "Juz \(QuranMap.juz(forPage: max(1, Int(startPage)))) \u{00B7} \(QuranMap.surah(forPage: max(1, Int(startPage))).translit)")
                        .font(QPTheme.text(12))
                        .foregroundColor(QPTheme.inkSoft)
                    Slider(value: $startPage, in: 0...Double(QuranMap.totalPages - 1), step: 1)
                        .accentColor(QPTheme.indigo)
                }
                .qpCard()
                Button {
                    store.startKhatm(
                        mode: mode,
                        targetDate: mode == .byDate ? targetDate : nil,
                        pagesPerDay: Int(pagesPerDay),
                        startingAt: Int(startPage)
                    )
                    QPHaptics.success()
                    presentation.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Start reading")
                            .font(QPTheme.text(16, .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(Capsule().fill(QPTheme.indigo))
                }
                .buttonStyle(PressScaleStyle())
            }
            .padding(18)
            .padding(.bottom, 16)
        }
        .background(QPTheme.paper.ignoresSafeArea())
    }

    private func modeButton(_ label: String, _ m: KhatmMode) -> some View {
        Button {
            mode = m
            QPHaptics.tap()
        } label: {
            Text(label)
                .font(QPTheme.text(14, .semibold))
                .foregroundColor(mode == m ? .white : QPTheme.indigo)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Capsule().fill(mode == m ? QPTheme.indigo : QPTheme.indigoSoft.opacity(0.6)))
        }
        .buttonStyle(PressScaleStyle())
    }
}
