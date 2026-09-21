#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
require "uri"

TAG_PATTERN = /\A(?:dalo-)?v(\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?)\z/
# Dalo dropped its Intel macOS build with 1.0, so only the Apple Silicon
# archive is published. Fetching an Intel checksum here would abort every
# release dispatch on a file that no longer exists.
TARGET = "aarch64-apple-darwin"

def fetch(uri, redirects_left = 5)
  response = Net::HTTP.get_response(uri)

  case response
  when Net::HTTPSuccess
    response.body
  when Net::HTTPRedirection
    abort "Too many redirects while fetching #{uri}" if redirects_left.zero?

    location = URI(response["location"] || abort("Redirect from #{uri} has no location"))
    abort "Refusing a non-HTTPS redirect from #{uri}" unless location.is_a?(URI::HTTPS)

    fetch(location, redirects_left - 1)
  else
    abort "Could not fetch #{uri}: HTTP #{response.code}"
  end
end

tag = ARGV.fetch(0) do
  warn "Usage: update_dalo_formula.rb [dalo-]v<version>"
  exit 1
end

match = TAG_PATTERN.match(tag)
abort "Invalid Dalo release tag: #{tag}" unless match

version = match[1]
release_base = "https://github.com/sebastian-software/dalo/releases/download/#{tag}"

archive = "dalo-#{version}-#{TARGET}.tar.gz"
checksum_uri = URI("#{release_base}/#{archive}.sha256")
checksum_match = /\A([0-9a-f]{64})\s+#{Regexp.escape(archive)}\s*\z/.match(fetch(checksum_uri))
abort "Invalid checksum file for #{archive}" unless checksum_match

checksum = checksum_match[1]

formula = <<~RUBY
  class Dalo < Formula
    desc "Git-backed skill management for AI agents"
    homepage "https://dalo.sh"
    url "#{release_base}/#{archive}"
    sha256 "#{checksum}"
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
      assert_match version.to_s, shell_output("\#{bin}/dalo --version")
    end
  end
RUBY

File.write(File.expand_path("../../Formula/dalo.rb", __dir__), formula)
