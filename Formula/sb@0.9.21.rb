
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

class SbAT0921 < Formula
  desc "Ezmid Synkbridge Bundler CLI"
  homepage "https://www.synkbridge.com/"
  version "0.9.21"
  on_macos do
    STORE_API_URL = ENV['HOMEBREW_SYNKBRIDGE_STORE_API_URL'] || "https://api.store.synkbridge.com/v1"
    if Hardware::CPU.intel?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/HOMEBREW_SYNKBRIDGE_STORE_KEY/sb/0.9.21/amd64", using: BundlerCLIDownloadStrategy
      sha256 "938a04023083ee85e48bc6f2131b868ab4d904901099c9ee7796bde9aeb20dc0"
    elsif Hardware::CPU.arm?
      url "#{STORE_API_URL}/bundler-cli-repository/homebrew/HOMEBREW_SYNKBRIDGE_STORE_KEY/sb/0.9.21/arm64", using: BundlerCLIDownloadStrategy
      sha256 "e76d5f7ad117361d5968e89e4e9dbe69c4a5f6123082344bb41f19292e75a361"
    end
  end

  def install
    bin.install "sb"
  end

  test do
    system "#{bin}/sb", "--version"
  end
end