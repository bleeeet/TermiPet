# Changelog

## [0.1.2] - 2026-05-20

- Lowered the minimum supported macOS version to 13.0.
- Made SwiftPM resource loading more resilient for packaged releases.
- Added build-time validation for the bundled resources.
- Updated README and Homebrew cask install info.

## [0.1.1] - 2026-05-19

- Fixed the Homebrew/Release launch crash caused by the SwiftPM resource bundle lookup path.
- Switched release packaging to a universal build for Apple Silicon and Intel Macs.
- Updated the Homebrew cask and added quarantine cleanup for the non-notarized build.
- Packaged a clean zip without macOS metadata files.

Thanks @Dinny-xu and @Gnonymous for reporting and helping diagnose the install issue.

## [0.1] - 2026-05-17

- Initial release.

[0.1.2]: https://github.com/bleeeet/TermiPet/releases/tag/v0.1.2
[0.1.1]: https://github.com/bleeeet/TermiPet/releases/tag/v0.1.1
[0.1]: https://github.com/bleeeet/TermiPet/releases/tag/v0.1
