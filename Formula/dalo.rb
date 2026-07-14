class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.7.2/dalo-0.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "477a3f25dba83cf3884390d7accff8a635e38507f4698f9ed80917e0f6eb58a9"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.7.2/dalo-0.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "4de2646d9475c64fac39e164cbd82268b3f88518964ac9ecba9558f9a4e83334"
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
