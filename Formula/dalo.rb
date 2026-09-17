class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.16.0/dalo-0.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "2068d39d0a659db23320f43c53ba2cc5c1b7a1390791f88cf026edf91783cbea"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.16.0/dalo-0.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "3ec0c252ad8369a5dedd012ef610fd4a51ccb3f9f8ad546305ad3bf22eb10784"
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
