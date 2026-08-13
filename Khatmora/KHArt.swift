import SwiftUI
import UIKit

enum KHArt {
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

struct KhatmoraArtImage: View {
    let name: String
    var body: some View {
        Group {
            if let ui = KHArt.image(name) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                LinearGradient(
                    colors: [KHTheme.indigoSoft, KHTheme.goldSoft],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            }
        }
    }
}

struct KhatmoraArtPlate: View {
    let name: String
    var height: CGFloat = 180
    var corner: CGFloat = KHTheme.corner
    var body: some View {
        Color.clear
            .frame(height: height)
            .overlay(KhatmoraArtImage(name: name))
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .strokeBorder(KHTheme.line, lineWidth: 1)
            )
    }
}
