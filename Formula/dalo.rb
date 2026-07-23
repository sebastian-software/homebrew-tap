class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.11.0/dalo-0.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "868717f6b6890771dd34cfbad5131d0a3157b21138da89d974ceef017fa001c9"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.11.0/dalo-0.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "8cc007171bc0158a426183db2016fb073c6d2a0eea889cbe8547b4b7b53d8c4d"
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
