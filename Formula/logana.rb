class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.0/logana-aarch64-apple-darwin.tar.xz"
      sha256 "8b512beda43975085d7403d4cf2d9a53073a3a0cb0b276450ad04b02b319098b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.0/logana-x86_64-apple-darwin.tar.xz"
      sha256 "667808e15268699a5e499c911387d1ffbf08f9ab2449a79253d8386f06619362"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.0/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7215506858eee036f85a68fa903333899eed8aabc4cb3b445a3cb334ec17b28c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.0/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "edc05c51d62909cf43f463f3a6d436b5b5e5a9a73d1cf7603a39d140dc5efd6d"
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
