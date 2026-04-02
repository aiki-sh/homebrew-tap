class Aiki < Formula
  desc "AI-native task tracking and agent orchestration CLI"
  homepage "https://github.com/glasner/aiki"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-aarch64-apple-darwin.tar.xz"
      sha256 "09a4f9abf471bcb8a4021adcb3c7138a61783dd5a1db760c3b237eb6b03f2b7d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-x86_64-apple-darwin.tar.xz"
      sha256 "4d42ce241494f379df48ed3e4d0efa22c4b1a7b6bdd3a4a5c28c1f485183362b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "85e28ed33a2d6f57116a0b662859f9d8ee685313d3f94238da79b5632c56fbfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b8860b86c336806a0946f161f047848fddc786acdd3b4d1ed4d5858cefa06963"
    end
  end
  license "MPL-2.0"

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
    bin.install "aiki", "otel_decode" if OS.mac? && Hardware::CPU.arm?
    bin.install "aiki", "otel_decode" if OS.mac? && Hardware::CPU.intel?
    bin.install "aiki", "otel_decode" if OS.linux? && Hardware::CPU.arm?
    bin.install "aiki", "otel_decode" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
