import SwiftUI

struct KHChip: View {
    let text: String
    var tint: Color = KHTheme.indigo
    var body: some View {
        Text(text)
            .font(KHTheme.text(12, .semibold))
            .foregroundColor(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(tint.opacity(0.12)))
    }
}

struct KHSectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(KHTheme.serif(22))
                .foregroundColor(KHTheme.ink)
            if let s = subtitle {
                Text(s)
                    .font(KHTheme.text(13))
                    .foregroundColor(KHTheme.inkSoft)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct KhatmoraRing: View {
    let progress: Double
    var lineWidth: CGFloat = 6
    var tint: Color = KHTheme.indigo
    var track: Color = KHTheme.line.opacity(0.5)
    var body: some View {
        ZStack {
            Circle().stroke(track, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(max(0, min(1, progress))))
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.3), value: progress)
        }
    }
}

struct KHBadgeToast: View {
    let badge: KHBadge
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(KHTheme.gold.opacity(0.18)).frame(width: 42, height: 42)
                OctoStar(points: 8)
                    .fill(KHTheme.gold)
                    .frame(width: 22, height: 22)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Logro conseguido")
                    .font(KHTheme.text(11, .semibold))
                    .foregroundColor(KHTheme.inkFaint)
                Text(badge.title)
                    .font(KHTheme.serif(16))
                    .foregroundColor(KHTheme.ink)
                Text(badge.detail)
                    .font(KHTheme.text(12))
                    .foregroundColor(KHTheme.inkSoft)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(KHTheme.card)
                .shadow(color: KHTheme.ink.opacity(0.18), radius: 14, x: 0, y: 6)
        )
        .padding(.horizontal, 20)
    }
}

struct OctoStar: Shape {
    var points: Int = 8
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let rOuter = min(rect.width, rect.height) / 2
        let rInner = rOuter * 0.45
        for i in 0..<(points * 2) {
            let angle = (Double(i) * .pi / Double(points)) - .pi / 2
            let r = i % 2 == 0 ? rOuter : rInner
            let p = CGPoint(x: c.x + CGFloat(cos(angle)) * r, y: c.y + CGFloat(sin(angle)) * r)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        path.closeSubpath()
        return path
    }
}

struct MedallionRosette: View {
    var tint: Color = KHTheme.indigo
    var petals: Int = 10
    var body: some View {
        Canvas { ctx, size in
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let r = min(size.width, size.height) / 2 - 2
            var path = Path()
            for i in 0..<petals {
                let a1 = Double(i) * 2 * .pi / Double(petals)
                let a2 = Double(i + 1) * 2 * .pi / Double(petals)
                let p1 = CGPoint(x: c.x + CGFloat(cos(a1)) * r, y: c.y + CGFloat(sin(a1)) * r)
                let p2 = CGPoint(x: c.x + CGFloat(cos(a2)) * r, y: c.y + CGFloat(sin(a2)) * r)
                path.move(to: p1)
                path.addQuadCurve(to: p2, control: c)
            }
            ctx.stroke(path, with: .color(tint), lineWidth: 1.2)
            ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)), with: .color(tint.opacity(0.6)), lineWidth: 1)
        }
    }
}

struct PressScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct KHArrow: View {
    var size: CGFloat = 12
    var color: Color = KHTheme.inkFaint
    var body: some View {
        Canvas { ctx, sz in
            var p = Path()
            p.move(to: CGPoint(x: sz.width * 0.3, y: sz.height * 0.15))
            p.addLine(to: CGPoint(x: sz.width * 0.72, y: sz.height * 0.5))
            p.addLine(to: CGPoint(x: sz.width * 0.3, y: sz.height * 0.85))
            ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct KHCheck: View {
    var size: CGFloat = 14
    var color: Color = KHTheme.sage
    var body: some View {
        Canvas { ctx, sz in
            var p = Path()
            p.move(to: CGPoint(x: sz.width * 0.15, y: sz.height * 0.55))
            p.addLine(to: CGPoint(x: sz.width * 0.4, y: sz.height * 0.8))
            p.addLine(to: CGPoint(x: sz.width * 0.85, y: sz.height * 0.22))
            ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}
