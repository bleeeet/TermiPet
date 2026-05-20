cask "termipet" do
  version "0.1.2"
  sha256 "9a85e79890c8f970d33e7c5a958d5a2db477aa66f1f4647b15e40da739f95a0f"

  url "https://github.com/bleeeet/TermiPet/releases/download/v#{version}/TermiPet-v#{version}-macOS.zip"
  name "TermiPet"
  desc "Desktop pet assistant for terminals and AI coding tools"
  homepage "https://github.com/bleeeet/TermiPet"

  depends_on macos: :ventura

  app "TermiPet.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/TermiPet.app"],
                   sudo: true
  end
end
