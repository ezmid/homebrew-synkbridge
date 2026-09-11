
class BundlerCLIDownloadStrategy < CurlDownloadStrategy
  # Homebrew 6 replaces secret-looking environment variables with a deferred
  # placeholder while a formula is evaluated, and only Homebrew's own download
  # strategies may expand one, and only inside request headers. Interpolating the
  # token into `url` therefore produced a literal
  # "{{HOMEBREW_DEFERRED_ENV:HOMEBREW_SYNKBRIDGE_STORE_KEY}}" and every install failed
  # with "bad URI (is not URI?)".
  #
  # So the token is not interpolated at evaluation time at all. The formula ships a
  # literal placeholder segment, which keeps the URL parseable, and it is swapped for
  # the real value here. `url` rather than `fetch`, because the URI is parsed while
  # computing the cache path, long before fetch runs.
  def url
    @resolved_store_url ||= begin
      key = ENV.fetch("HOMEBREW_SYNKBRIDGE_STORE_KEY", nil)
      if key.nil? || key.empty?
        odie "HOMEBREW_SYNKBRIDGE_STORE_KEY environment variable is required for installation. Please define it in your environment"
      end
      super.sub("/homebrew/HOMEBREW_SYNKBRIDGE_STORE_KEY/", "/homebrew/#{key}/")
    end
  end
end

class SbAT0919 < Formula
  desc "Ezmid Synkbridge Bundler CLI"
  homepage "https://www.synkbridge.com/"
  version "0.9.19"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/HOMEBREW_SYNKBRIDGE_STORE_KEY/sb/0.9.19/amd64", using: BundlerCLIDownloadStrategy
      sha256 "a974cbb62ca13ba010fead1aff6939d2563c5c5e0f997d240fd3cd3988a735f8"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/HOMEBREW_SYNKBRIDGE_STORE_KEY/sb/0.9.19/arm64", using: BundlerCLIDownloadStrategy
      sha256 "cce355d971da6a4d32e8f2c82b9941eed1972fbfe55c2b95648c7e0b734845db"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end