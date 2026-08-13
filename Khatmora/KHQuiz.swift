import Foundation

struct KHQuizQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let arabicHint: String?
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

struct KHSeededRandom: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B97F4A7C15 : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}

enum KHQuizEngine {
    static func makeRound(count: Int = 10, seed: UInt64 = UInt64(Date().timeIntervalSince1970)) -> [KHQuizQuestion] {
        var rng = KHSeededRandom(seed: seed)
        var questions: [KHQuizQuestion] = []
        var usedSurahs = Set<Int>()
        var usedTerms = Set<String>()

        let kinds = (0..<count).map { $0 % 5 }
        for kind in kinds.shuffled(using: &rng) {
            switch kind {
            case 0:
                if let q = meaningQuestion(&rng, used: &usedSurahs) { questions.append(q) }
            case 1:
                if let q = originQuestion(&rng, used: &usedSurahs) { questions.append(q) }
            case 2:
                if let q = glossaryQuestion(&rng, used: &usedTerms) { questions.append(q) }
            case 3:
                if let q = juzQuestion(&rng) { questions.append(q) }
            default:
                if let q = orderQuestion(&rng, used: &usedSurahs) { questions.append(q) }
            }
        }
        while questions.count < count {
            if let q = meaningQuestion(&rng, used: &usedSurahs) { questions.append(q) } else { break }
        }
        return Array(questions.prefix(count))
    }

    private static func meaningQuestion(_ rng: inout KHSeededRandom, used: inout Set<Int>) -> KHQuizQuestion? {
        let pool = QuranCatalog.surahs.filter { !used.contains($0.number) }
        guard let pick = pool.shuffled(using: &rng).first else { return nil }
        used.insert(pick.number)
        let wrong = QuranCatalog.surahs
            .filter { $0.number != pick.number && $0.meaning != pick.meaning }
            .shuffled(using: &rng).prefix(3).map { $0.meaning }
        guard Set(wrong).count >= 3 else { return nil }
        var options = Array(Set(wrong).prefix(3)) + [pick.meaning]
        options.shuffle(using: &rng)
        guard let correct = options.firstIndex(of: pick.meaning) else { return nil }
        return KHQuizQuestion(
            prompt: "¿Qué significa el nombre \(pick.translit)?",
            arabicHint: pick.arabic,
            options: options,
            correctIndex: correct,
            explanation: "\(pick.translit) significa «\(pick.meaning)». Es la sura \(pick.number) y tiene \(pick.ayahs) aleyas."
        )
    }

    private static func originQuestion(_ rng: inout KHSeededRandom, used: inout Set<Int>) -> KHQuizQuestion? {
        let pool = QuranCatalog.surahs.filter { !used.contains($0.number) && $0.number > 1 }
        guard let pick = pool.shuffled(using: &rng).first else { return nil }
        used.insert(pick.number)
        let correct = pick.medinan ? "Medinense" : "Mecana"
        let options = ["Mecana", "Medinense", "Mitad y mitad", "Desconocido"]
        guard let idx = options.firstIndex(of: correct) else { return nil }
        return KHQuizQuestion(
            prompt: "¿\(pick.translit) («\(pick.meaning)») es mecana o medinense?",
            arabicHint: pick.arabic,
            options: options,
            correctIndex: idx,
            explanation: "Según la clasificación tradicional, \(pick.translit) es \(correct.lowercased())."
        )
    }

    private static func glossaryQuestion(_ rng: inout KHSeededRandom, used: inout Set<String>) -> KHQuizQuestion? {
        let pool = KHCatalog.glossary.filter { !used.contains($0.id) }
        guard let pick = pool.shuffled(using: &rng).first else { return nil }
        used.insert(pick.id)
        let wrong = KHCatalog.glossary.filter { $0.id != pick.id }.shuffled(using: &rng).prefix(3).map { $0.term }
        guard wrong.count >= 3 else { return nil }
        var options = Array(wrong) + [pick.term]
        options.shuffle(using: &rng)
        guard let correct = options.firstIndex(of: pick.term) else { return nil }
        return KHQuizQuestion(
            prompt: "¿Qué término corresponde a esta definición? \(pick.definition)",
            arabicHint: nil,
            options: options,
            correctIndex: correct,
            explanation: "\(pick.term): \(pick.definition)"
        )
    }

    private static func juzQuestion(_ rng: inout KHSeededRandom) -> KHQuizQuestion? {
        let juz = Int(rng.next() % 30) + 1
        let correct = QuranMap.juzOpenings[juz - 1]
        let wrong = QuranMap.juzOpenings.enumerated()
            .filter { $0.offset != juz - 1 }
            .shuffled(using: &rng).prefix(3).map { $0.element }
        var options = Array(wrong) + [correct]
        options.shuffle(using: &rng)
        guard let idx = options.firstIndex(of: correct) else { return nil }
        return KHQuizQuestion(
            prompt: "¿Qué palabras abren el yuz \(juz)?",
            arabicHint: nil,
            options: options,
            correctIndex: idx,
            explanation: "El yuz \(juz) comienza con \(correct), en la página \(QuranMap.juzStartPages[juz - 1])."
        )
    }

    private static func orderQuestion(_ rng: inout KHSeededRandom, used: inout Set<Int>) -> KHQuizQuestion? {
        let pool = QuranCatalog.surahs.filter { !used.contains($0.number) }
        guard let pick = pool.shuffled(using: &rng).first else { return nil }
        used.insert(pick.number)
        let correct = "\(pick.number)"
        var wrongNumbers = Set<Int>()
        var attempts = 0
        while wrongNumbers.count < 3 && attempts < 40 {
            attempts += 1
            let delta = Int(rng.next() % 20) + 1
            let sign = rng.next() % 2 == 0 ? 1 : -1
            let candidate = pick.number + delta * sign
            if candidate >= 1 && candidate <= 114 && candidate != pick.number {
                wrongNumbers.insert(candidate)
            }
        }
        guard wrongNumbers.count == 3 else { return nil }
        var options = wrongNumbers.map { "\($0)" } + [correct]
        options.shuffle(using: &rng)
        guard let idx = options.firstIndex(of: correct) else { return nil }
        return KHQuizQuestion(
            prompt: "¿Qué número ocupa \(pick.translit) («\(pick.meaning)») en el orden del mushaf?",
            arabicHint: pick.arabic,
            options: options,
            correctIndex: idx,
            explanation: "\(pick.translit) es la sura \(pick.number) y comienza en la página \(pick.startPage)."
        )
    }
}
