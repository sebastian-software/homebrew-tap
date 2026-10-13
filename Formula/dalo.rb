class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  url "https://github.com/sebastian-software/dalo/releases/download/dalo-v1.7.0/dalo-1.7.0-aarch64-apple-darwin.tar.gz"
  sha256 "028b58001dc9df68e02371931d752875989a66c70818691e963808c30e919738"
  license "MIT"

  # Dalo dropped its Intel macOS build with 1.0. Declaring the requirement
  # makes an Intel Mac fail with Homebrew's own architecture error instead of
  # a 404 on an archive that no release produces.
  depends_on arch: :arm64
  depends_on :macos

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
