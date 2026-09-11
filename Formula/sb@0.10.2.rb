
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

class SbAT0102 < Formula
  desc "Ezmid Synkbridge Bundler CLI"
  homepage "https://www.synkbridge.com/"
  version "0.10.2"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/HOMEBREW_SYNKBRIDGE_STORE_KEY/sb/0.10.2/amd64", using: BundlerCLIDownloadStrategy
      sha256 "f110967a124ca871b2b1f898ddeff26091cf083c56f60c221988bdea38042c12"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/HOMEBREW_SYNKBRIDGE_STORE_KEY/sb/0.10.2/arm64", using: BundlerCLIDownloadStrategy
      sha256 "7217f908b877e0937cbeb8e71f23f91b0996e115b2f82aaf61ec59a77a1f1848"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end