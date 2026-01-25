class Ff < Formula
  desc "A blazing-fast TUI file finder with fuzzy search, ranking, and IDE integration"
  homepage "https://github.com/anthonyamaro15/file-finder-rust"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.1.10/ff-aarch64-apple-darwin.tar.gz"
      sha256 "c7a61d376525d2f0add5173534b01295a757ab3b454f52b28ae04b28e3004a0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.1.10/ff-x86_64-apple-darwin.tar.gz"
      sha256 "cf66b5de10bcb5135b3ece5dedd5fa32353bdb6c6ae93d465a8d3f819adb2c9d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.1.10/ff-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b6552b11e98582948fb9761b3145134e867cad1a556aca00d591fa18ac754c64"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "ff" if OS.mac? && Hardware::CPU.arm?
    bin.install "ff" if OS.mac? && Hardware::CPU.intel?
    bin.install "ff" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
