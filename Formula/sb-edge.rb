
class BundlerCLIDownloadStrategy < CurlDownloadStrategy
  def fetch(timeout: nil, **options)
    if ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY'].nil?
      odie "HOMEBREW_SYNKBRIDGE_STORE_KEY environment variable is required for installation. Please define it in your environment"
    end
    super
  end
end

class SbEdge < Formula
  desc "SynkBridge CLI"
  homepage "https://www.synkbridge.com/"
  version "539"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb-edge/539/amd64", using: BundlerCLIDownloadStrategy
      sha256 ""
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb-edge/539/arm64", using: BundlerCLIDownloadStrategy
      sha256 ""
    end
  end

  def install
    bin.install "sb-edge"
  end

  test do
    system "#{bin}/sb-edge", "--version"
  end
end