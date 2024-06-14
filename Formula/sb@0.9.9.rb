
class Sb < Formula
  desc "Ezmid Synkbridge Bundler CLI"
  homepage "https://www.synkbridge.com/"  # Your app's homepage
  version "0.9.9"
  on_macos do
    if ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY'].nil?
      odie "HOMEBREW_SYNKBRIDGE_STORE_KEY environment variable is required for installation. Please define it in your environment"
    end
    DEFAULT_STORE_API_URL = "https://api.store.synkbridge.com"
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || DEFAULT_STORE_API_URL
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.9/amd64"
      sha256 "c11fbcd996d09704539193e6caa1bbec1c0c59486d436bb1e6700f2ddf97fbcd"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/#{ENV['HOMEBREW_SYNKBRIDGE_STORE_KEY']}/sb/0.9.9/arm64"
      sha256 "ec4270ccc31e341d47acbdb716410044bd17318fff4ef8d220272e88f594e71d"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end