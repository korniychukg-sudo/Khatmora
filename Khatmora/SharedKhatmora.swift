import Foundation

enum KhatmoraShared {
    static let appGroup = "group.com.indigorehal.khatmora"
    static let snapshotKey = "khatmora.widget.v1"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroup) ?? .standard
    }

    static func loadSnapshot() -> KhatmoraSnapshot {
        guard let data = defaults.data(forKey: snapshotKey),
              let decoded = try? JSONDecoder().decode(KhatmoraSnapshot.self, from: data) else {
            return KhatmoraSnapshot.placeholder
        }
        return decoded
    }

    static func save(_ snapshot: KhatmoraSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: snapshotKey)
    }
}

struct KhatmoraSnapshot: Codable {
    var hasPlan: Bool
    var position: Int
    var percent: Double
    var todayGoal: Int
    var todayRead: Int
    var juz: Int
    var juzOpening: String
    var surahName: String
    var streak: Int
    var statusLine: String
    var targetLine: String

    var todayDone: Bool { todayGoal > 0 && todayRead >= todayGoal }

    var portionLine: String {
        if !hasPlan { return "Configura tu jatm" }
        if todayDone { return "Listo por hoy" }
        let left = max(0, todayGoal - todayRead)
        return left == 1 ? "Queda 1 página hoy" : "Quedan \(left) páginas hoy"
    }

    static let placeholder = KhatmoraSnapshot(
        hasPlan: true,
        position: 104,
        percent: 104.0 / 604.0,
        todayGoal: 8,
        todayRead: 3,
        juz: 6,
        juzOpening: "La Yuhibbullah",
        surahName: "Al-Ma'idah",
        streak: 5,
        statusLine: "Al ritmo previsto",
        targetLine: "Finaliza el 20 mar"
    )
}
