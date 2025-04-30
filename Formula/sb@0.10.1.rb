
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
  version "0.10.1"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.10.1/amd64", using: BundlerCLIDownloadStrategy
      sha256 "18797587cfd94a8168f2694b02d111cd663c8a99f7601d4b18ddb7d01a35018b"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.10.1/arm64", using: BundlerCLIDownloadStrategy
      sha256 "ad3edad17cdd6a3902ad3397c12f94b1a852d446f193bcf39143e1f5b570c8fb"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end