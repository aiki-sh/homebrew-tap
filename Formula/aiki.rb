class Aiki < Formula
  desc "AI-native task tracking and agent orchestration CLI"
  homepage "https://github.com/glasner/aiki"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.6/aiki-aarch64-apple-darwin.tar.xz"
      sha256 "4d7127942fcd3b8494c6c4ce897aa01831dba5fd1903258d42d9edbaf1fb18dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.6/aiki-x86_64-apple-darwin.tar.xz"
      sha256 "84106a8cbe6ccee9c0e94ec1007204d6326e209e31c22363f3aaaadc1ef94157"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.6/aiki-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce8c058058b3c57785f8d22164c4c924b5e002d2f1e8e1865989c2c19214e176"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.6/aiki-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e775e4254279557f92797ff24fca3de997e7062befb2c0dd5c4fb56a72c40d92"
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
