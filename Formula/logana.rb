class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-aarch64-apple-darwin.tar.xz"
      sha256 "71b43a595f8b24430db544912e50e9f0e8182687f27f9a086de45cbdbf9b00f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-x86_64-apple-darwin.tar.xz"
      sha256 "32d1b130ebc62386950f66fac1d73bbe912406a628dd71e6bbebe2290096b296"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45a000da7de036b089840a9da330fa588a40c6acfb0c0bf8605a38c1f88e234f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.4/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "263f52528f4729861529e357082e013f892452577013325c4ababf4871589130"
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
