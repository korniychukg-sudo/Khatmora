import SwiftUI

struct TodayTabIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let c = CGPoint(x: sz.width / 2, y: sz.height / 2)
            let r = sz.width * 0.36
            var arc = Path()
            arc.addArc(center: c, radius: r, startAngle: .degrees(-90), endAngle: .degrees(160), clockwise: false)
            ctx.stroke(arc, with: .color(color), style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
            var arc2 = Path()
            arc2.addArc(center: c, radius: r, startAngle: .degrees(170), endAngle: .degrees(250), clockwise: false)
            ctx.stroke(arc2, with: .color(color.opacity(0.4)), style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
            ctx.fill(Path(ellipseIn: CGRect(x: c.x - 2.6, y: c.y - 2.6, width: 5.2, height: 5.2)), with: .color(color))
            var hand = Path()
            hand.move(to: c)
            hand.addLine(to: CGPoint(x: c.x + r * 0.55, y: c.y - r * 0.5))
            ctx.stroke(hand, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct MushafTabIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            let grid = CGRect(x: w * 0.12, y: h * 0.14, width: w * 0.76, height: h * 0.72)
            ctx.stroke(Path(roundedRect: grid, cornerRadius: 3), with: .color(color), lineWidth: 1.7)
            for i in 0..<3 {
                for j in 0..<4 {
                    let cw = grid.width / 4
                    let ch = grid.height / 3
                    let cell = CGRect(x: grid.minX + CGFloat(j) * cw + 2.4, y: grid.minY + CGFloat(i) * ch + 2.4, width: cw - 4.8, height: ch - 4.8)
                    let filled = (i * 4 + j) < 6
                    if filled {
                        ctx.fill(Path(roundedRect: cell, cornerRadius: 1.6), with: .color(color.opacity(0.85)))
                    } else {
                        ctx.stroke(Path(roundedRect: cell, cornerRadius: 1.6), with: .color(color.opacity(0.5)), lineWidth: 1)
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct SurahTabIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            for (i, t) in [0.22, 0.5, 0.78].enumerated() {
                let y = h * CGFloat(t)
                var line = Path()
                line.move(to: CGPoint(x: w * 0.34, y: y))
                line.addLine(to: CGPoint(x: w * 0.88, y: y))
                ctx.stroke(line, with: .color(color.opacity(i == 0 ? 1 : 0.75)), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                let star = CGRect(x: w * 0.1, y: y - 3.6, width: 7.2, height: 7.2)
                ctx.fill(Path(ellipseIn: star), with: .color(color.opacity(0.85)))
            }
        }
        .frame(width: size, height: size)
    }
}

struct LearnTabIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            var left = Path()
            left.move(to: CGPoint(x: w * 0.5, y: h * 0.22))
            left.addQuadCurve(to: CGPoint(x: w * 0.1, y: h * 0.18), control: CGPoint(x: w * 0.28, y: h * 0.06))
            left.addLine(to: CGPoint(x: w * 0.1, y: h * 0.78))
            left.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.86), control: CGPoint(x: w * 0.3, y: h * 0.72))
            left.closeSubpath()
            var right = Path()
            right.move(to: CGPoint(x: w * 0.5, y: h * 0.22))
            right.addQuadCurve(to: CGPoint(x: w * 0.9, y: h * 0.18), control: CGPoint(x: w * 0.72, y: h * 0.06))
            right.addLine(to: CGPoint(x: w * 0.9, y: h * 0.78))
            right.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.86), control: CGPoint(x: w * 0.7, y: h * 0.72))
            right.closeSubpath()
            ctx.stroke(left, with: .color(color), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))
            ctx.stroke(right, with: .color(color), style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))
            var spine = Path()
            spine.move(to: CGPoint(x: w * 0.5, y: h * 0.22))
            spine.addLine(to: CGPoint(x: w * 0.5, y: h * 0.86))
            ctx.stroke(spine, with: .color(color.opacity(0.7)), lineWidth: 1.2)
        }
        .frame(width: size, height: size)
    }
}

struct JournalTabIcon: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, sz in
            let w = sz.width
            let h = sz.height
            let bars: [CGFloat] = [0.35, 0.6, 0.45, 0.8]
            let bw = w * 0.14
            for (i, t) in bars.enumerated() {
                let x = w * 0.12 + CGFloat(i) * bw * 1.35
                let bh = h * t * 0.66
                let rect = CGRect(x: x, y: h * 0.82 - bh, width: bw, height: bh)
                if i == bars.count - 1 {
                    ctx.fill(Path(roundedRect: rect, cornerRadius: 2.4), with: .color(color))
                } else {
                    ctx.stroke(Path(roundedRect: rect, cornerRadius: 2.4), with: .color(color.opacity(0.8)), lineWidth: 1.7)
                }
            }
            var base = Path()
            base.move(to: CGPoint(x: w * 0.08, y: h * 0.86))
            base.addLine(to: CGPoint(x: w * 0.92, y: h * 0.86))
            ctx.stroke(base, with: .color(color), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}
