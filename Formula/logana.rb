class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.1/logana-aarch64-apple-darwin.tar.xz"
      sha256 "7c132de576779a30228bce71d587a380e22508b7e60114cd4c6bce4f3572a7c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.1/logana-x86_64-apple-darwin.tar.xz"
      sha256 "8e7d312e3b7b529e785ccc77afc9ae9613c8807dd7577c98493baf4fb0ec6ff9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.1/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c7cb6546a740a607b095da4f08032f7873294e4f79eadc810dadd7fbae9035d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.1/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d896310b8de1ea9707e66f1f56812fc4ce780d65dad369267a97ae52d3d91b17"
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
