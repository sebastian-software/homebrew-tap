class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.10.1/dalo-0.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "75a927e1bf2ae543a0c27bdbf514f55f1b84fff75730518bab5d423ed7f380e7"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.10.1/dalo-0.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "d133468c645b010bd3892fea6d81ece8064d426d5b81469f79936e3ac4651548"
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
