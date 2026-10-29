class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-aarch64-apple-darwin.tar.xz"
      sha256 "c517fd7452bc379ed5ebe66cf63441b996f671f1768ecf072b3c69a18f6ec617"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-x86_64-apple-darwin.tar.xz"
      sha256 "40c8d988ebe0021c652c64eaddacb64abd396fd6c9796456cae8760f668edb45"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "68faab099eb23338ae5637c63a27f6f11c6c9f373b70f9641fc0bc2d4dc8b567"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84a998936749b476205ea5c9d49f6000b923d9dda1d16d986fe5993da8b38666"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "logana", "schema"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "logana", "schema"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "logana", "schema"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "logana", "schema"
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
