class Logana < Formula
  desc "A TUI log analyzer/viewer built for speed - handles files with millions of lines with instant filtering and VIM like navigation."
  homepage "https://github.com/pauloremoli/logana"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-aarch64-apple-darwin.tar.xz"
      sha256 "c1f8a2c5f5dcb4e8cff5c8773c2f1b580ca019e6dadf741443dbbb549b3b247c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-x86_64-apple-darwin.tar.xz"
      sha256 "c7dcf51daf627d533c51dc99c8f0941d5eb2ac1e28a32aa4dbb237e98f5b8f26"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a56832c95544501a1eb3c7276821aa4f21804f4904ad62e202fa0168f3e59a43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.1.0/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cbc99e7b550e114ba25dcc615f0e963a1729ceaf10274c8c8e5206283250dbeb"
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
