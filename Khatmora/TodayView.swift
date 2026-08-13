import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: KHStore
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
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Hoy")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
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
            KhatmoraArtImage(name: "hero-today")
                .frame(height: 210)
                .clipped()
            LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 3) {
                Text("Khatmora")
                    .font(KHTheme.serif(26))
                    .foregroundColor(.white)
                Text("El cuaderno junto a tu mushaf")
                    .font(KHTheme.text(13))
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(16)
        }
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: KHTheme.corner, style: .continuous))
    }

    private var startCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No hay ningún jatm en curso")
                .font(KHTheme.serif(20))
                .foregroundColor(KHTheme.ink)
            Text("Un jatm es una lectura completa del Corán, página a página. Elige una fecha final o una porción diaria; la app se ocupa de las cuentas mientras tú te ocupas de leer.")
                .font(KHTheme.text(14))
                .foregroundColor(KHTheme.inkSoft)
                .lineSpacing(4)
            Button {
                showSetup = true
            } label: {
                HStack {
                    Spacer()
                    Text("Comenzar un jatm")
                        .font(KHTheme.text(15, .semibold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 13)
                .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
        .qpCard()
    }

    private func sealedCard(_ plan: KhatmPlan) -> some View {
        VStack(spacing: 14) {
            ZStack {
                MedallionRosette(tint: KHTheme.gold, petals: 12)
                    .frame(width: 110, height: 110)
                OctoStar()
                    .fill(KHTheme.gold)
                    .frame(width: 36, height: 36)
            }
            Text("Este jatm está completado")
                .font(KHTheme.serif(22))
                .foregroundColor(KHTheme.ink)
            Text("Completado el \(KHStore.niceDate.string(from: plan.completedOn ?? Date())). Ahora queda guardado en tu diario.")
                .font(KHTheme.text(13))
                .foregroundColor(KHTheme.inkSoft)
                .multilineTextAlignment(.center)
            Button {
                store.closeCompletedKhatm()
                showSetup = true
            } label: {
                Text("Comenzar el siguiente jatm")
                    .font(KHTheme.text(15, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(KHTheme.indigo))
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

    private func sittingCard(report: KhatmoraReport) -> some View {
        Button {
            showSitting = true
            KHHaptics.tap()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(KHTheme.goldSoft.opacity(0.5)).frame(width: 46, height: 46)
                    TodayTabIcon(size: 24, color: KHTheme.gold)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Comenzar una sesión")
                        .font(KHTheme.serif(17))
                        .foregroundColor(KHTheme.ink)
                    Text(sittingSubtitle(report: report))
                        .font(KHTheme.text(12))
                        .foregroundColor(KHTheme.inkSoft)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
                KHArrow()
            }
            .qpCard(padding: 13)
        }
        .buttonStyle(PressScaleStyle())
    }

    private func sittingSubtitle(report: KhatmoraReport) -> String {
        if let mpp = store.minutesPerPage {
            let left = max(0, report.todayGoal - report.todayRead)
            if left > 0 {
                let mins = max(1, Int((Double(left) * mpp).rounded()))
                return "Hoy: \(left) página\(left == 1 ? "" : "s") ≈ \(mins) min a tu ritmo"
            }
            return "Porción completada: puedes seguir leyendo"
        }
        return "Cronometra la lectura; la app aprende tu ritmo"
    }

    private func portionCard(report: KhatmoraReport, plan: KhatmPlan, juz: Int, surah: SurahInfo) -> some View {
        let done = report.todayRead >= report.todayGoal
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                KHChip(text: "Porción de hoy", tint: KHTheme.indigo)
                Spacer()
                KHChip(
                    text: report.statusLine,
                    tint: report.statusKind == 0 ? KHTheme.rose : (report.statusKind == 2 ? KHTheme.sage : KHTheme.gold)
                )
            }
            HStack(alignment: .center, spacing: 18) {
                ZStack {
                    KhatmoraRing(
                        progress: report.todayGoal > 0 ? Double(report.todayRead) / Double(report.todayGoal) : 0,
                        lineWidth: 9,
                        tint: done ? KHTheme.sage : KHTheme.indigo
                    )
                    .frame(width: 108, height: 108)
                    VStack(spacing: 0) {
                        Text("\(report.todayRead)")
                            .font(KHTheme.round(34))
                            .foregroundColor(KHTheme.ink)
                        Text("de \(report.todayGoal) páginas")
                            .font(KHTheme.text(11))
                            .foregroundColor(KHTheme.inkFaint)
                    }
                }
                VStack(alignment: .leading, spacing: 7) {
                    if done {
                        Text("Porción completada")
                            .font(KHTheme.text(15, .semibold))
                            .foregroundColor(KHTheme.sage)
                        Text("Todo lo que leas de más hoy será un avance adicional.")
                            .font(KHTheme.text(12))
                            .foregroundColor(KHTheme.inkSoft)
                    } else {
                        Text("Quedan \(report.todayGoal - report.todayRead) página\(report.todayGoal - report.todayRead == 1 ? "" : "s")")
                            .font(KHTheme.text(15, .semibold))
                            .foregroundColor(KHTheme.ink)
                        Text("Páginas \(plan.position + 1)–\(min(QuranMap.totalPages, plan.position + max(1, report.todayGoal - report.todayRead)))")
                            .font(KHTheme.text(12))
                            .foregroundColor(KHTheme.inkSoft)
                    }
                    Text("Yuz \(juz) · \(surah.translit)")
                        .font(KHTheme.text(12, .medium))
                        .foregroundColor(KHTheme.gold)
                }
                Spacer(minLength: 0)
            }
        }
        .qpCard()
    }

    private func logCard(report: KhatmoraReport) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Registrar la lectura")
                .font(KHTheme.serif(16))
                .foregroundColor(KHTheme.ink)
            HStack(spacing: 8) {
                logButton("+1 pág.", pages: 1)
                logButton("+2", pages: 2)
                logButton("+5", pages: 5)
                Button {
                    showLogSheet = true
                } label: {
                    Text("He leído hasta…")
                        .font(KHTheme.text(13, .semibold))
                        .foregroundColor(KHTheme.indigo)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule().fill(KHTheme.indigoSoft.opacity(0.6))
                        )
                }
                .buttonStyle(PressScaleStyle())
            }
            if report.todayRead > 0 {
                Button {
                    store.logPages(-1)
                    KHHaptics.tap()
                } label: {
                    Text("Deshacer una página")
                        .font(KHTheme.text(12, .medium))
                        .foregroundColor(KHTheme.inkFaint)
                }
            }
        }
        .qpCard()
    }

    private func logButton(_ label: String, pages: Int) -> some View {
        Button {
            store.logPages(pages)
            KHHaptics.page()
        } label: {
            Text(label)
                .font(KHTheme.text(13, .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(KHTheme.indigo))
        }
        .buttonStyle(PressScaleStyle())
    }

    private func paceCard(report: KhatmoraReport, plan: KhatmPlan) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("El jatm completo")
                    .font(KHTheme.serif(16))
                    .foregroundColor(KHTheme.ink)
                Spacer()
                Text("\(Int(report.percent * 100))%")
                    .font(KHTheme.round(16))
                    .foregroundColor(KHTheme.indigo)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(KHTheme.line.opacity(0.4))
                    Capsule()
                        .fill(KHTheme.indigo)
                        .frame(width: max(6, geo.size.width * CGFloat(report.percent)))
                }
            }
            .frame(height: 10)
            HStack {
                statCol("\(store.state.plan?.position ?? 0)", "páginas leídas")
                Divider().frame(height: 30)
                statCol("\(report.remaining)", "restantes")
                Divider().frame(height: 30)
                statCol("\(store.streak)", "días de racha")
            }
            if !report.targetLine.isEmpty || !report.forecastLine.isEmpty || store.minutesPerPage != nil {
                VStack(alignment: .leading, spacing: 3) {
                    if !report.targetLine.isEmpty {
                        Text(report.targetLine)
                            .font(KHTheme.text(12, .semibold))
                            .foregroundColor(KHTheme.gold)
                    }
                    if !report.forecastLine.isEmpty {
                        Text(report.forecastLine)
                            .font(KHTheme.text(12))
                            .foregroundColor(KHTheme.inkSoft)
                    }
                    if let mpp = store.minutesPerPage {
                        Text(String(format: "Tu ritmo: %.1f min por página", mpp))
                            .font(KHTheme.text(12))
                            .foregroundColor(KHTheme.inkSoft)
                    }
                }
            }
        }
        .qpCard()
    }

    private func statCol(_ value: String, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(KHTheme.round(18))
                .foregroundColor(KHTheme.ink)
            Text(label)
                .font(KHTheme.text(10))
                .foregroundColor(KHTheme.inkFaint)
        }
        .frame(maxWidth: .infinity)
    }

    private func placeCard(plan: KhatmPlan, juz: Int, surah: SurahInfo, page: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Dónde está tu marcador")
                .font(KHTheme.serif(16))
                .foregroundColor(KHTheme.ink)
            HStack(spacing: 12) {
                ZStack {
                    MedallionRosette(tint: KHTheme.gold, petals: 8)
                        .frame(width: 58, height: 58)
                    Text("\(juz)")
                        .font(KHTheme.round(20))
                        .foregroundColor(KHTheme.ink)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Yuz \(juz) · \(QuranMap.juzOpenings[juz - 1])")
                        .font(KHTheme.text(14, .semibold))
                        .foregroundColor(KHTheme.ink)
                    HStack(spacing: 6) {
                        Text("Siguiente página: \(page), en \(surah.translit)")
                            .font(KHTheme.text(12))
                            .foregroundColor(KHTheme.inkSoft)
                        if store.state.showArabicNames {
                            Text(surah.arabic)
                                .font(KHTheme.arabic(14))
                                .foregroundColor(KHTheme.indigo)
                        }
                    }
                }
                Spacer()
                Button {
                    store.activeTab = 1
                } label: {
                    KHArrow(size: 14)
                }
            }
        }
        .qpCard()
    }
}

