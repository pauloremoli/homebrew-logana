class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.7.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.6/logana-aarch64-apple-darwin.tar.xz"
      sha256 "92080e86cda14bc6185a07ec41c8a8a681a91a63e896f5126a1edcaa9a27a0d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.6/logana-x86_64-apple-darwin.tar.xz"
      sha256 "9f1e08a394ec30e98b5f8869257b18264acafed1268985635ae37f2f004e3823"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.6/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c641fcf88c579b9c7ae86f8f5a3435730a4f488975cb4b477003414a17d81b1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.6/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f7666c01167eac0de1017f6cecbbc617f1ddc620df106824ca89f7b51f99cff5"
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
    bin.install "logana", "schema" if OS.mac? && Hardware::CPU.arm?
    bin.install "logana", "schema" if OS.mac? && Hardware::CPU.intel?
    bin.install "logana", "schema" if OS.linux? && Hardware::CPU.arm?
    bin.install "logana", "schema" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
