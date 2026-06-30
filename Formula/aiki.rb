class Aiki < Formula
  desc "AI-native task tracking and agent orchestration CLI"
  homepage "https://github.com/aiki-sh/cli"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aiki-sh/cli/releases/download/v0.2.8/aiki-aarch64-apple-darwin.tar.xz"
      sha256 "6bb088eeecf9a908e9113923fcc520a834a03a2aaffdc267c5e4e9334b4cd8fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aiki-sh/cli/releases/download/v0.2.8/aiki-x86_64-apple-darwin.tar.xz"
      sha256 "eee5bd3c6085d594d4952f1af978f40ed0186f9c20dd945eb9b8c755dc5ac8b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aiki-sh/cli/releases/download/v0.2.8/aiki-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96c98e883faf943531d148e3c56250590881f2d4ae4b16ef017975ab17796efc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aiki-sh/cli/releases/download/v0.2.8/aiki-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52778e24a1e316acd0b7781bd1d4902a8b98a00483cc38ba79a9bd13ca32d359"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "aiki", "otel_decode"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "aiki", "otel_decode"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aiki", "otel_decode"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aiki", "otel_decode"
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
