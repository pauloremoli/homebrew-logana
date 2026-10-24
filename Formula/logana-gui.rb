class LoganaGui < Formula
  desc "GUI-only build of logana — turn any log source into structured data with a desktop app."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-gui-aarch64-apple-darwin.tar.xz"
      sha256 "18c20869885dc3fceaf7936c46c231611f4e5fd9e9c3a7031337058effcb6ddc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-gui-x86_64-apple-darwin.tar.xz"
      sha256 "9f79f250b470bd0182eb127ba6b3fe713dd2490e0bf74ce7d37e13212f639fe1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a1ca5053e959e28941ba78d44ca66155fc4316fcc9f2fbc2c9caa40cede7a8d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.1/logana-gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f597aaaa14b8e66f002bf97f9adece4ffbca954d5640e168cf4b905aebb79821"
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
