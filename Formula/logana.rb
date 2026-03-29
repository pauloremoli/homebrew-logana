class Logana < Formula
  desc "A TUI log analyzer/viewer built for speed - handles files with millions of lines with instant filtering and VIM like navigation."
  homepage "https://github.com/pauloremoli/logana"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.0/logana-aarch64-apple-darwin.tar.xz"
      sha256 "41336fa8977704bb0a25815a009a9cdc14dc8652c12c8f06a81ec1557544fd3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.0/logana-x86_64-apple-darwin.tar.xz"
      sha256 "7e22d9902aba36d29eb5ee03a6d99f76affb9b94eceb67d74e1ee19c79e7a468"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.0/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8630065687950d91f804fa0d05924fce0c86a80ad6f1515ab96b369e88a8533d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.5.0/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c44aaa5a20c04cedaa0a3873817362488db4c81f34aac2d6c63e2a7255dc8e5"
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
