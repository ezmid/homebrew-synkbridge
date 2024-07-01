
class BundlerCLIDownloadStrategy < CurlDownloadStrategy
  def fetch(timeout: nil, **options)
    if ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY'].nil?
      odie "HOMEBREW_SYNKBRIDGE_STORE_KEY environment variable is required for installation. Please define it in your environment"
    end
    super
  end
end

class Sb < Formula
  desc "Ezmid Synkbridge Bundler CLI"
  homepage "https://www.synkbridge.com/"
  version "0.9.14"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.14/amd64", using: BundlerCLIDownloadStrategy
      sha256 "314dc60f0bc2e8d5298dcffd856e4fc3fb9e567076fb350d762c071a143dbc14"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.14/arm64", using: BundlerCLIDownloadStrategy
      sha256 "2c412cf0e3ca1bb369b9ab46b965b5dff820ed3967cd29d5369d8a26fe628147"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end