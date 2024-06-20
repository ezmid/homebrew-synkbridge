
class Sb < Formula
  desc "Ezmid Synkbridge Bundler CLI"
  homepage "https://www.synkbridge.com/"  # Your app's homepage
  version "0.9.11"
  on_macos do
    if ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY'].nil?
      odie "HOMEBREW_SYNKBRIDGE_STORE_KEY environment variable is required for installation. Please define it in your environment"
    end
    DEFAULT_STORE_API_URL = "https://api.store.synkbridge.com"
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || DEFAULT_STORE_API_URL
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.11/amd64"
      sha256 "a0377c4d404ea275f1ead1b181bd0b7ac2fa563e24d1e72430f18d1b9c92b709"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.11/arm64"
      sha256 "cc02608fa92eac7edfca4569ff11f09b5f803af1b32614df42a2d02b62477fc1"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end