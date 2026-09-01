class Dalo < Formula
  desc "Git-backed skill management for AI agents"
  homepage "https://dalo.sh"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.14.9/dalo-0.14.9-aarch64-apple-darwin.tar.gz"
      sha256 "31c75fe513f04542f3c72f06c9c5de0c979a3eae15f1344909dbbbd2c310e017"
    else
      url "https://github.com/sebastian-software/dalo/releases/download/dalo-v0.14.9/dalo-0.14.9-x86_64-apple-darwin.tar.gz"
      sha256 "13f53ee38a76321eda00bb5224678075da35d9b398b7c714e809a07eb6fb3649"
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
