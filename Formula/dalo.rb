class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.14.10/dalo-0.14.10-aarch64-apple-darwin.tar.gz"
      sha256 "bf249c6e03e5964be62a3a455061de4493cfb868e5da9c4c2bdd110c1d412edb"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.14.10/dalo-0.14.10-x86_64-apple-darwin.tar.gz"
      sha256 "dd759b62f6f809f12e4de4234b00c954eeeba1f5a60dd1dd396cc9ec64e52c89"
    end
  end

  def install
    bin.install "dalo"
    bash_completion.install "completions/dalo.bash" => "dalo"
    zsh_completion.install "completions/_dalo"
    fish_completion.install "completions/dalo.fish"
    man1.install "man/man1/dalo.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalo --version")
  end
end
