import WidgetKit
import SwiftUI

struct PaceEntry: TimelineEntry {
    let date: Date
    let snapshot: PaceSnapshot
}

struct PaceProvider: TimelineProvider {
    func placeholder(in context: Context) -> PaceEntry {
        PaceEntry(date: Date(), snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (PaceEntry) -> Void) {
        completion(PaceEntry(date: Date(), snapshot: PaceShared.loadSnapshot()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PaceEntry>) -> Void) {
        let entry = PaceEntry(date: Date(), snapshot: PaceShared.loadSnapshot())
        let midnight = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 1),
            matchingPolicy: .nextTime
        ) ?? Date().addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

struct PortionWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "QuranPacePortion", provider: PaceProvider()) { entry in
            PortionWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("Today's Portion")
        .description("How many pages today asks, and how many are already read.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline])
    }
}

struct KhatmRingWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "QuranPaceRing", provider: PaceProvider()) { entry in
            KhatmRingWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("Khatm Ring")
        .description("The whole reading as a slowly filling ring.")
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular])
    }
}

@main
struct QuranPaceWidgetBundle: WidgetBundle {
    var body: some Widget {
        PortionWidget()
        KhatmRingWidget()
    }
}
