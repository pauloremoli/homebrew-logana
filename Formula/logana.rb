class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.2/logana-aarch64-apple-darwin.tar.xz"
      sha256 "26adbf91d307c91e4ce9ba26faf651a6615f5cb2839e7df9da6db7c570992b72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.2/logana-x86_64-apple-darwin.tar.xz"
      sha256 "2e0e47f43f4e42304d48a0c34357cf8f1c960340f5baee684242798ea35274c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.2/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3518d23d1b2aab202fd198b8a1daa8cd524af5450ee778d0d844704e59b00bf5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.7.2/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba67ad5947b85742dd96062dfc095a7576432737f203e649c666b286d436dcb9"
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
