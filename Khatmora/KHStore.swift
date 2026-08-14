import Foundation
import SwiftUI

struct SittingRecord: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var date: Date = Date()
    var minutes: Int = 0
    var pages: Int = 0
}

struct KHState: Codable {
    var plan: KhatmPlan? = nil
    var archive: [KhatmRecord] = []
    var totalPagesEver: Int = 0
    var readingDays: Set<String> = []
    var guidesRead: Set<String> = []
    var quizBest: Int = 0
    var quizRounds: Int = 0
    var earned: Set<String> = []
    var showArabicNames: Bool = true
    var hapticsOn: Bool = true
    var onboarded: Bool = false
    var sittings: [SittingRecord] = []
    var sealedJuz: Set<Int> = []
    var bestDayPages: Int = 0

    init() {}

    enum CodingKeys: String, CodingKey {
        case plan, archive, totalPagesEver, readingDays, guidesRead
        case quizBest, quizRounds, earned, showArabicNames, hapticsOn, onboarded
        case sittings, sealedJuz, bestDayPages
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        plan = try? c.decodeIfPresent(KhatmPlan.self, forKey: .plan)
        archive = (try? c.decodeIfPresent([KhatmRecord].self, forKey: .archive)) ?? []
        totalPagesEver = (try? c.decodeIfPresent(Int.self, forKey: .totalPagesEver)) ?? 0
        readingDays = (try? c.decodeIfPresent(Set<String>.self, forKey: .readingDays)) ?? []
        guidesRead = (try? c.decodeIfPresent(Set<String>.self, forKey: .guidesRead)) ?? []
        quizBest = (try? c.decodeIfPresent(Int.self, forKey: .quizBest)) ?? 0
        quizRounds = (try? c.decodeIfPresent(Int.self, forKey: .quizRounds)) ?? 0
        earned = (try? c.decodeIfPresent(Set<String>.self, forKey: .earned)) ?? []
        showArabicNames = (try? c.decodeIfPresent(Bool.self, forKey: .showArabicNames)) ?? true
        hapticsOn = (try? c.decodeIfPresent(Bool.self, forKey: .hapticsOn)) ?? true
        onboarded = (try? c.decodeIfPresent(Bool.self, forKey: .onboarded)) ?? false
        sittings = (try? c.decodeIfPresent([SittingRecord].self, forKey: .sittings)) ?? []
        sealedJuz = (try? c.decodeIfPresent(Set<Int>.self, forKey: .sealedJuz)) ?? []
        bestDayPages = (try? c.decodeIfPresent(Int.self, forKey: .bestDayPages)) ?? 0
    }
}

struct KhatmoraReport {
    var todayGoal: Int
    var todayRead: Int
    var remaining: Int
    var percent: Double
    var statusLine: String
    var statusKind: Int
    var forecastLine: String
    var targetLine: String
    var avgPerDay: Double
}

final class KHStore: ObservableObject {
    @Published private(set) var state: KHState
    @Published var newBadge: KHBadge? = nil
    @Published var activeTab: Int = 0
    @Published var celebrateKhatm: Bool = false
    @Published var pendingSeal: Int? = nil

    private static let key = "khatmora.state.v1"

