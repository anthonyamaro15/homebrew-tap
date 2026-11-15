class Ff < Formula
  desc "A blazing-fast TUI file finder with fuzzy search, ranking, and IDE integration"
  homepage "https://github.com/anthonyamaro15/file-finder-rust"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.0/ff-aarch64-apple-darwin.tar.gz"
      sha256 "3f730d3ec811010c56d32f1f0f7b741051782bbaf41049f4b8cef5592ce9eaa1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.0/ff-x86_64-apple-darwin.tar.gz"
      sha256 "4ca6cbc5da3503276da5962a09ec9be315b87bf2ec2ab6229131ee5169a1144d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.0/ff-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "b64ecb2eb43638a28e7fce7131f3eb407e629aff6e76fec0c6b775cf9d116220"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ff"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ff"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ff"
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
