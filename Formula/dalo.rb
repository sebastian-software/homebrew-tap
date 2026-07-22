class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.10.0/dalo-0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "cd4c2227bfbcb2fd4dca35fce925ae1ddd24bfd3312c647d61fe91b0349ef593"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.10.0/dalo-0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "0399f04387aa07bfa57aa03406a86845f18fd077c44bac399f21d1f11bcb7a4f"
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
