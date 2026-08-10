import Foundation
import CoreGraphics

let outDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "../Quran Pace/Art"
let S = Scenes(dir: outDir)

extension Pal {
    static let indigo = Col(r: 0.173, g: 0.231, b: 0.4)
    static let indigoDeep = Col(r: 0.11, g: 0.153, b: 0.271)
    static let rose = Col(r: 0.612, g: 0.29, b: 0.314)
    static let walnutish = Col(r: 0.43, g: 0.29, b: 0.17)
}

func hangLamp(_ p: Plate, cx: CGFloat, topY: CGFloat, size: CGFloat, glow: Bool) {
    let (body, chain) = lampPath(cx: cx, topY: topY, size: size)
    if glow {
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let grad = CGGradient(colorsSpace: cs, colors: [Pal.gold.cg(0.4), Pal.gold.cg(0)] as CFArray, locations: [0, 1])!
        p.ctx.drawRadialGradient(
            grad,
            startCenter: CGPoint(x: cx, y: topY - size), startRadius: 0,
            endCenter: CGPoint(x: cx, y: topY - size), endRadius: size * 1.5,
            options: []
        )
    }
    p.stroke(chain, Pal.ink, 2.4, alpha: 0.8)
    p.fill(body, Pal.goldSoft, alpha: 0.9)
    p.hatch(body, angle: .pi / 3.4, spacing: 7, col: Pal.terra, width: 1.1, alpha: 0.35)
    p.stroke(body, Pal.ink, 2.6, alpha: 0.85)
}

func openBook(_ p: Plate, cx: CGFloat, baseY: CGFloat, w: CGFloat, lines: Int, col: Col) {
    let h = w * 0.34
    let left = CGMutablePath()
    left.move(to: CGPoint(x: cx, y: baseY + h * 0.12))
    left.addQuadCurve(to: CGPoint(x: cx - w / 2, y: baseY + h * 0.24), control: CGPoint(x: cx - w * 0.26, y: baseY + h * 0.34))
    left.addLine(to: CGPoint(x: cx - w / 2, y: baseY - h * 0.62))
    left.addQuadCurve(to: CGPoint(x: cx, y: baseY - h * 0.5), control: CGPoint(x: cx - w * 0.26, y: baseY - h * 0.52))
    left.closeSubpath()
    let right = CGMutablePath()
    right.move(to: CGPoint(x: cx, y: baseY + h * 0.12))
    right.addQuadCurve(to: CGPoint(x: cx + w / 2, y: baseY + h * 0.24), control: CGPoint(x: cx + w * 0.26, y: baseY + h * 0.34))
    right.addLine(to: CGPoint(x: cx + w / 2, y: baseY - h * 0.62))
    right.addQuadCurve(to: CGPoint(x: cx, y: baseY - h * 0.5), control: CGPoint(x: cx + w * 0.26, y: baseY - h * 0.52))
    right.closeSubpath()
    p.fill(left, Col(r: 0.99, g: 0.975, b: 0.94))
    p.fill(right, Col(r: 0.99, g: 0.975, b: 0.94))
    p.stroke(left, Pal.ink, 4, alpha: 0.9)
    p.stroke(right, Pal.ink, 4, alpha: 0.9)
    for i in 0..<lines {
        let t = CGFloat(i + 1) / CGFloat(lines + 1)
        let y = baseY + h * 0.18 - (h * 0.72) * t
        p.inkLine(
            from: CGPoint(x: cx - w * 0.43, y: y + h * 0.06),
            to: CGPoint(x: cx - w * 0.07, y: y),
            col, 1.6, alpha: 0.55
        )
        p.inkLine(
            from: CGPoint(x: cx + w * 0.07, y: y),
            to: CGPoint(x: cx + w * 0.43, y: y + h * 0.06),
            col, 1.6, alpha: 0.55
        )
    }
    p.inkLine(from: CGPoint(x: cx, y: baseY + h * 0.12), to: CGPoint(x: cx, y: baseY - h * 0.5), Pal.ink, 3, alpha: 0.7)
    let ribbon = CGMutablePath()
    ribbon.move(to: CGPoint(x: cx + w * 0.16, y: baseY - h * 0.5))
    ribbon.addQuadCurve(to: CGPoint(x: cx + w * 0.22, y: baseY - h * 0.95), control: CGPoint(x: cx + w * 0.26, y: baseY - h * 0.72))
    p.stroke(ribbon, Pal.rose, 6, alpha: 0.85)
}