struct ReadToSheet: View {
    @EnvironmentObject var store: KHStore
    @Environment(\.presentationMode) var presentation
    @State private var page: Double = 0

    var body: some View {
        VStack(spacing: 18) {
            Capsule().fill(KHTheme.line).frame(width: 44, height: 5).padding(.top, 10)
            Text("He leído hasta la página…")
                .font(KHTheme.serif(22))
                .foregroundColor(KHTheme.ink)
            let current = store.state.plan?.position ?? 0
            let p = Int(page)
            let juz = QuranMap.juz(forPage: max(1, p))
            let surah = QuranMap.surah(forPage: max(1, p))
            VStack(spacing: 6) {
                Text("\(p)")
                    .font(KHTheme.round(52))
                    .foregroundColor(KHTheme.indigo)
                Text(p > 0 ? "Yuz \(juz) · \(surah.translit)" : "Aún no has leído nada")
                    .font(KHTheme.text(13))
                    .foregroundColor(KHTheme.inkSoft)
                if p > current {
                    KHChip(text: "+\(p - current) páginas hoy", tint: KHTheme.sage)
                } else if p < current {
                    KHChip(text: "Mueve el marcador hacia atrás", tint: KHTheme.rose)
                }
            }
            Slider(value: $page, in: 0...Double(QuranMap.totalPages), step: 1)
                .accentColor(KHTheme.indigo)
                .padding(.horizontal, 24)
            HStack(spacing: 10) {
                ForEach([-5, -1, 1, 5], id: \.self) { d in
                    Button {
                        page = min(Double(QuranMap.totalPages), max(0, page + Double(d)))
                        KHHaptics.tap()
                    } label: {
                        Text(d > 0 ? "+\(d)" : "\(d)")
                            .font(KHTheme.text(14, .semibold))
                            .foregroundColor(KHTheme.indigo)
                            .frame(width: 56, height: 38)
                            .background(Capsule().fill(KHTheme.indigoSoft.opacity(0.6)))
                    }
                    .buttonStyle(PressScaleStyle())
                }
            }
            Button {
                store.setPosition(Int(page))
                KHHaptics.milestone()
                presentation.wrappedValue.dismiss()
            } label: {
                Text("Colocar marcador")
                    .font(KHTheme.text(15, .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 320)
                    .padding(.vertical, 13)
                    .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(KHTheme.paper.ignoresSafeArea())
        .onAppear {
            page = Double(store.state.plan?.position ?? 0)
        }
    }
}

struct KhatmSetupSheet: View {
    @EnvironmentObject var store: KHStore
    @Environment(\.presentationMode) var presentation
    @State private var mode: KhatmMode = .byDate
    @State private var targetDate = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
    @State private var pagesPerDay: Double = 4
    @State private var startPage: Double = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Capsule().fill(KHTheme.line).frame(width: 44, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                Text("Comenzar un jatm")
                    .font(KHTheme.serif(24))
                    .foregroundColor(KHTheme.ink)
                    .frame(maxWidth: .infinity)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ritmos habituales")
                        .font(KHTheme.text(12, .semibold))
                        .foregroundColor(KHTheme.inkFaint)
                    HStack(spacing: 7) {
                        presetChip("Un yuz al día") {
                            mode = .perDay
                            pagesPerDay = 20
                        }
                        presetChip("En 30 días") {
                            mode = .byDate
                            targetDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? targetDate
                        }
                        presetChip("En 60 días") {
                            mode = .byDate
                            targetDate = Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? targetDate
                        }
                        presetChip("2 al día") {
                            mode = .perDay
                            pagesPerDay = 2
                        }
                    }
                }
                HStack(spacing: 8) {
                    modeButton("Por fecha", .byDate)
                    modeButton("Páginas al día", .perDay)
                }
                if mode == .byDate {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Terminar el")
                            .font(KHTheme.text(13, .semibold))
                            .foregroundColor(KHTheme.inkSoft)
                        DatePicker(
                            "Terminar el",
                            selection: $targetDate,
                            in: Date().addingTimeInterval(86400)...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .accentColor(KHTheme.indigo)
                        let days = max(1, (Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: targetDate)).day ?? 1) + 1)
                        let need = Int(ceil(Double(QuranMap.totalPages - Int(startPage)) / Double(days)))
                        KHChip(text: "Unas \(need) páginas al día", tint: KHTheme.gold)
                    }
                    .qpCard()
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Porción diaria: \(Int(pagesPerDay)) páginas")
                            .font(KHTheme.text(14, .semibold))
                            .foregroundColor(KHTheme.ink)
                        Slider(value: $pagesPerDay, in: 1...30, step: 1)
                            .accentColor(KHTheme.indigo)
                        let days = Int(ceil(Double(QuranMap.totalPages - Int(startPage)) / pagesPerDay))
                        if let eta = Calendar.current.date(byAdding: .day, value: days, to: Date()) {
                            KHChip(text: "Termina aproximadamente el \(KHStore.niceDate.string(from: eta))", tint: KHTheme.gold)
                        }
                    }
                    .qpCard()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Empezando en la página \(Int(startPage))")
                        .font(KHTheme.text(14, .semibold))
                        .foregroundColor(KHTheme.ink)
                    Text(Int(startPage) == 0 ? "El principio" : "Yuz \(QuranMap.juz(forPage: max(1, Int(startPage)))) · \(QuranMap.surah(forPage: max(1, Int(startPage))).translit)")
                        .font(KHTheme.text(12))
                        .foregroundColor(KHTheme.inkSoft)
                    Slider(value: $startPage, in: 0...Double(QuranMap.totalPages - 1), step: 1)
                        .accentColor(KHTheme.indigo)
                }
                .qpCard()
                Button {
                    store.startKhatm(
                        mode: mode,
                        targetDate: mode == .byDate ? targetDate : nil,
                        pagesPerDay: Int(pagesPerDay),
                        startingAt: Int(startPage)
                    )
                    KHHaptics.success()
                    presentation.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Empezar a leer")
                            .font(KHTheme.text(16, .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(Capsule().fill(KHTheme.indigo))
                }
                .buttonStyle(PressScaleStyle())
            }
            .padding(18)
            .padding(.bottom, 16)
        }
        .background(KHTheme.paper.ignoresSafeArea())
    }

    private func presetChip(_ label: String, apply: @escaping () -> Void) -> some View {
        Button {
            apply()
            KHHaptics.tap()
        } label: {
            Text(label)
                .font(KHTheme.text(11, .semibold))
                .foregroundColor(KHTheme.gold)
                .padding(.horizontal, 9)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(KHTheme.goldSoft.opacity(0.4)))
                .overlay(Capsule().strokeBorder(KHTheme.gold.opacity(0.4), lineWidth: 1))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .buttonStyle(PressScaleStyle())
    }

    private func modeButton(_ label: String, _ m: KhatmMode) -> some View {
        Button {
            mode = m
            KHHaptics.tap()
        } label: {
            Text(label)
                .font(KHTheme.text(14, .semibold))
                .foregroundColor(mode == m ? .white : KHTheme.indigo)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Capsule().fill(mode == m ? KHTheme.indigo : KHTheme.indigoSoft.opacity(0.6)))
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
        .clipShape(RoundedRectangle(cornerRadius: KHTheme.corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: KHTheme.corner, style: .continuous)
                .strokeBorder(KHTheme.line, lineWidth: 1)
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
                    with: .color(KHTheme.goldSoft.opacity(0.5 + 0.4 * sx))
                )
            }
            let mc = CGPoint(x: size.width * 0.82, y: size.height * 0.26)
            var moon = Path()
            moon.addArc(center: mc, radius: 13, startAngle: .degrees(-50), endAngle: .degrees(130), clockwise: false)
            moon.addQuadCurve(
                to: CGPoint(x: mc.x + cos(-50 * .pi / 180) * 13, y: mc.y + sin(-50 * .pi / 180) * 13),
                control: CGPoint(x: mc.x + 5, y: mc.y + 3)
            )
            ctx.fill(moon, with: .color(KHTheme.goldSoft.opacity(0.85)))
        } else {
            let t = min(1, max(0, (hour - 6.0) / 14.0))
            let a = CGFloat(.pi * (1.0 - t))
            let sc = CGPoint(
                x: size.width * 0.5 + cos(a) * size.width * 0.42,
                y: size.height * 0.42 - sin(a) * size.height * 0.26
            )
            ctx.fill(
                Path(ellipseIn: CGRect(x: sc.x - 12, y: sc.y - 12, width: 24, height: 24)),
                with: .color(KHTheme.goldSoft.opacity(0.9))
            )
            for i in 0..<12 {
                let ra = CGFloat(i) * .pi / 6
                var ray = Path()
                ray.move(to: CGPoint(x: sc.x + cos(ra) * 16, y: sc.y + sin(ra) * 16))
                ray.addLine(to: CGPoint(x: sc.x + cos(ra) * 22, y: sc.y + sin(ra) * 22))
                ctx.stroke(ray, with: .color(KHTheme.gold.opacity(0.5)), lineWidth: 1.2)
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
        ctx.fill(sil, with: .color((night ? Color(qpHex: 0x11172A) : KHTheme.indigoDeep).opacity(night ? 0.85 : 0.5)))

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
        ctx.stroke(pagePath(right: false), with: .color(KHTheme.ink.opacity(0.75)), lineWidth: 2)
        ctx.stroke(pagePath(right: true), with: .color(KHTheme.ink.opacity(0.75)), lineWidth: 2)

        var inner = ctx
        inner.clip(to: pagePath(right: false))
        let fillH = bh * 0.8 * CGFloat(min(1, max(0, percent)))
        inner.fill(
            Path(CGRect(x: bc.x - bw / 2, y: bc.y + bh * 0.5 - fillH, width: bw / 2, height: fillH)),
            with: .color(KHTheme.indigo.opacity(0.35))
        )
        for k in 0..<5 {
            let y = bc.y - bh * 0.22 + CGFloat(k) * bh * 0.13
            var l1 = Path()
            l1.move(to: CGPoint(x: bc.x - bw * 0.4, y: y + 2))
            l1.addLine(to: CGPoint(x: bc.x - bw * 0.08, y: y))
            var l2 = Path()
            l2.move(to: CGPoint(x: bc.x + bw * 0.08, y: y))
            l2.addLine(to: CGPoint(x: bc.x + bw * 0.4, y: y + 2))
            ctx.stroke(l1, with: .color(KHTheme.indigo.opacity(0.4)), lineWidth: 1)
            ctx.stroke(l2, with: .color(KHTheme.indigo.opacity(0.4)), lineWidth: 1)
        }

        let label = Text("\(Int(min(1, max(0, percent)) * 100))% del mushaf")
            .font(KHTheme.text(11, .semibold))
            .foregroundColor(night ? KHTheme.goldSoft : KHTheme.indigoDeep)
        ctx.draw(ctx.resolve(label), at: CGPoint(x: size.width * 0.5, y: size.height * 0.12), anchor: .center)
    }
}

