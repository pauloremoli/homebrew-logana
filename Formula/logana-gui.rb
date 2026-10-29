class LoganaGui < Formula
  desc "GUI-only build of logana — turn any log source into structured data with a desktop app."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-gui-aarch64-apple-darwin.tar.xz"
      sha256 "63699e5a1dd7fc79474c5b365fbefe6a03b1f920356536ea144505b5a78c7c93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-gui-x86_64-apple-darwin.tar.xz"
      sha256 "2fc7b6ef35642a11d9cb6b186482ddde4ff91de94c7a5ff84e56e56e2dd65106"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7de33e6f95bafbc375c71690d3afe5199bad29d0c4988aa869d8c0b6c9fbee99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.3/logana-gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b575e8838c1ae7281a5f9f671b068fe67097c907332f00f3c2293639b550d250"
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
