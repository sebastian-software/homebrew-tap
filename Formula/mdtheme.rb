class Mdtheme < Formula
  desc "Compose Markdown with reusable local and Git themes"
  homepage "https://github.com/sebastian-software/mdtheme"
  version "0.3.1"
  license "MIT"

  depends_on "git"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.3.1/mdtheme-aarch64-apple-darwin.tar.gz"
      sha256 "1235ab165701f1eeef7927dc111f05228b9766577f681100aa0af6af75f553f4"
    else
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.3.1/mdtheme-x86_64-apple-darwin.tar.gz"
      sha256 "d68c82157de6a746264a2f5ca1924c90253742deecdc499cde3748254da60abf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.3.1/mdtheme-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "abe6670de433496b56e3dca0d31e264269ce6012fe7d77215dac04671c00a885"
    else
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.3.1/mdtheme-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "988bcd7daa2afff5950a5f216f8727c0d613685d18841cd0d1e3c89d4c04ca77"
    end
  end

  def install
    bin.install "mdtheme"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdtheme --version")
  end
end
