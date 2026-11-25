class Ff < Formula
  desc "A blazing-fast TUI file finder with fuzzy search, ranking, and IDE integration"
  homepage "https://github.com/anthonyamaro15/file-finder-rust"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.1/ff-aarch64-apple-darwin.tar.gz"
      sha256 "b1cd74ab11e1ef7d51b907b6702084de79bc5cd922e8096db10bdedb0cea1011"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.1/ff-x86_64-apple-darwin.tar.gz"
      sha256 "e01903255837cdbf6d8dc6fd3825ff473fe38e06efc2ac1d7d1fcc634be8ac89"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.1/ff-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "a3a5783a9f37eb69ede90993a3b631e6a5f1340d9be421bdf91d4606f68e5ccf"
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
