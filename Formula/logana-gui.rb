class LoganaGui < Formula
  desc "GUI-only build of logana — turn any log source into structured data with a desktop app."
  homepage "https://github.com/pauloremoli/logana"
  version "0.8.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.5/logana-gui-aarch64-apple-darwin.tar.xz"
      sha256 "f134f9823cb20db4ffb3213f3b048e94fa2a4144eea49b6bb8d73dcba2716cdd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.5/logana-gui-x86_64-apple-darwin.tar.xz"
      sha256 "53674868f27f887e5fea99f1437b17ded0eb4ebfc03da94bbbb459d833cb29e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.5/logana-gui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "319f481ab3d0a04d2f6def46c23ce9a7671a4d444030247be24c100ab3e9f562"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.8.5/logana-gui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "37ec20c5dfa6281cecf853c3b7ff1fecafcc789d7d289e9654b250750a565522"
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
