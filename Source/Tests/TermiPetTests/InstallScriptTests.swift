import XCTest

final class InstallScriptTests: XCTestCase {
    private var installScript: String {
        get throws {
            let scriptURL = repoRoot.appendingPathComponent("install.sh")
            return try String(contentsOf: scriptURL, encoding: .utf8)
        }
    }

    private var buildScript: String {
        get throws {
            let scriptURL = repoRoot
                .appendingPathComponent("Scripts")
                .appendingPathComponent("build-plugin.sh")
            return try String(contentsOf: scriptURL, encoding: .utf8)
        }
    }

    private var homebrewCask: String {
        get throws {
            let caskURL = repoRoot
                .appendingPathComponent("Casks")
                .appendingPathComponent("termipet.rb")
            return try String(contentsOf: caskURL, encoding: .utf8)
        }
    }

    private var readme: String {
        get throws {
            let readmeURL = repoRoot.appendingPathComponent("README.md")
            return try String(contentsOf: readmeURL, encoding: .utf8)
        }
    }

    private var repoRoot: URL {
        let testFile = URL(fileURLWithPath: #filePath)
        return testFile
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    func testInstallScriptDownloadsLatestReleaseAppToApplications() throws {
        let script = try installScript

        XCTAssertTrue(script.contains("https://api.github.com/repos/bleeeet/TermiPet/releases/latest"))
        XCTAssertTrue(script.contains("TermiPet-v*-macOS.zip"))
        XCTAssertTrue(script.contains("/Applications/TermiPet.app"))
        XCTAssertTrue(script.contains("xattr -cr"))
        XCTAssertTrue(script.contains("open \"$APP_PATH\""))
    }

    func testInstallScriptAvoidsForbiddenBulkDeletionCommands() throws {
        let script = try installScript
        assertNoForbiddenBulkDeletionCommands(in: script, scriptName: "install.sh")
    }

    func testBuildScriptAvoidsForbiddenBulkDeletionCommands() throws {
        let script = try buildScript
        assertNoForbiddenBulkDeletionCommands(in: script, scriptName: "Scripts/build-plugin.sh")
    }

    func testHomebrewCaskInstallsTermiPetReleaseApp() throws {
        let cask = try homebrewCask

        XCTAssertTrue(cask.contains("cask \"termipet\" do"))
        XCTAssertTrue(cask.contains("version \"0.1\""))
        XCTAssertTrue(cask.contains("sha256 \"ae281c823068398bdfd553f00f6484a36f8763dd522a386641311920a0ad7f6a\""))
        XCTAssertTrue(cask.contains("https://github.com/bleeeet/TermiPet/releases/download/v#{version}/TermiPet-v#{version}-macOS.zip"))
        XCTAssertTrue(cask.contains("app \"TermiPet.app\""))
    }

    func testReadmeShowsHomebrewInstallCommands() throws {
        let readme = try readme

        XCTAssertTrue(readme.contains("brew tap bleeeet/termipet"))
        XCTAssertTrue(readme.contains("brew install --cask termipet"))
        XCTAssertTrue(readme.contains("brew install --cask bleeeet/termipet/termipet"))
    }

    private func assertNoForbiddenBulkDeletionCommands(
        in script: String,
        scriptName: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let forbiddenPatterns = [
            "rm -rf",
            "rm -r",
            "rm -R",
            "rm *",
            "find . -delete",
            "find . -exec rm",
            "xargs rm",
        ]

        for pattern in forbiddenPatterns {
            XCTAssertFalse(
                script.contains(pattern),
                "\(scriptName) must not contain \(pattern)",
                file: file,
                line: line
            )
        }
    }
}
