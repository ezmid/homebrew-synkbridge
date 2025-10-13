
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
  version "0.14.0"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.14.0/amd64", using: BundlerCLIDownloadStrategy
      sha256 "3fa2b6c9260ff02433d1ed8f535e4719cc99ee74c03cebbd1ab9739e683a9747"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.14.0/arm64", using: BundlerCLIDownloadStrategy
      sha256 "c67f0a7452b972320e5ff56a3497f7111c7871f93a77563c8cc7e5e7efe2545d"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end