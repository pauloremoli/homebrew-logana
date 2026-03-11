class Logana < Formula
  desc "A TUI log analyzer/viewer built for speed - handles files with millions of lines with instant filtering and VIM like navigation."
  homepage "https://github.com/pauloremoli/logana"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-aarch64-apple-darwin.tar.xz"
      sha256 "2876377d9a3f42abfb79476f43530001e899369e5e3f7c233e382231e5b49e68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-x86_64-apple-darwin.tar.xz"
      sha256 "bff751dac0c5d11ed2e2243a32574a51309e87813094de9005f48068a1636ee0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8668e3cd1883eb8608f381154db2f9d409ed9454f5b4be1df236c1750e126b33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e7f1eb766d26b8c81d22a4e9aeddad1183fd6280aa57514de517b0b963b0c8b"
    end
  end
  license "GPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "logana" if OS.mac? && Hardware::CPU.arm?
    bin.install "logana" if OS.mac? && Hardware::CPU.intel?
    bin.install "logana" if OS.linux? && Hardware::CPU.arm?
    bin.install "logana" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
