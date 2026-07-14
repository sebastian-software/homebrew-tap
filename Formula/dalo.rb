class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.8.0/dalo-0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "94d89ab62cd4b491268ef3afcf4408bd35ec663532b8557f770953630380d2d9"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.8.0/dalo-0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "39074cd6721a1b3bb7b72963e39da59c9e5042225448157727cf0db8cf97c7d7"
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
