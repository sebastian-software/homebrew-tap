class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.8.1/dalo-0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "c212ad0d0c68921c792afdffc6834cc0b3639de863b7302cb63fbc7e65f95371"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.8.1/dalo-0.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "2e25d1d9b7c053de3a76d3c06b847b02cca2632c1db555db06421de754931bc4"
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
