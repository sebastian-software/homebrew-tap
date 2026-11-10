class Mdtheme < Formula
  desc "Compose Markdown with reusable local and Git themes"
  homepage "https://github.com/sebastian-software/mdtheme"
  license "MIT"

  depends_on "git"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.1/mdtheme-aarch64-apple-darwin.tar.gz"
      sha256 "b52e9708ba786d334bf7ee7899831a77cd1a4e183c01248ad1d4a3cb7656aef2"
    else
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.1/mdtheme-x86_64-apple-darwin.tar.gz"
      sha256 "ebd28f155b52983631ed53beb9515742d11b3acf66274bcd9470359a13685670"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.1/mdtheme-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f777c142655701e2bfb6251a0b06410ae20a4f64d8b3ae8161cf773949c87f85"
    else
      url "https://github.com/sebastian-software/mdtheme/releases/download/mdtheme-v0.4.1/mdtheme-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ae310bff86f32721c72c54f94614dd2b7e6793e0aaef4d6b501011cfe290bcb"
    end
  end

  def install
    bin.install "mdtheme"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdtheme --version")
  end
end
