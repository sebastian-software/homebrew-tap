class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.12.0/dalo-0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "30c317126af5e76811500d12f79eb38714e09b1797b6c3d6f585e8e117cb7361"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.12.0/dalo-0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "bb324c8e44e22c7350aa3c5cba0ca5036708827537d94d423e81feef5f68ddaa"
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
