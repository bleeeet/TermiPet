import TermiPetCore
import SwiftUI

struct PetSpriteView: View {
    let package: PetPackage?
    let action: Int

    @State private var actionStartDate: Date = .now

    var body: some View {
        TimelineView(.periodic(from: actionStartDate, by: 0.16)) { context in
            content(frame: frameIndex(for: context.date))
        }
        .id(action)
        .onAppear {
            actionStartDate = .now
        }
        .onChangeCompat(of: action) { _ in
            actionStartDate = .now
        }
    }

    @ViewBuilder
    private func content(frame: Int) -> some View {
        if let image = PetSpriteCache.shared.frame(package: package, action: action, frame: frame) {
            Image(nsImage: image)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
        } else {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.primary)
        }
    }

    private func frameIndex(for date: Date) -> Int {
        guard let grid = PetSpriteCache.shared.grid(package: package) else { return 0 }
        let elapsed = date.timeIntervalSince(actionStartDate)
        let tick = Int(elapsed / 0.16)
        return tick % grid.validFrameCount(forAction: action)
    }
}

struct StaticPetSpriteView: View {
    let package: PetPackage?
    var action = 0
    var frame = 0

    var body: some View {
        if let image = PetSpriteCache.shared.frame(package: package, action: action, frame: frame) {
            Image(nsImage: image)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
        } else {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.primary)
        }
    }
}

@MainActor
private final class PetSpriteCache {
    static let shared = PetSpriteCache()

    private var packageKey: String?
    private var spriteInfo: SpriteInfo?
    private var frames: [FrameKey: NSImage] = [:]

    func grid(package: PetPackage?) -> PetSpritesheetGrid? {
        spriteInfo(package: package)?.grid
    }

    func frame(package: PetPackage?, action: Int, frame: Int) -> NSImage? {
        guard let spriteInfo = spriteInfo(package: package) else { return nil }
        let key = FrameKey(action: action, frame: frame)
        if let image = frames[key] {
            return image
        }

        let rect = spriteInfo.grid.frameRect(action: action, frame: frame)
        let cropRect = CGRect(x: rect.x, y: rect.y, width: rect.width, height: rect.height)
        guard let cropped = spriteInfo.cgImage.cropping(to: cropRect) else { return nil }
        let image = NSImage(cgImage: cropped, size: NSSize(width: rect.width, height: rect.height))
        frames[key] = image
        return image
    }

    private func spriteInfo(package: PetPackage?) -> SpriteInfo? {
        guard let package else { return nil }
        let key = package.spritesheetURL.path
        if packageKey == key, let spriteInfo {
            return spriteInfo
        }

        guard let image = NSImage(contentsOf: package.spritesheetURL),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            packageKey = key
            spriteInfo = nil
            frames.removeAll()
            return nil
        }

        let grid = PetSpritesheetGrid.infer(pixelWidth: cgImage.width, pixelHeight: cgImage.height)
        let info = SpriteInfo(cgImage: cgImage, grid: grid)
        packageKey = key
        spriteInfo = info
        frames.removeAll()
        return info
    }
}

private struct FrameKey: Hashable {
    var action: Int
    var frame: Int
}

private struct SpriteInfo {
    var cgImage: CGImage
    var grid: PetSpritesheetGrid
}
