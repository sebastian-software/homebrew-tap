class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.9.2/dalo-0.9.2-aarch64-apple-darwin.tar.gz"
      sha256 "097a7164b5f4ec70ed6ea2e48f6e0ff8445c2d1fd200b6fd8fb51f7f85856c69"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.9.2/dalo-0.9.2-x86_64-apple-darwin.tar.gz"
      sha256 "eae6729fdb56a8bd1ba3facc2caac4789556071d11c02effcd5de2ad43d29236"
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
