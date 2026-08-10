import SwiftUI
import WidgetKit

enum WPal {
    static let paper = Color(red: 0.969, green: 0.949, blue: 0.902)
    static let ink = Color(red: 0.137, green: 0.125, blue: 0.098)
    static let inkSoft = Color(red: 0.345, green: 0.318, blue: 0.267)
    static let indigo = Color(red: 0.173, green: 0.231, blue: 0.4)
    static let gold = Color(red: 0.706, green: 0.537, blue: 0.184)
    static let sage = Color(red: 0.353, green: 0.439, blue: 0.349)
}

struct PortionWidgetView: View {
    @Environment(\.widgetFamily) var family
    let snapshot: PaceSnapshot

    var body: some View {
        switch family {
        case .accessoryInline:
            inline
        case .accessoryRectangular:
            rectangular
        case .systemMedium:
            medium
        default:
            small
        }
    }

    private var inline: some View {
        Group {
            if !snapshot.hasPlan {
                Text("Quran Pace: set up a khatm")
            } else if snapshot.todayDone {
                Text("Portion done \u{00B7} juz \(snapshot.juz)")
            } else {
                Text("\(max(0, snapshot.todayGoal - snapshot.todayRead)) pages left \u{00B7} p. \(snapshot.position + 1)")
            }
        }
        .containerBackground(for: .widget) { Color.clear }
    }

    private var rectangular: some View {
        HStack(spacing: 8) {
            Gauge(value: min(1, snapshot.todayGoal > 0 ? Double(snapshot.todayRead) / Double(snapshot.todayGoal) : 0)) {
                Text("\(snapshot.todayRead)")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 1) {
                Text(snapshot.hasPlan ? "Today: \(snapshot.todayRead) of \(snapshot.todayGoal)" : "Quran Pace")
                    .font(.system(size: 13, weight: .semibold))
                Text(snapshot.hasPlan ? "Juz \(snapshot.juz) \u{00B7} \(snapshot.surahName)" : "Set up a khatm")
                    .font(.system(size: 11))
                    .opacity(0.8)
            }
            Spacer(minLength: 0)
        }
        .containerBackground(for: .widget) { Color.clear }
    }

    private var small: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("TODAY")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(WPal.gold)
                Spacer()
                OctoStarShape()
                    .fill(WPal.gold.opacity(0.8))
                    .frame(width: 12, height: 12)
            }
            Spacer(minLength: 0)
            if snapshot.hasPlan {
                Text("\(snapshot.todayRead)")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(WPal.ink)
                + Text(" / \(snapshot.todayGoal)")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(WPal.inkSoft)
                Text(snapshot.todayDone ? "Portion done" : "pages read")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(snapshot.todayDone ? WPal.sage : WPal.inkSoft)
                ProgressView(value: min(1, snapshot.todayGoal > 0 ? Double(snapshot.todayRead) / Double(snapshot.todayGoal) : 0))
                    .tint(snapshot.todayDone ? WPal.sage : WPal.indigo)
                Text("Juz \(snapshot.juz) \u{00B7} \(snapshot.surahName)")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(WPal.inkSoft)
                    .lineLimit(1)
            } else {
                Text("Set up your khatm")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(WPal.ink)
                Text("Open Quran Pace")
                    .font(.system(size: 11))
                    .foregroundColor(WPal.inkSoft)
            }
        }
        .containerBackground(for: .widget) { WPal.paper }
    }

    private var medium: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("TODAY'S PORTION")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(WPal.gold)
                if snapshot.hasPlan {
                    Text("\(snapshot.todayRead) of \(snapshot.todayGoal) pages")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(WPal.ink)
                    Text(snapshot.portionLine)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(snapshot.todayDone ? WPal.sage : WPal.inkSoft)
                    Spacer(minLength: 0)
                    Text("Juz \(snapshot.juz) \u{00B7} \(snapshot.juzOpening) \u{00B7} \(snapshot.surahName)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(WPal.inkSoft)
                        .lineLimit(1)
                    Text(snapshot.statusLine + (snapshot.targetLine.isEmpty ? "" : " \u{00B7} " + snapshot.targetLine))
                        .font(.system(size: 10))
                        .foregroundColor(WPal.gold)
                        .lineLimit(1)
                } else {
                    Text("No khatm underway")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(WPal.ink)
                    Text("Open Quran Pace to begin one.")
                        .font(.system(size: 12))
                        .foregroundColor(WPal.inkSoft)
                    Spacer(minLength: 0)
                }
            }
            Spacer(minLength: 0)
            ZStack {
                Circle()
                    .stroke(WPal.indigo.opacity(0.15), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(min(1, snapshot.percent)))
                    .stroke(WPal.indigo, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text("\(Int(snapshot.percent * 100))%")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(WPal.ink)
                    Text("khatm")
                        .font(.system(size: 9))
                        .foregroundColor(WPal.inkSoft)
                }
            }
            .frame(width: 74, height: 74)
        }
        .containerBackground(for: .widget) { WPal.paper }
    }
}

struct KhatmRingWidgetView: View {
    @Environment(\.widgetFamily) var family
    let snapshot: PaceSnapshot

    var body: some View {
        switch family {
        case .accessoryCircular:
            circular
        case .accessoryRectangular:
            rectangular
        default:
            small
        }
    }

    private var circular: some View {
        Gauge(value: min(1, snapshot.percent)) {
            Text("Q")
        } currentValueLabel: {
            VStack(spacing: -2) {
                Text("\(Int(snapshot.percent * 100))")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text("%")
                    .font(.system(size: 9, weight: .semibold))
            }
        }
        .gaugeStyle(.accessoryCircular)
        .containerBackground(for: .widget) { Color.clear }
    }

    private var rectangular: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Khatm \u{00B7} \(Int(snapshot.percent * 100))%")
                .font(.system(size: 13, weight: .semibold))
            ProgressView(value: min(1, snapshot.percent))
            Text("Page \(snapshot.position) of 604 \u{00B7} \(snapshot.streak)-day streak")
                .font(.system(size: 11))
                .opacity(0.8)
        }
        .containerBackground(for: .widget) { Color.clear }
    }

    private var small: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(WPal.indigo.opacity(0.15), lineWidth: 9)
                Circle()
                    .trim(from: 0, to: CGFloat(min(1, snapshot.percent)))
                    .stroke(WPal.indigo, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text("\(Int(snapshot.percent * 100))%")
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(WPal.ink)
                    Text("of 604")
                        .font(.system(size: 9))
                        .foregroundColor(WPal.inkSoft)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text(snapshot.hasPlan ? "Juz \(snapshot.juz) \u{00B7} \(snapshot.surahName)" : "No khatm underway")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(WPal.inkSoft)
                .lineLimit(1)
        }
        .containerBackground(for: .widget) { WPal.paper }
    }
}

struct OctoStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let rOuter = min(rect.width, rect.height) / 2
        let rInner = rOuter * 0.45
        for i in 0..<16 {
            let angle = (Double(i) * .pi / 8) - .pi / 2
            let r = i % 2 == 0 ? rOuter : rInner
            let p = CGPoint(x: c.x + CGFloat(cos(angle)) * r, y: c.y + CGFloat(sin(angle)) * r)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        path.closeSubpath()
        return path
    }
}
