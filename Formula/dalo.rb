class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.9.0/dalo-0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "7c2fbf5dc0beed2dab1004264a71715bcf39f6e25d87f593ab492cb8c648633c"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.9.0/dalo-0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "697cb1f4138a4a744b9894776ab2ac5df5772790e366b00aaeb37bc83475bc7d"
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
