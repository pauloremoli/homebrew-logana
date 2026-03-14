class Logana < Formula
  desc "A TUI log analyzer/viewer built for speed - handles files with millions of lines with instant filtering and VIM like navigation."
  homepage "https://github.com/pauloremoli/logana"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.3.0/logana-aarch64-apple-darwin.tar.xz"
      sha256 "645bcd677cac60bb9d7af519648783a3d3043153d4e45400c1507fd6bca88cd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.3.0/logana-x86_64-apple-darwin.tar.xz"
      sha256 "431d89166fe18d6e2b1651ad2eb732115eec11260df91a62fea3e241b2dd6825"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pauloremoli/logana/releases/download/v0.3.0/logana-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d184ac83ee1058e5fc5dcba3694bf5010f32aeb613462c97ae25d5953b065ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pauloremoli/logana/releases/download/v0.3.0/logana-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d53ccaa5fb9b29d75b22c2fa768f566d6749b281dcb8a6b7f0c7bbf7ef327d65"
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