func rehalStand(_ p: Plate, cx: CGFloat, baseY: CGFloat, w: CGFloat) {
    let col = Pal.walnutish
    let leg1 = CGMutablePath()
    leg1.move(to: CGPoint(x: cx - w * 0.34, y: baseY + w * 0.42))
    leg1.addLine(to: CGPoint(x: cx + w * 0.34, y: baseY))
    let leg2 = CGMutablePath()
    leg2.move(to: CGPoint(x: cx + w * 0.34, y: baseY + w * 0.42))
    leg2.addLine(to: CGPoint(x: cx - w * 0.34, y: baseY))
    p.stroke(leg1, col, 14, alpha: 0.95)
    p.stroke(leg2, col, 14, alpha: 0.95)
    p.inkLine(from: CGPoint(x: cx - w * 0.36, y: baseY + w * 0.44), to: CGPoint(x: cx - w * 0.3, y: baseY + w * 0.44), Pal.gold, 6, alpha: 0.9)
    p.inkLine(from: CGPoint(x: cx + w * 0.3, y: baseY + w * 0.44), to: CGPoint(x: cx + w * 0.36, y: baseY + w * 0.44), Pal.gold, 6, alpha: 0.9)
}

func kaabaCube(_ p: Plate, cx: CGFloat, baseY: CGFloat, w: CGFloat) {
    let h = w * 1.05
    let body = CGPath(rect: CGRect(x: cx - w / 2, y: baseY, width: w, height: h), transform: nil)
    p.fill(body, Pal.ink, alpha: 0.88)
    p.stroke(body, Pal.ink, 4, alpha: 0.95)
    let band = CGPath(rect: CGRect(x: cx - w / 2, y: baseY + h * 0.62, width: w, height: h * 0.14), transform: nil)
    p.fill(band, Pal.gold, alpha: 0.85)
    p.hatch(band, angle: 0.0, spacing: 5, col: Pal.ink, width: 0.8, alpha: 0.3)
    let door = CGPath(rect: CGRect(x: cx + w * 0.08, y: baseY + h * 0.1, width: w * 0.16, height: h * 0.3), transform: nil)
    p.fill(door, Pal.gold, alpha: 0.7)
}

