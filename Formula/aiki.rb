class Aiki < Formula
  desc "AI-native task tracking and agent orchestration CLI"
  homepage "https://github.com/glasner/aiki"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.7/aiki-aarch64-apple-darwin.tar.xz"
      sha256 "ab1108c1d050df4ef64f3dc4083ff9ccc9c0f2c7fe90a76452b0552d9ef80ded"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.7/aiki-x86_64-apple-darwin.tar.xz"
      sha256 "e0a46b353432f613e281b13bf9c8bc22727ebfa44c3def4e26080ee0e7500d37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.7/aiki-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "50e3f4e58b694a9e0b080f2215b95d003c506bbe41c782c96285f7bc806c32dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.7/aiki-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f23d4d85137ff4a709385e4c6916618714c5d0bcd8a505dfdedd023716aed40e"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
