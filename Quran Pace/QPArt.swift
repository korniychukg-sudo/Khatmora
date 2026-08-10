import SwiftUI
import UIKit

enum QPArt {
    private static let cache = NSCache<NSString, UIImage>()

    static func image(_ name: String) -> UIImage? {
        if let hit = cache.object(forKey: name as NSString) { return hit }
        var path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Art")
        if path == nil {
            path = Bundle.main.path(forResource: name, ofType: "png", inDirectory: "Art")
        }
        guard let p = path, let img = UIImage(contentsOfFile: p) else { return nil }
        cache.setObject(img, forKey: name as NSString)
        return img
    }
}

struct PaceArtImage: View {
    let name: String
    var body: some View {
        Group {
            if let ui = QPArt.image(name) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [QPTheme.indigoSoft, QPTheme.goldSoft],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            }
        }
    }
}

struct PaceArtPlate: View {
    let name: String
    var height: CGFloat = 180
    var corner: CGFloat = QPTheme.corner
    var body: some View {
        Color.clear
            .frame(height: height)
            .overlay(PaceArtImage(name: name))
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .strokeBorder(QPTheme.line, lineWidth: 1)
            )
    }
}
