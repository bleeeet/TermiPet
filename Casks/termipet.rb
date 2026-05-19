cask "termipet" do
  version "0.1.1"
  sha256 "12ce70e0eba9030ab2dca58851faa1826102aeba84609ebd4ecfa62362b19e3a"

  url "https://github.com/bleeeet/TermiPet/releases/download/v#{version}/TermiPet-v#{version}-macOS.zip"
  name "TermiPet"
  desc "Desktop pet assistant for terminals and AI coding tools"
  homepage "https://github.com/bleeeet/TermiPet"

  depends_on macos: :sonoma

  app "TermiPet.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/TermiPet.app"],
                   sudo: true
  end
end
