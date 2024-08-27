
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
  version "0.9.18"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.18/amd64", using: BundlerCLIDownloadStrategy
      sha256 "cac1e92812cb2e1397e497f39b0ba598bb7d2c164861783e1c482ccfab7fd654"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.18/arm64", using: BundlerCLIDownloadStrategy
      sha256 "fcd87c42ae756de24c28c38b43aafc578c84ac0529d37551ff1f1546673acdbb"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end