class Ff < Formula
  desc "A blazing-fast TUI file finder with fuzzy search, ranking, and IDE integration"
  homepage "https://github.com/anthonyamaro15/file-finder-rust"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.2.0/ff-aarch64-apple-darwin.tar.gz"
      sha256 "0d9eceeb5e5f6fbeae08ce565c8f80708ad0908a37574a6402786b8ad27b514d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.2.0/ff-x86_64-apple-darwin.tar.gz"
      sha256 "b275fbcca4d42864e1b1ff17c4092233ca8ad31e43f7e4732bab9d7c00d001e8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.2.0/ff-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ec0cb23dd9efcc0ab1fc0cb49d35afaa5ca8c1f392d70b43e4220b2693750b43"
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
