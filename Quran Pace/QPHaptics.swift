import UIKit

enum QPHaptics {
    private static let light = UIImpactFeedbackGenerator(style: .light)
    private static let medium = UIImpactFeedbackGenerator(style: .medium)
    private static let soft = UIImpactFeedbackGenerator(style: .soft)
    private static let notify = UINotificationFeedbackGenerator()

    static var enabled = true

    static func tap() {
        guard enabled else { return }
        light.impactOccurred(intensity: 0.6)
    }
    static func page() {
        guard enabled else { return }
        soft.impactOccurred(intensity: 0.8)
    }
    static func milestone() {
        guard enabled else { return }
        medium.impactOccurred(intensity: 1.0)
    }
    static func success() {
        guard enabled else { return }
        notify.notificationOccurred(.success)
    }
    static func warm() {
        guard enabled else { return }
        notify.notificationOccurred(.warning)
    }
}
