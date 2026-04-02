class Aiki < Formula
  desc "AI-native task tracking and agent orchestration CLI"
  homepage "https://github.com/glasner/aiki"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-aarch64-apple-darwin.tar.xz"
      sha256 "ae234f61a73c2068e89a6fd2b246ebf4f12e9121021d774452dfacdb90a39001"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-x86_64-apple-darwin.tar.xz"
      sha256 "8cf6ee0e7da1dbfd0b172377a6e72f652880bdfc5a762c0882107f6e84d672b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e11ba68f0e8412c3935771c4f6c5c92c70ce75144a62af1112147ff215803c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/glasner/aiki/releases/download/v0.2.5/aiki-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9643c169ba0ae2e9d3ac2fe1c04bdd69036a7c68bf51943197a8b5b15373a985"
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
