import Foundation

enum PaceShared {
    static let appGroup = "group.com.quranpace.app"
    static let snapshotKey = "quran.pace.widget.v1"

    static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroup) ?? .standard
    }

    static func loadSnapshot() -> PaceSnapshot {
        guard let data = defaults.data(forKey: snapshotKey),
              let decoded = try? JSONDecoder().decode(PaceSnapshot.self, from: data) else {
            return PaceSnapshot.placeholder
        }
        return decoded
    }

    static func save(_ snapshot: PaceSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: snapshotKey)
    }
}

struct PaceSnapshot: Codable {
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
        if !hasPlan { return "Set up your khatm" }
        if todayDone { return "Done for today" }
        let left = max(0, todayGoal - todayRead)
        return left == 1 ? "1 page left today" : "\(left) pages left today"
    }

    static let placeholder = PaceSnapshot(
        hasPlan: true,
        position: 104,
        percent: 104.0 / 604.0,
        todayGoal: 8,
        todayRead: 3,
        juz: 6,
        juzOpening: "La Yuhibbullah",
        surahName: "Al-Ma'idah",
        streak: 5,
        statusLine: "On pace",
        targetLine: "Finishing Mar 20"
    )
}