struct SittingView: View {
    @EnvironmentObject var store: KHStore
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
                    Text("Cancelar")
                        .font(KHTheme.text(14, .semibold))
                        .foregroundColor(KHTheme.inkFaint)
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
        .background(KHTheme.paper.ignoresSafeArea())
        .onAppear {
            started = Date()
            let report = store.pace()
            pages = max(0, report.todayGoal - report.todayRead)
        }
    }

    private var runningView: some View {
        VStack(spacing: 26) {
            Text("Una sesión con el mushaf")
                .font(KHTheme.serif(22))
                .foregroundColor(KHTheme.ink)
            TimelineView(.periodic(from: .now, by: 1)) { timeline in
                let elapsed = max(0, Int(timeline.date.timeIntervalSince(started)))
                let breathe = 1.0 + 0.03 * sin(timeline.date.timeIntervalSinceReferenceDate * 0.8)
                ZStack {
                    Circle()
                        .stroke(KHTheme.indigoSoft, lineWidth: 10)
                        .frame(width: 190, height: 190)
                        .scaleEffect(breathe)
                    Circle()
                        .stroke(KHTheme.gold.opacity(0.35), lineWidth: 2)
                        .frame(width: 220, height: 220)
                        .scaleEffect(2.0 - breathe)
                    VStack(spacing: 2) {
                        Text(String(format: "%d:%02d", elapsed / 60, elapsed % 60))
                            .font(KHTheme.round(44))
                            .foregroundColor(KHTheme.ink)
                        Text("lectura")
                            .font(KHTheme.text(12))
                            .foregroundColor(KHTheme.inkFaint)
                    }
                }
            }
            let page = min(QuranMap.totalPages, (store.state.plan?.position ?? 0) + 1)
            Text("Marcador en la página \(page) · Yuz \(QuranMap.juz(forPage: page)) · \(QuranMap.surah(forPage: page).translit)")
                .font(KHTheme.text(13))
                .foregroundColor(KHTheme.inkSoft)
            Text("Deja el teléfono y lee. Vuelve cuando termine la sesión.")
                .font(KHTheme.text(12))
                .foregroundColor(KHTheme.inkFaint)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                ended = Date()
                KHHaptics.milestone()
            } label: {
                Text("Finalizar la sesión")
                    .font(KHTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 13)
                    .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
    }

    private func closingView(ended: Date) -> some View {
        let mins = max(1, Int(ended.timeIntervalSince(started) / 60))
        return VStack(spacing: 20) {
            Text("¿Hasta dónde has llegado?")
                .font(KHTheme.serif(23))
                .foregroundColor(KHTheme.ink)
            KHChip(text: mins == 1 ? "1 minuto de lectura" : "\(mins) minutos de lectura", tint: KHTheme.gold)
            HStack(spacing: 22) {
                stepButton("-") { pages = max(0, pages - 1) }
                VStack(spacing: 0) {
                    Text("\(pages)")
                        .font(KHTheme.round(52))
                        .foregroundColor(KHTheme.indigo)
                    Text(pages == 1 ? "página" : "páginas")
                        .font(KHTheme.text(12))
                        .foregroundColor(KHTheme.inkFaint)
                }
                .frame(width: 110)
                stepButton("+") { pages = min(QuranMap.totalPages, pages + 1) }
            }
            Button {
                store.recordSitting(minutes: mins, pages: pages)
                KHHaptics.success()
                presentation.wrappedValue.dismiss()
            } label: {
                Text(pages > 0 ? "Registrar \(pages) página\(pages == 1 ? "" : "s")" : "Registrar solo el tiempo")
                    .font(KHTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 300)
                    .padding(.vertical, 13)
                    .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
    }

    private func stepButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
            KHHaptics.tap()
        } label: {
            Text(label)
                .font(KHTheme.round(26))
                .foregroundColor(KHTheme.indigo)
                .frame(width: 56, height: 56)
                .background(Circle().fill(KHTheme.indigoSoft.opacity(0.6)))
        }
        .buttonStyle(PressScaleStyle())
    }
}