func hourGlass(_ p: Plate, cx: CGFloat, cy: CGFloat, size: CGFloat) {
    let w = size * 0.62
    let h = size
    let frameTop = CGRect(x: cx - w / 2 - 8, y: cy + h / 2 - 6, width: w + 16, height: 12)
    let frameBot = CGRect(x: cx - w / 2 - 8, y: cy - h / 2 - 6, width: w + 16, height: 12)
    p.fill(CGPath(roundedRect: frameTop, cornerWidth: 5, cornerHeight: 5, transform: nil), Pal.walnutish, alpha: 0.95)
    p.fill(CGPath(roundedRect: frameBot, cornerWidth: 5, cornerHeight: 5, transform: nil), Pal.walnutish, alpha: 0.95)
    let glass = CGMutablePath()
    glass.move(to: CGPoint(x: cx - w / 2, y: cy + h / 2))
    glass.addQuadCurve(to: CGPoint(x: cx - size * 0.03, y: cy), control: CGPoint(x: cx - w / 2 + w * 0.1, y: cy + h * 0.12))
    glass.addQuadCurve(to: CGPoint(x: cx - w / 2, y: cy - h / 2), control: CGPoint(x: cx - w / 2 + w * 0.1, y: cy - h * 0.12))
    glass.move(to: CGPoint(x: cx + w / 2, y: cy + h / 2))
    glass.addQuadCurve(to: CGPoint(x: cx + size * 0.03, y: cy), control: CGPoint(x: cx + w / 2 - w * 0.1, y: cy + h * 0.12))
    glass.addQuadCurve(to: CGPoint(x: cx + w / 2, y: cy - h / 2), control: CGPoint(x: cx + w / 2 - w * 0.1, y: cy - h * 0.12))
    p.stroke(glass, Pal.ink, 3.4, alpha: 0.9)
    let sandTop = CGMutablePath()
    sandTop.move(to: CGPoint(x: cx - w * 0.26, y: cy + h * 0.16))
    sandTop.addQuadCurve(to: CGPoint(x: cx + w * 0.26, y: cy + h * 0.16), control: CGPoint(x: cx, y: cy + h * 0.05))
    sandTop.addQuadCurve(to: CGPoint(x: cx - w * 0.26, y: cy + h * 0.16), control: CGPoint(x: cx, y: cy + h * 0.3))
    p.fill(sandTop, Pal.gold, alpha: 0.8)
    let pile = CGMutablePath()
    pile.move(to: CGPoint(x: cx - w * 0.3, y: cy - h * 0.42))
    pile.addQuadCurve(to: CGPoint(x: cx + w * 0.3, y: cy - h * 0.42), control: CGPoint(x: cx, y: cy - h * 0.12))
    pile.closeSubpath()
    p.fill(pile, Pal.gold, alpha: 0.8)
    p.inkLine(from: CGPoint(x: cx, y: cy), to: CGPoint(x: cx, y: cy - h * 0.36), Pal.gold, 2.4, alpha: 0.9)
}

func pageGridBand(_ p: Plate, rect: CGRect, cols: Int, rows: Int, filledUntil: Int, col: Col) {
    let cw = rect.width / CGFloat(cols)
    let ch = rect.height / CGFloat(rows)
    var idx = 0
    for r in 0..<rows {
        for c in 0..<cols {
            let cell = CGRect(
                x: rect.minX + CGFloat(c) * cw + 2,
                y: rect.maxY - CGFloat(r + 1) * ch + 2,
                width: cw - 4, height: ch - 4
            )
            let path = CGPath(roundedRect: cell, cornerWidth: 3, cornerHeight: 3, transform: nil)
            if idx < filledUntil {
                p.fill(path, col, alpha: 0.75)
            } else if idx == filledUntil {
                p.fill(path, Pal.gold, alpha: 0.9)
            } else {
                p.stroke(path, col, 1.2, alpha: 0.4)
            }
            idx += 1
        }
    }
    p.stroke(CGPath(rect: rect.insetBy(dx: -8, dy: -8), transform: nil), Pal.ink, 2.4, alpha: 0.7)
}

func plate(_ name: String, w: Int = 1600, h: Int = 1200, seed: UInt64, draw: (Plate) -> Void) {
    let p = Plate(w: w, h: h, seed: seed)
    p.paper()
    p.fibers()
    draw(p)
    p.grain()
    p.vignette()
    p.frame()
    p.save(name, dir: S.dir)
}

plate("hero-today", seed: 61) { p in
    S.stars(p, above: 760, count: 20, col: Pal.gold)
    S.crescent(p, center: CGPoint(x: 1240, y: 930), r: 90, col: Pal.goldSoft)
    S.girih(p, center: CGPoint(x: 800, y: 700), radius: 380, col: Pal.gold, layers: 2)
    rehalStand(p, cx: 800, baseY: 300, w: 640)
    openBook(p, cx: 800, baseY: 560, w: 700, lines: 7, col: Pal.indigo)
    S.borderBand(p, y: 84, height: 56, col: Pal.indigo)
}

