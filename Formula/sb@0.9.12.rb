
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
  version "0.9.12"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.12/amd64", using: BundlerCLIDownloadStrategy
      sha256 "b9421c22eb4db7dae7110f2b7ebc00550e8404f2d427fdd7ace8721ddcabaf87"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.12/arm64", using: BundlerCLIDownloadStrategy
      sha256 "cbed34cc308768bc22011dfbbef1caeaada9ff3083c09bcb2c42ff673d93db25"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end