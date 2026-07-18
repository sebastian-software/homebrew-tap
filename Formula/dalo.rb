class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.9.1/dalo-0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "d82fe31f0d09d16c365180e1475811679f18e377c8801a4719552f23e2f024cb"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.9.1/dalo-0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "ad71ac9f817b0f95944d7d1dc304b8baa0f4552c5dee85f44164ba98f8acd7ae"
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