plate("guide-mushaf", seed: 62) { p in
    openBook(p, cx: 800, baseY: 560, w: 860, lines: 15, col: Pal.indigo)
    let band = CGRect(x: 420, y: 880, width: 760, height: 70)
    p.stroke(CGPath(rect: band, transform: nil), Pal.gold, 2.4, alpha: 0.8)
    for i in 0..<8 {
        let star = starPolygon(center: CGPoint(x: band.minX + 50 + CGFloat(i) * 95, y: band.midY), points: 8, rOuter: 22, rInner: 10)
        p.stroke(star, Pal.gold, 1.6, alpha: 0.8)
    }
    S.borderBand(p, y: 84, height: 56, col: Pal.indigo)
}

plate("guide-juz", seed: 63) { p in
    let c = CGPoint(x: 800, y: 620)
    S.girih(p, center: c, radius: 250, col: Pal.gold, layers: 2)
    for i in 0..<30 {
        let a = CGFloat(i) * 2 * .pi / 30 - .pi / 2
        let pt = CGPoint(x: c.x + cos(a) * 395, y: c.y + sin(a) * 395)
        if i % 15 == 0 {
            let star = starPolygon(center: pt, points: 8, rOuter: 26, rInner: 12)
            p.fill(star, Pal.rose, alpha: 0.85)
        } else {
            p.disc(center: pt, r: 15, col: i < 11 ? Pal.indigo : Pal.paperDark)
            p.ring(center: pt, r: 15, col: Pal.ink, width: 1.8, alpha: 0.6)
        }
    }
    p.ring(center: c, r: 440, col: Pal.ink, width: 2, alpha: 0.4)
}

plate("guide-khatm", seed: 64) { p in
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 180, y: 900))
    path.addCurve(to: CGPoint(x: 1420, y: 420), control1: CGPoint(x: 700, y: 1050), control2: CGPoint(x: 900, y: 280))
    p.stroke(path, Pal.indigo, 5, alpha: 0.6)
    for i in 0..<12 {
        let t = CGFloat(i) / 11
        let x = 180 + t * 1240
        let y = 900 + (sin(t * .pi) * -280) - t * 200 + 220 * t * t
        let cell = CGRect(x: x - 26, y: y - 34, width: 52, height: 68)
        let page = CGPath(roundedRect: cell, cornerWidth: 5, cornerHeight: 5, transform: nil)
        if i < 8 {
            p.fill(page, Pal.indigo, alpha: 0.7)
        } else {
            p.fill(page, Col(r: 0.99, g: 0.975, b: 0.94), alpha: 0.95)
            p.stroke(page, Pal.ink, 2, alpha: 0.6)
        }
    }
    let seal = CGPoint(x: 1420, y: 420)
    S.girih(p, center: seal, radius: 150, col: Pal.gold, layers: 2)
    let star = starPolygon(center: seal, points: 8, rOuter: 60, rInner: 27)
    p.fill(star, Pal.gold, alpha: 0.9)
    S.borderBand(p, y: 84, height: 56, col: Pal.rose)
}

plate("guide-ramadan", seed: 65) { p in
    p.paper(Pal.dusk.mix(Pal.paper, 0.5), bottom: Pal.paperDark)
    S.stars(p, above: 560, count: 34, col: Pal.gold)
    S.crescent(p, center: CGPoint(x: 800, y: 780), r: 170, col: Pal.goldSoft)
    hangLamp(p, cx: 420, topY: 560, size: 190, glow: true)
    hangLamp(p, cx: 1180, topY: 560, size: 190, glow: true)
    let band = CGRect(x: 250, y: 190, width: 1100, height: 90)
    pageGridBand(p, rect: band, cols: 15, rows: 2, filledUntil: 11, col: Pal.indigo)
}

