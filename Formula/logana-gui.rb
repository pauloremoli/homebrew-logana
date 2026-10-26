class LoganaGui < Formula
  desc "GUI-only build of logana — turn any log source into structured data with a desktop app."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-gui-aarch64-apple-darwin.tar.xz"
      sha256 "5b56cae92adff07b1b23c06cdc97fab0a5c1227ec5c2f5c786f279ed1515683c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-gui-x86_64-apple-darwin.tar.xz"
      sha256 "96131b8e4351814aafe49cc43a6344597c1473fcb30b90ac14465289f6460edc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d7925f1be1f7d9db8ef47bc1344f9fdc873a9521ead38f229a0c9cad38359ee1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.2/logana-gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ecba0b4b5d397284d0253d4b45d47c4e379ee372ab221f6d0fc2f114f8d10f2f"
    end
  end
  license "GPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "logana-gui"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "logana-gui"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "logana-gui"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "logana-gui"
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
