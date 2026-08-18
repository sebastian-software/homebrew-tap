class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.13.0/dalo-0.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "8ae5a306d3c902ef50d3fa10cefa9163b61acad1b3a227793bc2e02d90cdb1ad"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.13.0/dalo-0.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "d57d275a84120f0d497f10233f3723f0c01989f4b2ea2d0c0561df0ced1041bb"
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
