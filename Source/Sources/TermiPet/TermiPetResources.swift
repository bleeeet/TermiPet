import Foundation

enum TermiPetResources {
    private static let bundleName = "TermiPetApp_TermiPet.bundle"

    static func pngURL(named name: String) -> URL? {
        resourceURL(named: name, extension: "png")
    }

    static func resourceURL(named name: String, `extension`: String) -> URL? {
        for root in searchRoots {
            if let url = directResourceURL(named: name, extension: `extension`, root: root) {
                return url
            }

            if let bundleResourceURL = nestedBundleResourceURL(named: name, extension: `extension`, root: root) {
                return bundleResourceURL
            }
        }
        return nil
    }

    private static var searchRoots: [URL] {
        [
            Bundle.main.resourceURL,
            Bundle.main.bundleURL
                .appendingPathComponent("Contents")
                .appendingPathComponent("Resources"),
            Bundle.main.bundleURL,
        ].compactMap { $0 }
    }

    private static func directResourceURL(named name: String, extension: String, root: URL) -> URL? {
        let url = root.appendingPathComponent(name).appendingPathExtension(`extension`)
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    private static func nestedBundleResourceURL(named name: String, extension: String, root: URL) -> URL? {
        let bundleURL = root.appendingPathComponent(bundleName)
        let resourceURL = bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent(name)
            .appendingPathExtension(`extension`)
        return FileManager.default.fileExists(atPath: resourceURL.path) ? resourceURL : nil
    }
}