plate("guide-pace", seed: 66) { p in
    hourGlass(p, cx: 800, cy: 620, size: 500)
    for i in 0..<14 {
        let a = CGFloat(i) * .pi / 13 + .pi
        let c = CGPoint(x: 800, y: 620)
        p.inkLine(
            from: CGPoint(x: c.x + cos(a) * 380, y: c.y - sin(a) * 380),
            to: CGPoint(x: c.x + cos(a) * CGFloat(420 + (i % 2) * 30), y: c.y - sin(a) * CGFloat(420 + (i % 2) * 30)),
            Pal.gold, 2.4, alpha: 0.55
        )
    }
    S.borderBand(p, y: 84, height: 56, col: Pal.gold)
    S.borderBand(p, y: 1060, height: 56, col: Pal.gold)
}

plate("guide-surah", seed: 67) { p in
    let sheet = CGRect(x: 420, y: 200, width: 760, height: 820)
    p.fill(CGPath(roundedRect: sheet, cornerWidth: 10, cornerHeight: 10, transform: nil), Col(r: 0.99, g: 0.975, b: 0.94), alpha: 0.97)
    p.stroke(CGPath(roundedRect: sheet, cornerWidth: 10, cornerHeight: 10, transform: nil), Pal.ink, 3.4, alpha: 0.85)
    let header = CGRect(x: sheet.minX + 40, y: sheet.maxY - 150, width: sheet.width - 80, height: 100)
    p.fill(CGPath(roundedRect: header, cornerWidth: 12, cornerHeight: 12, transform: nil), Pal.indigo, alpha: 0.12)
    p.stroke(CGPath(roundedRect: header, cornerWidth: 12, cornerHeight: 12, transform: nil), Pal.gold, 2.6, alpha: 0.9)
    let star1 = starPolygon(center: CGPoint(x: header.minX + 46, y: header.midY), points: 8, rOuter: 30, rInner: 14)
    let star2 = starPolygon(center: CGPoint(x: header.maxX - 46, y: header.midY), points: 8, rOuter: 30, rInner: 14)
    p.stroke(star1, Pal.gold, 2, alpha: 0.9)
    p.stroke(star2, Pal.gold, 2, alpha: 0.9)
    for i in 0..<11 {
        let y = sheet.maxY - 220 - CGFloat(i) * 56
        p.inkLine(
            from: CGPoint(x: sheet.minX + 60, y: y),
            to: CGPoint(x: sheet.maxX - 60, y: y),
            Pal.indigo, 2, alpha: i % 5 == 4 ? 0.2 : 0.45
        )
        if i % 5 == 4 {
            p.disc(center: CGPoint(x: sheet.midX, y: y), r: 9, col: Pal.gold, alpha: 0.85)
        }
    }
}

plate("guide-makki", seed: 68) { p in
    kaabaCube(p, cx: 440, baseY: 330, w: 300)
    S.mosqueBlock(p, x: 940, baseY: 330, bw: 420, col: Pal.emeraldDeep)
    p.inkLine(from: CGPoint(x: 800, y: 260), to: CGPoint(x: 800, y: 960), Pal.gold, 3, alpha: 0.5)
    let sun = CGPoint(x: 440, y: 950)
    p.disc(center: sun, r: 70, col: Pal.goldSoft)
    p.ring(center: sun, r: 70, col: Pal.ink, width: 2.2, alpha: 0.6)
    S.sunRays(p, center: sun, r: 70, col: Pal.gold)
    S.crescent(p, center: CGPoint(x: 1160, y: 950), r: 65, col: Pal.goldSoft)
    let ground = CGPath(rect: CGRect(x: 46, y: 46, width: 1508, height: 284), transform: nil)
    p.hatch(ground, angle: 0.05, spacing: 15, col: Pal.inkSoft, width: 1.1, alpha: 0.3)
}

plate("guide-tilawah", seed: 69) { p in
    rehalStand(p, cx: 800, baseY: 330, w: 560)
    openBook(p, cx: 800, baseY: 560, w: 640, lines: 9, col: Pal.indigo)
    hangLamp(p, cx: 330, topY: 700, size: 170, glow: true)
    hangLamp(p, cx: 1270, topY: 700, size: 170, glow: true)
    S.borderBand(p, y: 84, height: 56, col: Pal.emerald)
}

