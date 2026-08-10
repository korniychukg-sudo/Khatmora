import Foundation

@main
struct ValidatePace {
    static func main() {
        var failures = 0
        func check(_ cond: Bool, _ label: String) {
            if !cond {
                failures += 1
                print("FAIL: \(label)")
            }
        }

        let surahs = QuranCatalog.surahs
        check(surahs.count == 114, "114 surahs")
        check(surahs.enumerated().allSatisfy { $0.offset + 1 == $0.element.number }, "surah numbers ordered")
        check(surahs.reduce(0) { $0 + $1.ayahs } == 6236, "ayah total 6236, got \(surahs.reduce(0) { $0 + $1.ayahs })")
        check(surahs.filter { $0.medinan }.count == 28, "28 medinan, got \(surahs.filter { $0.medinan }.count)")
        for i in 1..<surahs.count {
            check(surahs[i].startPage >= surahs[i - 1].startPage, "page monotonic at \(surahs[i].number)")
        }
        check(surahs[0].startPage == 1, "fatihah page 1")
        check(surahs[113].startPage == 604, "nas page 604")
        check(surahs.allSatisfy { $0.startPage >= 1 && $0.startPage <= 604 }, "pages in range")
        check(surahs.allSatisfy { !$0.arabic.isEmpty && !$0.translit.isEmpty && !$0.meaning.isEmpty }, "surah fields")
        check(Set(surahs.map { $0.translit }).count == 114, "unique transliterations")

        check(QuranMap.juzStartPages.count == 30, "30 juz starts")
        check(QuranMap.juzOpenings.count == 30, "30 juz openings")
        for i in 1..<30 {
            check(QuranMap.juzStartPages[i] > QuranMap.juzStartPages[i - 1], "juz starts monotonic")
        }
        check(QuranMap.juzStartPages[0] == 1, "juz 1 page 1")
        var pagesSum = 0
        for j in 1...30 {
            let cnt = QuranMap.juzPageCount(j)
            pagesSum += cnt
            check(cnt >= 18 && cnt <= 23, "juz \(j) pages \(cnt) plausible")
        }
        check(pagesSum == 604, "juz pages sum 604, got \(pagesSum)")
        check(QuranMap.juz(forPage: 1) == 1, "juz of page 1")
        check(QuranMap.juz(forPage: 604) == 30, "juz of page 604")
        check(QuranMap.juz(forPage: 22) == 2, "juz of page 22")
        check(QuranMap.juz(forPage: 21) == 1, "juz of page 21")
        check(QuranMap.surah(forPage: 604).number >= 112, "late surah on last page")
        check(QuranMap.surah(forPage: 2).number == 2, "baqarah on page 2")
        check(QuranMap.surah(forPage: 49).number == 2, "baqarah on page 49")
        check(QuranMap.surah(forPage: 50).number == 3, "imran on page 50")

        check(QPCatalog.guides.count == 9, "9 guides, got \(QPCatalog.guides.count)")
        for g in QPCatalog.guides {
            check(g.sections.count >= 3, "guide sections \(g.id)")
            check(!g.facts.isEmpty, "guide facts \(g.id)")
        }
        check(QPCatalog.glossary.count == 30, "30 terms, got \(QPCatalog.glossary.count)")
        check(Set(QPCatalog.glossary.map { $0.id }).count == QPCatalog.glossary.count, "glossary unique")
        check(QPCatalog.badges.count == 18, "18 badges, got \(QPCatalog.badges.count)")
        check(Set(QPCatalog.badges.map { $0.id }).count == QPCatalog.badges.count, "badges unique")

        for seed in 1...400 {
            let round = QPQuizEngine.makeRound(count: 10, seed: UInt64(seed))
            check(round.count == 10, "round \(seed) has 10, got \(round.count)")
            for q in round {
                check(q.options.count == 4, "4 options seed \(seed)")
                check(Set(q.options).count == 4, "distinct options seed \(seed): \(q.options)")
                check(q.correctIndex >= 0 && q.correctIndex < 4, "correct index seed \(seed)")
            }
        }

        let art = ["hero-today", "guide-mushaf", "guide-juz", "guide-khatm", "guide-ramadan", "guide-pace",
                   "guide-surah", "guide-makki", "guide-tilawah", "guide-memory",
                   "onboard-1", "onboard-2", "onboard-3", "onboard-4"]
        let artDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "../Quran Pace/Art"
        for a in art {
            check(FileManager.default.fileExists(atPath: "\(artDir)/\(a).jpg"), "art \(a)")
        }
        for g in QPCatalog.guides {
            check(art.contains(g.artName), "guide art exists \(g.artName)")
        }

        if failures == 0 {
            print("ALL OK: 114 surahs (6236 ayahs), 30 juz (604 pages), \(QPCatalog.guides.count) guides, \(QPCatalog.glossary.count) terms, \(QPCatalog.badges.count) badges, 400 quiz rounds")
        } else {
            print("\(failures) FAILURES")
            exit(1)
        }
    }
}
