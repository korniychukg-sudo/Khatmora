import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: QPStore
    @State private var showSetup = false
    @State private var showLogSheet = false
    @State private var showSitting = false

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
        .fullScreenCover(isPresented: $showSitting) {
            SittingView()
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

        LivingHero(percent: report.percent)
        portionCard(report: report, plan: plan, juz: juz, surah: surah)
        sittingCard(report: report)
        logCard(report: report)
        paceCard(report: report, plan: plan)
        placeCard(plan: plan, juz: juz, surah: surah, page: page)
    }

    private func sittingCard(report: PaceReport) -> some View {
        Button {
            showSitting = true
            QPHaptics.tap()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(QPTheme.goldSoft.opacity(0.5)).frame(width: 46, height: 46)
                    TodayTabIcon(size: 24, color: QPTheme.gold)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Begin a sitting")
                        .font(QPTheme.serif(17))
                        .foregroundColor(QPTheme.ink)
                    Text(sittingSubtitle(report: report))
                        .font(QPTheme.text(12))
                        .foregroundColor(QPTheme.inkSoft)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
                QPArrow()
            }
            .qpCard(padding: 13)
        }
        .buttonStyle(PressScaleStyle())
    }

    private func sittingSubtitle(report: PaceReport) -> String {
        if let mpp = store.minutesPerPage {
            let left = max(0, report.todayGoal - report.todayRead)
            if left > 0 {
                let mins = max(1, Int((Double(left) * mpp).rounded()))
                return "Today's \(left) page\(left == 1 ? "" : "s") \u{2248} \(mins) min at your pace"
            }
            return "Portion done — read on, the clock still counts"
        }
        return "Time your reading; the app learns your pace"
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
                        Text("\(report.todayGoal - report.todayRead) page\(report.todayGoal - report.todayRead == 1 ? "" : "s") to go")
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
            if !report.targetLine.isEmpty || !report.forecastLine.isEmpty || store.minutesPerPage != nil {
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
                    if let mpp = store.minutesPerPage {
                        Text(String(format: "Your reading pace: %.1f min a page", mpp))
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
                VStack(alignment: .leading, spacing: 8) {
                    Text("Common paces")
                        .font(QPTheme.text(12, .semibold))
                        .foregroundColor(QPTheme.inkFaint)
                    HStack(spacing: 7) {
                        presetChip("A juz a day") {
                            mode = .perDay
                            pagesPerDay = 20
                        }
                        presetChip("In 30 days") {
                            mode = .byDate
                            targetDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? targetDate
                        }
                        presetChip("In 60 days") {
                            mode = .byDate
                            targetDate = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? targetDate
                        }
                        presetChip("2 a day") {
                            mode = .perDay
                            pagesPerDay = 2
                        }
                    }
                }
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

    private func presetChip(_ label: String, apply: @escaping () -> Void) -> some View {
        Button {
            apply()
            QPHaptics.tap()
        } label: {
            Text(label)
                .font(QPTheme.text(11, .semibold))
                .foregroundColor(QPTheme.gold)
                .padding(.horizontal, 9)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(QPTheme.goldSoft.opacity(0.4)))
                .overlay(Capsule().strokeBorder(QPTheme.gold.opacity(0.4), lineWidth: 1))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .buttonStyle(PressScaleStyle())
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

struct LivingHero: View {
    let percent: Double

    var body: some View {
        TimelineView(.periodic(from: .now, by: 30)) { timeline in
            Canvas { ctx, size in
                drawScene(ctx: ctx, size: size, date: timeline.date)
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: QPTheme.corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: QPTheme.corner, style: .continuous)
                .strokeBorder(QPTheme.line, lineWidth: 1)
        )
    }

    private func drawScene(ctx: GraphicsContext, size: CGSize, date: Date) {
        let cal = Calendar.current
        let hour = Double(cal.component(.hour, from: date)) + Double(cal.component(.minute, from: date)) / 60.0
        let night = hour < 5.0 || hour >= 20.0
        let dawnDusk = (hour >= 5.0 && hour < 7.5) || (hour >= 17.0 && hour < 20.0)

        let top: Color = night
            ? Color(qpHex: 0x1F2740)
            : (dawnDusk ? Color(qpHex: 0x9A8FAE) : Color(qpHex: 0xA9BFCB))
        let bottom: Color = night
            ? Color(qpHex: 0x3C3A55)
            : (dawnDusk ? Color(qpHex: 0xE8B579) : Color(qpHex: 0xEFE4C2))
        ctx.fill(
            Path(CGRect(origin: .zero, size: size)),
            with: .linearGradient(
                Gradient(colors: [top, bottom]),
                startPoint: .zero,
                endPoint: CGPoint(x: 0, y: size.height)
            )
        )

        if night {
            for i in 0..<22 {
                let sx = Double((i * 2654435761) % 1000) / 1000.0
                let sy = Double((i * 40503 + 131) % 1000) / 1000.0
                let s: CGFloat = 1.0 + CGFloat(sy) * 1.6
                ctx.fill(
                    Path(ellipseIn: CGRect(x: sx * size.width, y: sy * size.height * 0.5, width: s, height: s)),
                    with: .color(QPTheme.goldSoft.opacity(0.5 + 0.4 * sx))
                )
            }
            let mc = CGPoint(x: size.width * 0.82, y: size.height * 0.26)
            var moon = Path()
            moon.addArc(center: mc, radius: 13, startAngle: .degrees(-50), endAngle: .degrees(130), clockwise: false)
            moon.addQuadCurve(
                to: CGPoint(x: mc.x + cos(-50 * .pi / 180) * 13, y: mc.y + sin(-50 * .pi / 180) * 13),
                control: CGPoint(x: mc.x + 5, y: mc.y + 3)
            )
            ctx.fill(moon, with: .color(QPTheme.goldSoft.opacity(0.85)))
        } else {
            let t = min(1, max(0, (hour - 6.0) / 14.0))
            let a = CGFloat(.pi * (1.0 - t))
            let sc = CGPoint(
                x: size.width * 0.5 + cos(a) * size.width * 0.42,
                y: size.height * 0.42 - sin(a) * size.height * 0.26
            )
            ctx.fill(
                Path(ellipseIn: CGRect(x: sc.x - 12, y: sc.y - 12, width: 24, height: 24)),
                with: .color(QPTheme.goldSoft.opacity(0.9))
            )
            for i in 0..<12 {
                let ra = CGFloat(i) * .pi / 6
                var ray = Path()
                ray.move(to: CGPoint(x: sc.x + cos(ra) * 16, y: sc.y + sin(ra) * 16))
                ray.addLine(to: CGPoint(x: sc.x + cos(ra) * 22, y: sc.y + sin(ra) * 22))
                ctx.stroke(ray, with: .color(QPTheme.gold.opacity(0.5)), lineWidth: 1.2)
            }
        }

        let baseY = size.height * 0.86
        var sil = Path()
        sil.move(to: CGPoint(x: 0, y: size.height))
        sil.addLine(to: CGPoint(x: 0, y: baseY))
        var x: CGFloat = 0
        var i = 0
        while x < size.width {
            let w = size.width * 0.14
            if i % 3 == 1 {
                sil.addLine(to: CGPoint(x: x + w * 0.2, y: baseY))
                sil.addQuadCurve(
                    to: CGPoint(x: x + w * 0.8, y: baseY),
                    control: CGPoint(x: x + w * 0.5, y: baseY - w * 0.6)
                )
            } else if i % 3 == 2 {
                sil.addLine(to: CGPoint(x: x + w * 0.44, y: baseY))
                sil.addLine(to: CGPoint(x: x + w * 0.5, y: baseY - w * 0.72))
                sil.addLine(to: CGPoint(x: x + w * 0.56, y: baseY))
            } else {
                sil.addLine(to: CGPoint(x: x + w, y: baseY))
            }
            x += w
            i += 1
        }
        sil.addLine(to: CGPoint(x: size.width, y: baseY))
        sil.addLine(to: CGPoint(x: size.width, y: size.height))
        sil.closeSubpath()
        ctx.fill(sil, with: .color((night ? Color(qpHex: 0x11172A) : QPTheme.indigoDeep).opacity(night ? 0.85 : 0.5)))

        let bw = size.width * 0.42
        let bh = bw * 0.3
        let bc = CGPoint(x: size.width * 0.5, y: size.height * 0.66)
        var leg1 = Path()
        leg1.move(to: CGPoint(x: bc.x - bw * 0.18, y: bc.y + bh * 0.9))
        leg1.addLine(to: CGPoint(x: bc.x + bw * 0.18, y: bc.y + bh * 0.34))
        var leg2 = Path()
        leg2.move(to: CGPoint(x: bc.x + bw * 0.18, y: bc.y + bh * 0.9))
        leg2.addLine(to: CGPoint(x: bc.x - bw * 0.18, y: bc.y + bh * 0.34))
        ctx.stroke(leg1, with: .color(Color(qpHex: 0x6E4A2B).opacity(0.95)), style: StrokeStyle(lineWidth: 5, lineCap: .round))
        ctx.stroke(leg2, with: .color(Color(qpHex: 0x6E4A2B).opacity(0.95)), style: StrokeStyle(lineWidth: 5, lineCap: .round))

        func pagePath(right: Bool) -> Path {
            var p = Path()
            let s: CGFloat = right ? 1 : -1
            p.move(to: CGPoint(x: bc.x, y: bc.y + bh * 0.36))
            p.addQuadCurve(
                to: CGPoint(x: bc.x + s * bw / 2, y: bc.y + bh * 0.5),
                control: CGPoint(x: bc.x + s * bw * 0.26, y: bc.y + bh * 0.62)
            )
            p.addLine(to: CGPoint(x: bc.x + s * bw / 2, y: bc.y - bh * 0.46))
            p.addQuadCurve(
                to: CGPoint(x: bc.x, y: bc.y - bh * 0.34),
                control: CGPoint(x: bc.x + s * bw * 0.26, y: bc.y - bh * 0.36)
            )
            p.closeSubpath()
            return p
        }
        let paperCol = Color(qpHex: 0xFCF8EC)
        ctx.fill(pagePath(right: false), with: .color(paperCol))
        ctx.fill(pagePath(right: true), with: .color(paperCol))
        ctx.stroke(pagePath(right: false), with: .color(QPTheme.ink.opacity(0.75)), lineWidth: 2)
        ctx.stroke(pagePath(right: true), with: .color(QPTheme.ink.opacity(0.75)), lineWidth: 2)

        var inner = ctx
        inner.clip(to: pagePath(right: false))
        let fillH = bh * 0.8 * CGFloat(min(1, max(0, percent)))
        inner.fill(
            Path(CGRect(x: bc.x - bw / 2, y: bc.y + bh * 0.5 - fillH, width: bw / 2, height: fillH)),
            with: .color(QPTheme.indigo.opacity(0.35))
        )
        for k in 0..<5 {
            let y = bc.y - bh * 0.22 + CGFloat(k) * bh * 0.13
            var l1 = Path()
            l1.move(to: CGPoint(x: bc.x - bw * 0.4, y: y + 2))
            l1.addLine(to: CGPoint(x: bc.x - bw * 0.08, y: y))
            var l2 = Path()
            l2.move(to: CGPoint(x: bc.x + bw * 0.08, y: y))
            l2.addLine(to: CGPoint(x: bc.x + bw * 0.4, y: y + 2))
            ctx.stroke(l1, with: .color(QPTheme.indigo.opacity(0.4)), lineWidth: 1)
            ctx.stroke(l2, with: .color(QPTheme.indigo.opacity(0.4)), lineWidth: 1)
        }

        let label = Text("\(Int(min(1, max(0, percent)) * 100))% of the mushaf")
            .font(QPTheme.text(11, .semibold))
            .foregroundColor(night ? QPTheme.goldSoft : QPTheme.indigoDeep)
        ctx.draw(ctx.resolve(label), at: CGPoint(x: size.width * 0.5, y: size.height * 0.12), anchor: .center)
    }
}

struct SittingView: View {
    @EnvironmentObject var store: QPStore
    @Environment(\.presentationMode) var presentation
    @State private var started = Date()
    @State private var ended: Date? = nil
    @State private var pages = 0

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .font(QPTheme.text(14, .semibold))
                        .foregroundColor(QPTheme.inkFaint)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            Spacer()
            if let ended = ended {
                closingView(ended: ended)
            } else {
                runningView
            }
            Spacer()
        }
        .background(QPTheme.paper.ignoresSafeArea())
        .onAppear {
            started = Date()
            let report = store.pace()
            pages = max(0, report.todayGoal - report.todayRead)
        }
    }

    private var runningView: some View {
        VStack(spacing: 26) {
            Text("A sitting with the mushaf")
                .font(QPTheme.serif(22))
                .foregroundColor(QPTheme.ink)
            TimelineView(.periodic(from: .now, by: 1)) { timeline in
                let elapsed = max(0, Int(timeline.date.timeIntervalSince(started)))
                let breathe = 1.0 + 0.03 * sin(timeline.date.timeIntervalSinceReferenceDate * 0.8)
                ZStack {
                    Circle()
                        .stroke(QPTheme.indigoSoft, lineWidth: 10)
                        .frame(width: 190, height: 190)
                        .scaleEffect(breathe)
                    Circle()
                        .stroke(QPTheme.gold.opacity(0.35), lineWidth: 2)
                        .frame(width: 220, height: 220)
                        .scaleEffect(2.0 - breathe)
                    VStack(spacing: 2) {
                        Text(String(format: "%d:%02d", elapsed / 60, elapsed % 60))
                            .font(QPTheme.round(44))
                            .foregroundColor(QPTheme.ink)
                        Text("reading")
                            .font(QPTheme.text(12))
                            .foregroundColor(QPTheme.inkFaint)
                    }
                }
            }
            let page = min(QuranMap.totalPages, (store.state.plan?.position ?? 0) + 1)
            Text("Bookmark at page \(page) \u{00B7} Juz \(QuranMap.juz(forPage: page)) \u{00B7} \(QuranMap.surah(forPage: page).translit)")
                .font(QPTheme.text(13))
                .foregroundColor(QPTheme.inkSoft)
            Text("Put the phone down and read. Come back when the sitting ends.")
                .font(QPTheme.text(12))
                .foregroundColor(QPTheme.inkFaint)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                ended = Date()
                QPHaptics.milestone()
            } label: {
                Text("End the sitting")
                    .font(QPTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 13)
                    .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
    }

    private func closingView(ended: Date) -> some View {
        let mins = max(1, Int(ended.timeIntervalSince(started) / 60))
        return VStack(spacing: 20) {
            Text("How far did you get?")
                .font(QPTheme.serif(23))
                .foregroundColor(QPTheme.ink)
            QPChip(text: mins == 1 ? "1 minute of reading" : "\(mins) minutes of reading", tint: QPTheme.gold)
            HStack(spacing: 22) {
                stepButton("-") { pages = max(0, pages - 1) }
                VStack(spacing: 0) {
                    Text("\(pages)")
                        .font(QPTheme.round(52))
                        .foregroundColor(QPTheme.indigo)
                    Text(pages == 1 ? "page" : "pages")
                        .font(QPTheme.text(12))
                        .foregroundColor(QPTheme.inkFaint)
                }
                .frame(width: 110)
                stepButton("+") { pages = min(QuranMap.totalPages, pages + 1) }
            }
            Button {
                store.recordSitting(minutes: mins, pages: pages)
                QPHaptics.success()
                presentation.wrappedValue.dismiss()
            } label: {
                Text(pages > 0 ? "Log \(pages) page\(pages == 1 ? "" : "s")" : "Log the time only")
                    .font(QPTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 13)
                    .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
    }

    private func stepButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
            QPHaptics.tap()
        } label: {
            Text(label)
                .font(QPTheme.round(26))
                .foregroundColor(QPTheme.indigo)
                .frame(width: 56, height: 56)
                .background(Circle().fill(QPTheme.indigoSoft.opacity(0.6)))
        }
        .buttonStyle(PressScaleStyle())
    }
}
