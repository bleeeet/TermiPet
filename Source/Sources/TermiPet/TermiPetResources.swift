import Foundation

enum TermiPetResources {
    private static let bundleName = "TermiPetApp_TermiPet.bundle"

    static let bundle: Bundle = {
        let candidates = [
            Bundle.main.resourceURL?.appendingPathComponent(bundleName),
            Bundle.main.bundleURL
                .appendingPathComponent("Contents")
                .appendingPathComponent("Resources")
                .appendingPathComponent(bundleName),
        ].compactMap { $0 }

        for url in candidates {
            if let bundle = Bundle(url: url) {
                return bundle
            }
        }

        return Bundle.main
    }()

    static func pngURL(named name: String) -> URL? {
        bundle.url(forResource: name, withExtension: "png")
    }
}
