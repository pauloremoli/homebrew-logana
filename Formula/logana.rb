class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.4/logana-aarch64-apple-darwin.tar.xz"
      sha256 "273507dd228cb6af8f887879e78f7c151924145bba3b53d6555270748e21fca7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.4/logana-x86_64-apple-darwin.tar.xz"
      sha256 "afcdd6e34c0292c3dace5d29a639cdd365e0e82ee6223fcd1ccecc8a7623121f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.4/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1f5cac18aa43d632d991ffde0d6216a0804808c972baff71309aaeaa87db9ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.4/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e3003126987b93baacc7f8f21b5da3349492e5d0cd497132c12cd2b91b73d204"
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
