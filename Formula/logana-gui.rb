class LoganaGui < Formula
  desc "GUI-only build of logana — turn any log source into structured data with a desktop app."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-gui-aarch64-apple-darwin.tar.xz"
      sha256 "31cd9a89f6052ba1ace862f59569665eaca980065efbe72d511bf45e965f55ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-gui-x86_64-apple-darwin.tar.xz"
      sha256 "d13e4540b2453442ca54372442de65511ae23e08a594b0930c7bf10f0b77b52f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e15275ebad6b281c4e2ab92979c00cdb91758271f2797e381739ddd2c6c0449"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb6c0b838ef8e3943d205858903ac3533aba49ad8ba420963b66ca9405e69ca3"
    end
  end
  license "GPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "logana-gui"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "logana-gui"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "logana-gui"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "logana-gui"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
