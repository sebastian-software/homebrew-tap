class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.8.2/dalo-0.8.2-aarch64-apple-darwin.tar.gz"
      sha256 "27a2fb957c2a38ac5612b2731e90b24a369a35dee5e6b97e263582c9dd990003"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.8.2/dalo-0.8.2-x86_64-apple-darwin.tar.gz"
      sha256 "774c140e64a31ca1a847ff83cfbb8f19487abc4cd7ffe8dfc606b8d7455d445c"
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
