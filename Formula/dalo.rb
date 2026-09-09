class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.15.1/dalo-0.15.1-aarch64-apple-darwin.tar.gz"
      sha256 "4f48938350a1166a9a536416691d6f1154f225c9fa483d4a446d2f36a52236c8"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.15.1/dalo-0.15.1-x86_64-apple-darwin.tar.gz"
      sha256 "40b89db8ff1714dcabe914e177ae078a47f3b7667ca83b5a9e4b2d683cb079ab"
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
