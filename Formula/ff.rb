class Ff < Formula
  desc "A blazing-fast TUI file finder with fuzzy search, ranking, and IDE integration"
  homepage "https://github.com/anthonyamaro15/file-finder-rust"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.2/ff-aarch64-apple-darwin.tar.gz"
      sha256 "511b5da2ee2a925776ad8104d35185abc990165f0d91fbfe17c2dc170c688874"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.2/ff-x86_64-apple-darwin.tar.gz"
      sha256 "e27db0d08409a2995fb6c2578f81db2fe25749537ebf4fd8df9164c8693d0d63"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/anthonyamaro15/file-finder-rust/releases/download/v0.3.2/ff-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "0e048d0fce0aaa196b632f23dda510754f1bd8ffc2d3b9ad430294418705a6a5"
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
