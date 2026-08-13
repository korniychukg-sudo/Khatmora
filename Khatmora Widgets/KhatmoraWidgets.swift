import WidgetKit
import SwiftUI

struct KhatmoraEntry: TimelineEntry {
    let date: Date
    let snapshot: KhatmoraSnapshot
}

struct KhatmoraProvider: TimelineProvider {
    func placeholder(in context: Context) -> KhatmoraEntry {
        KhatmoraEntry(date: Date(), snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (KhatmoraEntry) -> Void) {
        completion(KhatmoraEntry(date: Date(), snapshot: KhatmoraShared.loadSnapshot()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<KhatmoraEntry>) -> Void) {
        let entry = KhatmoraEntry(date: Date(), snapshot: KhatmoraShared.loadSnapshot())
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
        StaticConfiguration(kind: "KhatmoraPortion", provider: KhatmoraProvider()) { entry in
            PortionWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("Porción de hoy")
        .description("Cuántas páginas corresponden hoy y cuántas ya has leído.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline])
    }
}

struct KhatmRingWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "KhatmoraRing", provider: KhatmoraProvider()) { entry in
            KhatmRingWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("Anillo del jatm")
        .description("La lectura completa representada como un anillo que se va llenando.")
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular])
    }
}

@main
struct KhatmoraWidgetBundle: WidgetBundle {
    var body: some Widget {
        PortionWidget()
        KhatmRingWidget()
    }
}
