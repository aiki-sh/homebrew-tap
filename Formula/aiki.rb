class Aiki < Formula
  desc "AI-native task tracking and agent orchestration CLI"
  homepage "https://github.com/glasner/aiki"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.4/aiki-aarch64-apple-darwin.tar.xz"
      sha256 "cfac37db544932d70de5b92a8fb9f2b7341e318ec4ef53faefcd90c3a45421ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.4/aiki-x86_64-apple-darwin.tar.xz"
      sha256 "828c85de15654c9d4b951c579d71b522f7deec81c2b1c4b162c2e239e72b62b7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.4/aiki-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f6c98446826b1e7d93d5d02cae01dd91ab44a52a64633b594223f9cf47da0322"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.4/aiki-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fd88e6759b609527160301857f44e795a00707980b222b76b8c40a4d6cc1938f"
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
