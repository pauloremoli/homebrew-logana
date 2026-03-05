class Logana < Formula
  desc "A fast, keyboard-driven terminal log viewer and analyzer with filtering, search, and annotations."
  homepage "https://github.com/pauloremoli/logana"
  version "0.1.0"
  license "GPL-3.0-only"

  on_macos do
    on_intel do
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER"
    end
    on_arm do
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER"
    end
  end

  def install
    bin.install "logana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/logana --version")
  end
end
