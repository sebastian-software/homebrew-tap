class Mdtheme < Formula
  desc "Compose Markdown with reusable local and Git themes"
  homepage "https://github.com/sebastian-software/mdtheme"
  license "MIT"

  depends_on "git"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.0/mdtheme-aarch64-apple-darwin.tar.gz"
      sha256 "201243574c27f7c8544c32aa127df9a01e70786ca1eb70c65bdc808c872a2602"
    else
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.0/mdtheme-x86_64-apple-darwin.tar.gz"
      sha256 "15736659034616f11126ecf90502083af8763b1dc4216db933086f8bd6f0ef16"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.0/mdtheme-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1b3757e23cc189dbd59bbad7bbfc25f772ac117cd559f29b27e77af538ca9d5c"
    else
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.0/mdtheme-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b6c6ef4376833c415794850e4a0e9d6d1fafa0d5877d0a14832eee3ea6d086fc"
    end
  end

  def install
    bin.install "mdtheme"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdtheme --version")
  end
end
