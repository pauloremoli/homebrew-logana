class Logana < Formula
  desc "A TUI log analyzer/viewer built for speed - handles files with millions of lines with instant filtering and VIM like navigation."
  homepage "https://github.com/pauloremoli/logana"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.2.1/logana-aarch64-apple-darwin.tar.xz"
      sha256 "de7f8340735d6de5c8448aa531aab084ca0ae46793b1b5b785febcf10657647c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.2.1/logana-x86_64-apple-darwin.tar.xz"
      sha256 "455a4f361ec628ed1090ad3bff175d13b271ad2dfe8aa6fe018407fc9356f9f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.2.1/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4eed029a4935715af3423803403d9f9693093470d8774bc7c6d965739c09c382"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.2.1/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6049670e8ea430d277979bba832c9f4326df36ae97141eb90283b9778b0b75ae"
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