    static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_ES_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static let niceDate: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_ES")
        f.dateFormat = "d MMM"
        return f
    }()

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.key),
           let decoded = try? JSONDecoder().decode(KHState.self, from: data) {
            state = decoded
        } else {
            state = KHState()
        }
        KHHaptics.enabled = state.hapticsOn
    }

    func prepareScreenshotStateIfNeeded() {
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.contains("-screenshot") else { return }
        if state.plan == nil {
            var plan = KhatmPlan()
            plan.startDate = Calendar.current.date(byAdding: .day, value: -17, to: Date()) ?? Date()
            plan.mode = .byDate
            plan.targetDate = Calendar.current.date(byAdding: .day, value: 64, to: Date())
            plan.pagesPerDay = 8
            plan.position = 141
            plan.log[Self.dayKey()] = 5
            state.plan = plan
            state.totalPagesEver = 141
            state.readingDays = Set((0..<5).compactMap {
                Calendar.current.date(byAdding: .day, value: -$0, to: Date()).map(Self.dayKey)
            })
            state.bestDayPages = 12
            state.sittings = [
                SittingRecord(date: Date(), minutes: 24, pages: 5),
                SittingRecord(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), minutes: 32, pages: 7)
            ]
            state.guidesRead = Set(KHCatalog.guides.prefix(3).map(\.id))
            state.earned = Set(KHCatalog.badges.prefix(4).map(\.id))
            state.onboarded = true
            save()
        }
        if let tabIndex = arguments.firstIndex(of: "-tab"), arguments.indices.contains(tabIndex + 1) {
            activeTab = Int(arguments[tabIndex + 1]) ?? 0
        }
        #endif
    }

    private func save() {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }

    static func dayKey(_ date: Date = Date()) -> String {
        dayFormatter.string(from: date)
    }

    var todayRead: Int {
        state.plan?.log[Self.dayKey()] ?? 0
    }

    var streak: Int {
        var run = 0
        var day = Date()
        let cal = Calendar.current
        if !state.readingDays.contains(Self.dayKey(day)) {
            guard let prev = cal.date(byAdding: .day, value: -1, to: day) else { return 0 }
            day = prev
        }
        while state.readingDays.contains(Self.dayKey(day)) {
            run += 1
            guard let prev = cal.date(byAdding: .day, value: -1, to: day) else { break }
            day = prev
        }
        return run
    }

    func pace() -> KhatmoraReport {
        guard let plan = state.plan else {
            return KhatmoraReport(todayGoal: 0, todayRead: 0, remaining: QuranMap.totalPages, percent: 0, statusLine: "No hay ningún jatm en curso", statusKind: 0, forecastLine: "", targetLine: "", avgPerDay: 0)
        }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let read = todayRead
        let remaining = QuranMap.totalPages - plan.position
        let percent = Double(plan.position) / Double(QuranMap.totalPages)

        var goal = plan.pagesPerDay
        var targetLine = ""
        var statusLine = "Al ritmo previsto"
        var statusKind = 1

        if plan.mode == .byDate, let target = plan.targetDate {
            let targetDay = cal.startOfDay(for: target)
            let daysLeft = max(1, (cal.dateComponents([.day], from: today, to: targetDay).day ?? 0) + 1)
            let leftAtDayStart = remaining + read
            goal = max(1, Int(ceil(Double(leftAtDayStart) / Double(daysLeft))))
            targetLine = "Finaliza el \(Self.niceDate.string(from: target))"
            let startDay = cal.startOfDay(for: plan.startDate)
            let totalDays = max(1, (cal.dateComponents([.day], from: startDay, to: targetDay).day ?? 1) + 1)
            let elapsed = min(totalDays, max(0, (cal.dateComponents([.day], from: startDay, to: today).day ?? 0)))
            let planned = Int(Double(QuranMap.totalPages) * Double(elapsed) / Double(totalDays))
            let delta = plan.position - planned
            if delta >= 5 {
                statusLine = "Adelanto de \(delta) páginas"
                statusKind = 2
            } else if delta <= -5 {
                statusLine = "Retraso de \(-delta) páginas"
                statusKind = 0
            } else {
                statusLine = "Al ritmo previsto"
                statusKind = 1
            }
        } else {
            targetLine = "\(plan.pagesPerDay) páginas al día"
            statusLine = read >= goal ? "Porción de hoy completada" : "Al ritmo previsto"
            statusKind = read >= goal ? 2 : 1
        }

        let startDay = cal.startOfDay(for: plan.startDate)
        let activeDays = max(1, (cal.dateComponents([.day], from: startDay, to: today).day ?? 0) + 1)
        let avg = Double(plan.position) / Double(activeDays)
        var forecastLine = ""
        if remaining > 0 && avg > 0.15 {
            let daysNeeded = Int(ceil(Double(remaining) / avg))
            if let eta = cal.date(byAdding: .day, value: daysNeeded, to: today) {
                forecastLine = "A tu ritmo: \(Self.niceDate.string(from: eta))"
            }
        }
        return KhatmoraReport(
            todayGoal: goal, todayRead: read, remaining: remaining, percent: percent,
            statusLine: statusLine, statusKind: statusKind,
            forecastLine: forecastLine, targetLine: targetLine, avgPerDay: avg
        )
    }

    func startKhatm(mode: KhatmMode, targetDate: Date?, pagesPerDay: Int, startingAt page: Int = 0) {
        var plan = KhatmPlan()
        plan.startDate = Date()
        plan.mode = mode
        plan.targetDate = targetDate
        plan.pagesPerDay = max(1, pagesPerDay)
        plan.position = min(max(0, page), QuranMap.totalPages)
        state.plan = plan
        state.sealedJuz = Set((1...30).filter { plan.position >= QuranMap.juzRange($0).upperBound })
        pendingSeal = nil
        evaluateBadges()
        save()
    }

    func logPages(_ count: Int) {
        guard var plan = state.plan, count != 0 else { return }
        let day = Self.dayKey()
        let applied = max(-(plan.log[day] ?? 0), min(count, QuranMap.totalPages - plan.position))
        guard applied != 0 else { return }
        plan.position = min(QuranMap.totalPages, max(0, plan.position + applied))
        plan.log[day] = max(0, (plan.log[day] ?? 0) + applied)
        state.plan = plan
        if applied > 0 {
            state.totalPagesEver += applied
            state.readingDays.insert(day)
        }
        state.bestDayPages = max(state.bestDayPages, state.plan?.log[day] ?? 0)
        checkSeals()
        checkCompletion()
        evaluateBadges()
        save()
    }

    func setPosition(_ page: Int) {
        guard var plan = state.plan else { return }
        let clamped = min(max(0, page), QuranMap.totalPages)
        let delta = clamped - plan.position
        let day = Self.dayKey()
        plan.position = clamped
        if delta > 0 {
            plan.log[day] = (plan.log[day] ?? 0) + delta
            state.totalPagesEver += delta
            state.readingDays.insert(day)
        }
        state.plan = plan
        state.bestDayPages = max(state.bestDayPages, state.plan?.log[day] ?? 0)
        checkSeals()
        checkCompletion()
        evaluateBadges()
        save()
    }

    private func checkSeals() {
        let pos = state.plan?.position ?? 0
        for j in 1...30 where !state.sealedJuz.contains(j) {
            if pos >= QuranMap.juzRange(j).upperBound {
                state.sealedJuz.insert(j)
                if j < 30 {
                    pendingSeal = j
                }
            }
        }
    }

    func recordSitting(minutes: Int, pages: Int) {
        var rec = SittingRecord()
        rec.minutes = max(1, minutes)
        rec.pages = max(0, pages)
        state.sittings.insert(rec, at: 0)
        if state.sittings.count > 200 {
            state.sittings.removeLast(state.sittings.count - 200)
        }
        if pages > 0 {
            logPages(pages)
        } else {
            save()
        }
    }

    var minutesPerPage: Double? {
        let sample = state.sittings.prefix(20).filter { $0.pages > 0 }
        let mins = sample.reduce(0) { $0 + $1.minutes }
        let pages = sample.reduce(0) { $0 + $1.pages }
        guard pages >= 3, mins > 0 else { return nil }
        return Double(mins) / Double(pages)
    }

    var totalReadingMinutes: Int {
        state.sittings.reduce(0) { $0 + $1.minutes }
    }

    var longestSittingMinutes: Int {
        state.sittings.map { $0.minutes }.max() ?? 0
    }

    private func checkCompletion() {
        guard var plan = state.plan else { return }
        if plan.position >= QuranMap.totalPages && plan.completedOn == nil {
            plan.completedOn = Date()
            let cal = Calendar.current
            let days = max(1, (cal.dateComponents([.day], from: cal.startOfDay(for: plan.startDate), to: cal.startOfDay(for: Date())).day ?? 0) + 1)
            var rec = KhatmRecord()
            rec.started = plan.startDate
            rec.finished = Date()
            rec.days = days
            state.archive.insert(rec, at: 0)
            state.plan = plan
            celebrateKhatm = true
            KHHaptics.success()
        } else {
            state.plan = plan
        }
    }

    func closeCompletedKhatm() {
        state.plan = nil
        celebrateKhatm = false
        save()
    }

    func abandonKhatm() {
        state.plan = nil
        save()
    }

    func markGuideRead(_ id: String) {
        if !state.guidesRead.contains(id) {
            state.guidesRead.insert(id)
            evaluateBadges()
            save()
        }
    }

    func quizFinished(score: Int, total: Int) {
        state.quizRounds += 1
        if score > state.quizBest { state.quizBest = score }
        if score == total { award("qb-quiz") }
        evaluateBadges()
        save()
    }

    func setArabicNames(_ on: Bool) {
        state.showArabicNames = on
        save()
    }

    func setHaptics(_ on: Bool) {
        state.hapticsOn = on
        KHHaptics.enabled = on
        save()
    }

    func finishOnboarding() {
        state.onboarded = true
        save()
    }

    func resetAll() {
        state = KHState()
        state.onboarded = true
        save()
    }

    var earnedBadges: [KHBadge] {
        KHCatalog.badges.filter { state.earned.contains($0.id) }
    }

    private func award(_ id: String) {
        guard !state.earned.contains(id) else { return }
        state.earned.insert(id)
        if let badge = KHCatalog.badges.first(where: { $0.id == id }) {
            newBadge = badge
        }
    }

    private func evaluateBadges() {
        let pos = state.plan?.position ?? 0
        if state.totalPagesEver >= 1 { award("qb-first") }
        if pos >= 21 || state.totalPagesEver >= 21 { award("qb-juz") }
        if pos >= 302 { award("qb-half") }
        if state.archive.count >= 1 { award("qb-khatm") }
        if state.archive.count >= 3 { award("qb-threekhatms") }
        if todayRead >= 10 { award("qb-tenday") }
        if todayRead >= 20 { award("qb-twentyday") }
        if streak >= 7 { award("qb-week") }
        if streak >= 30 { award("qb-month") }
        if state.readingDays.count >= 30 { award("qb-days30") }
        if state.readingDays.count >= 100 { award("qb-days100") }
        if state.totalPagesEver >= 604 { award("qb-pages604") }
        if state.totalPagesEver >= 3020 { award("qb-pages3020") }
        if KHCatalog.guides.allSatisfy({ state.guidesRead.contains($0.id) }) { award("qb-guides") }
        if state.quizRounds >= 10 { award("qb-tenquiz") }
        if let plan = state.plan, plan.mode == .byDate { award("qb-planner") }
        if let plan = state.plan, QuranMap.juz(forPage: max(1, plan.position)) >= 30, plan.position >= 582 { award("qb-amma") }
    }

    func heatValue(for date: Date) -> Int {
        state.plan?.log[Self.dayKey(date)] ?? 0
    }

}
