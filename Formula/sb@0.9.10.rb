
class Sb < Formula
  desc "Ezmid Synkbridge Bundler CLI"
  homepage "https://www.synkbridge.com/"  # Your app's homepage
  version "0.9.10"
  on_macos do
    if ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY'].nil?
      odie "HOMEBREW_SYNKBRIDGE_STORE_KEY environment variable is required for installation. Please define it in your environment"
    end
    DEFAULT_STORE_API_URL = "https://api.store.synkbridge.com"
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || DEFAULT_STORE_API_URL
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.10/amd64"
      sha256 "ff676ad798d5cbc857f6b2dc4807c5882a3fc84d2c174f38879806f598e51ee1"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.10/arm64"
      sha256 "9be1e80fe3dd7419f72cf80031744fbc59e96b0537143858e660d253207a34b5"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end