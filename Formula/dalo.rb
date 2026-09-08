class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.15.0/dalo-0.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "de65daf58f705e1099fd80f768b5a732b32d95181637cafcc965e5d485498de5"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.15.0/dalo-0.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "e166e8d5d78d71e2b9daaf3523753331863dd4629b8d8f21089ae699a02e9118"
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
