class Aiki < Formula
  desc "AI-native task tracking and agent orchestration CLI"
  homepage "https://github.com/glasner/aiki"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.1.0/aiki-aarch64-apple-darwin.tar.xz"
      sha256 "9080f239ccba18fe61f43c4db49bbb1c01b7670ffdacc8c07c89916489a3e5c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.1.0/aiki-x86_64-apple-darwin.tar.xz"
      sha256 "581fe8da1576707bca59f5d5d69d79241ef3a42a8c456647e840fff92794a774"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.1.0/aiki-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7c41efe2561a7345d618bedc122fd878d3ddc8ccb4bd1ac8461bc26723bdbe2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.1.0/aiki-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c9ed15349e9fa3d6312b85bf431dd24e58c4b0e7aaf861035e6ecfd6ef4b5fe6"
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
