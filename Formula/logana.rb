class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-aarch64-apple-darwin.tar.xz"
      sha256 "b5e2d45905c2ad9c090a3d7cba3583dd61b4d9d43cb22819dc92dfb1dfc9dbcd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-x86_64-apple-darwin.tar.xz"
      sha256 "1aa735cfe3547dc06d2220fec4dbd391f0343107f538e6b348b5d2b76ab1fcee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc6caded162748d62d78861ad0c4ae21c67531c15f1cfed06f35c9698d0fcb95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2dbf3cdfd246c2164f95763a66355f7e5586c376dfc4784e5615c573cdec904"
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