plate("guide-memory", seed: 70) { p in
    let grid = CGRect(x: 300, y: 330, width: 1000, height: 560)
    pageGridBand(p, rect: grid, cols: 7, rows: 5, filledUntil: 23, col: Pal.indigo)
    let ribbon = CGMutablePath()
    ribbon.move(to: CGPoint(x: grid.minX + grid.width * (2.5 / 7), y: grid.maxY + 8))
    ribbon.addQuadCurve(
        to: CGPoint(x: grid.minX + grid.width * (2.5 / 7) + 60, y: grid.maxY + 150),
        control: CGPoint(x: grid.minX + grid.width * (2.5 / 7) + 60, y: grid.maxY + 60)
    )
    p.stroke(ribbon, Pal.rose, 7, alpha: 0.85)
    S.borderBand(p, y: 110, height: 56, col: Pal.indigo)
}

plate("onboard-1", w: 1400, h: 1400, seed: 71) { p in
    S.girih(p, center: CGPoint(x: 700, y: 800), radius: 420, col: Pal.gold, layers: 2)
    rehalStand(p, cx: 700, baseY: 320, w: 620)
    openBook(p, cx: 700, baseY: 580, w: 680, lines: 9, col: Pal.indigo)
    S.borderBand(p, y: 80, height: 56, col: Pal.indigo)
}

plate("onboard-2", w: 1400, h: 1400, seed: 72) { p in
    let grid = CGRect(x: 220, y: 300, width: 960, height: 800)
    pageGridBand(p, rect: grid, cols: 8, rows: 7, filledUntil: 30, col: Pal.indigo)
    S.borderBand(p, y: 110, height: 56, col: Pal.gold)
    S.borderBand(p, y: 1230, height: 56, col: Pal.gold)
}

plate("onboard-3", w: 1400, h: 1400, seed: 73) { p in
    hourGlass(p, cx: 700, cy: 740, size: 560)
    for i in 0..<20 {
        let a = CGFloat(i) * .pi / 10
        let c = CGPoint(x: 700, y: 740)
        p.inkLine(
            from: CGPoint(x: c.x + cos(a) * 420, y: c.y + sin(a) * 420),
            to: CGPoint(x: c.x + cos(a) * CGFloat(460 + (i % 2) * 34), y: c.y + sin(a) * CGFloat(460 + (i % 2) * 34)),
            Pal.gold, 2.4, alpha: 0.5
        )
    }
    S.borderBand(p, y: 90, height: 56, col: Pal.rose)
}

plate("onboard-4", w: 1400, h: 1400, seed: 74) { p in
    p.paper(Pal.dusk.mix(Pal.ink, 0.2).mix(Pal.paper, 0.34), bottom: Pal.paperDark.mix(Pal.ink, 0.15))
    S.stars(p, above: 500, count: 40, col: Pal.goldSoft)
    S.crescent(p, center: CGPoint(x: 1020, y: 1100), r: 110, col: Pal.goldSoft)
    let c = CGPoint(x: 700, y: 700)
    p.ring(center: c, r: 260, col: Pal.goldSoft, width: 5, alpha: 0.35)
    let arc = CGMutablePath()
    arc.addArc(center: c, radius: 260, startAngle: .pi / 2, endAngle: .pi / 2 - .pi * 1.3, clockwise: true)
    p.stroke(arc, Pal.gold, 16, alpha: 0.9)
    S.girih(p, center: c, radius: 175, col: Pal.goldSoft, layers: 2)
    p.disc(center: CGPoint(x: c.x + cos(.pi / 2 - .pi * 1.3) * 260, y: c.y + sin(.pi / 2 - .pi * 1.3) * 260), r: 22, col: Pal.gold)
}

print("done")
