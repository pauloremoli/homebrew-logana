class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.1/logana-aarch64-apple-darwin.tar.xz"
      sha256 "aba0d88536f20ae212050af689c92ee6e21089bc03b617cefefab43ac972d523"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.1/logana-x86_64-apple-darwin.tar.xz"
      sha256 "efe6727ecc21fe3dedaa363a37ce4f94cd06d0ae9d5cb8fbfcea03acf3752d95"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.1/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "308f1a19702f122ddb04d874a6bf440157a3f56b4075c552edc17d6f2af162df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.1/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b08f0c2f9ef11f09d93ef9820b2ad8adf13248e176a31a43899b55ed74f3d505"
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
