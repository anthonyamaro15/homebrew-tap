class Ff < Formula
  desc "A blazing-fast TUI file finder with fuzzy search, ranking, and IDE integration"
  homepage "https://github.com/anthonyamaro15/file-finder-rust"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.1.11/ff-aarch64-apple-darwin.tar.gz"
      sha256 "dc8e1d8ed3f3ee912b80922a2248616985e7625382b7e236a0c56cfa03e6c369"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.1.11/ff-x86_64-apple-darwin.tar.gz"
      sha256 "6a90bee7321caa9b5fc2e2066983fa4829b3c344baf9648015361e1ebb8af5ad"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.1.11/ff-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "e7d09c5b0f9accdf82bb04533150cb5a47b6de2a715710430e3cb563e3c13aba"
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
