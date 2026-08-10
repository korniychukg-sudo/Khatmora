import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

@main
struct PaceIconGen {
    static func main() {
        let size = 1024
        let cs = CGColorSpace(name: CGColorSpace.sRGB)!
        let ctx = CGContext(
            data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
            space: cs, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )!
        let S = CGFloat(size)
        let c = CGPoint(x: S / 2, y: S / 2)

        let bgTop = CGColor(red: 0.955, green: 0.937, blue: 0.89, alpha: 1)
        let bgBot = CGColor(red: 0.874, green: 0.847, blue: 0.776, alpha: 1)
        let bg = CGGradient(colorsSpace: cs, colors: [bgTop, bgBot] as CFArray, locations: [0, 1])!
        ctx.drawLinearGradient(bg, start: CGPoint(x: 0, y: S), end: CGPoint(x: 0, y: 0), options: [])

        let glow = CGGradient(
            colorsSpace: cs,
            colors: [
                CGColor(red: 0.914, green: 0.851, blue: 0.675, alpha: 0.5),
                CGColor(red: 0.914, green: 0.851, blue: 0.675, alpha: 0)
            ] as CFArray,
            locations: [0, 1]
        )!
        ctx.drawRadialGradient(glow, startCenter: c, startRadius: 0, endCenter: c, endRadius: S * 0.52, options: [])

        let ringR = S * 0.3
        let ringW = S * 0.088
        ctx.setStrokeColor(CGColor(red: 0.173, green: 0.231, blue: 0.4, alpha: 0.18))
        ctx.setLineWidth(ringW)
        ctx.strokeEllipse(in: CGRect(x: c.x - ringR, y: c.y - ringR, width: ringR * 2, height: ringR * 2))

        ctx.setLineCap(.round)
        let start = CGFloat.pi / 2
        let end = start - .pi * 2 * 0.72
        let steps = 220
        for i in 0..<steps {
            let t = CGFloat(i) / CGFloat(steps - 1)
            let a0 = start + (end - start) * t
            let shade = 0.75 + 0.25 * t
            ctx.setStrokeColor(CGColor(red: 0.173 * shade + 0.1 * (1 - shade), green: 0.231 * shade + 0.14 * (1 - shade), blue: 0.4 * shade + 0.22 * (1 - shade), alpha: 1))
            ctx.setLineWidth(ringW)
            ctx.beginPath()
            let p1 = CGPoint(x: c.x + cos(a0) * ringR, y: c.y + sin(a0) * ringR)
            ctx.move(to: p1)
            let a1 = a0 + (end - start) / CGFloat(steps - 1) * 1.5
            ctx.addLine(to: CGPoint(x: c.x + cos(a1) * ringR, y: c.y + sin(a1) * ringR))
            ctx.strokePath()
        }

        let tip = CGPoint(x: c.x + cos(end) * ringR, y: c.y + sin(end) * ringR)
        let pipR = ringW * 0.78
        let pip = CGGradient(
            colorsSpace: cs,
            colors: [
                CGColor(red: 0.949, green: 0.855, blue: 0.62, alpha: 1),
                CGColor(red: 0.706, green: 0.537, blue: 0.184, alpha: 1),
                CGColor(red: 0.44, green: 0.33, blue: 0.1, alpha: 1)
            ] as CFArray,
            locations: [0, 0.6, 1]
        )!
        ctx.saveGState()
        ctx.addEllipse(in: CGRect(x: tip.x - pipR, y: tip.y - pipR, width: pipR * 2, height: pipR * 2))
        ctx.clip()
        ctx.drawRadialGradient(
            pip,
            startCenter: CGPoint(x: tip.x - pipR * 0.3, y: tip.y + pipR * 0.35), startRadius: pipR * 0.1,
            endCenter: tip, endRadius: pipR * 1.5,
            options: []
        )
        ctx.restoreGState()

        let star = CGMutablePath()
        let sr = S * 0.085
        for i in 0..<16 {
            let a = CGFloat(i) * .pi / 8 - .pi / 2
            let r = i % 2 == 0 ? sr : sr * 0.45
            let pt = CGPoint(x: c.x + cos(a) * r, y: c.y + sin(a) * r)
            if i == 0 { star.move(to: pt) } else { star.addLine(to: pt) }
        }
        star.closeSubpath()
        ctx.setFillColor(CGColor(red: 0.706, green: 0.537, blue: 0.184, alpha: 0.9))
        ctx.addPath(star)
        ctx.fillPath()

        for (dx, dy, s) in [(0.33, 0.3, 0.016), (-0.35, -0.27, 0.012)] {
            let p = CGPoint(x: c.x + S * CGFloat(dx), y: c.y + S * CGFloat(dy))
            let r = S * CGFloat(s)
            let spark = CGMutablePath()
            for i in 0..<8 {
                let a = CGFloat(i) * .pi / 4
                let rr = i % 2 == 0 ? r * 2.2 : r * 0.8
                let pt = CGPoint(x: p.x + cos(a) * rr, y: p.y + sin(a) * rr)
                if i == 0 { spark.move(to: pt) } else { spark.addLine(to: pt) }
            }
            spark.closeSubpath()
            ctx.setFillColor(CGColor(red: 0.949, green: 0.855, blue: 0.62, alpha: 0.9))
            ctx.addPath(spark)
            ctx.fillPath()
        }

        let img = ctx.makeImage()!
        let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "AppIcon-1024.png"
        let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: out) as CFURL, UTType.png.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(dest, img, nil)
        CGImageDestinationFinalize(dest)
        print("icon saved")
    }
}
