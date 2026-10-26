class Logana < Formula
  desc "Turn any log source — files, compressed archives, Docker, or OTel streams — into structured data. Filter by pattern, field, or date range; annotate lines; bookmark findings; and export to Markdown, Jira, or AI assistants via the built-in MCP server."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-aarch64-apple-darwin.tar.xz"
      sha256 "8835ee14284d7e20ecb9d77b900536f9248174b64221e785ec96f0566f1a9059"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-x86_64-apple-darwin.tar.xz"
      sha256 "5e9ff4afe7135bab6a09388d47bb92fec2996506b36917fea451fe174659f8ea"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fba943da77a3640fbd507a1a336d0841e509f36b9ae5ec512e772c74a9eba7d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c090cb887856baef2586338f4b397fac64140045b5052d618dde28563d4424a"
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
