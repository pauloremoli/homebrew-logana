class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.7.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.7/logana-aarch64-apple-darwin.tar.xz"
      sha256 "ca33ce062d6514c3d1c11407e820482d97c6ab9bad9eb23e97774a0116a0428f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.7/logana-x86_64-apple-darwin.tar.xz"
      sha256 "c249d9e6043604e681697f095aa8ee3b5b6e7614c6a14265fe15a9b3118a0c48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.7/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9c5ca4dd503ee0cccda2955d0263c3b14831536275ad972ee6b1b800d62256df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.7/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4365ef09a14abf781664a3d60d6f363db5b459b840351c86f09ab9019035b283"
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
