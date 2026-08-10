import Foundation

enum KhatmMode: String, Codable {
    case byDate
    case perDay
}

struct KhatmPlan: Codable {
    var startDate: Date = Date()
    var mode: KhatmMode = .perDay
    var targetDate: Date? = nil
    var pagesPerDay: Int = 4
    var position: Int = 0
    var log: [String: Int] = [:]
    var completedOn: Date? = nil

    init() {}

    enum CodingKeys: String, CodingKey {
        case startDate, mode, targetDate, pagesPerDay, position, log, completedOn
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        startDate = (try? c.decodeIfPresent(Date.self, forKey: .startDate)) ?? Date()
        mode = (try? c.decodeIfPresent(KhatmMode.self, forKey: .mode)) ?? .perDay
        targetDate = try? c.decodeIfPresent(Date.self, forKey: .targetDate)
        pagesPerDay = (try? c.decodeIfPresent(Int.self, forKey: .pagesPerDay)) ?? 4
        position = (try? c.decodeIfPresent(Int.self, forKey: .position)) ?? 0
        log = (try? c.decodeIfPresent([String: Int].self, forKey: .log)) ?? [:]
        completedOn = try? c.decodeIfPresent(Date.self, forKey: .completedOn)
    }
}

struct KhatmRecord: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var started: Date = Date()
    var finished: Date = Date()
    var days: Int = 0
}

struct QPGuideSection: Hashable {
    let heading: String
    let body: String
}

struct QPGuide: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let artName: String
    let minutes: Int
    let sections: [QPGuideSection]
    let facts: [String]
}

struct QPTerm: Identifiable, Hashable {
    let id: String
    let term: String
    let definition: String
}

struct QPBadge: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
}

enum QPCatalog {
    static let guides: [QPGuide] = QPLore.guides
    static let glossary: [QPTerm] = QPLore.glossary
    static let badges: [QPBadge] = QPLore.badges
}
