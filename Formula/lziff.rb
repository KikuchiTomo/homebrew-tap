class Lziff < Formula
  desc "A cross-platform TUI diff & review tool with JetBrains-style snap-aligned side-by-side diffs"
  homepage "https://github.com/KikuchiTomo/lziff"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/KikuchiTomo/lziff/releases/download/v0.1.3/lziff-aarch64-apple-darwin.tar.xz"
      sha256 "9e91420549980280f3a74ecca225f7ffb7e56e5dab0c936eb6e709e214e7c898"
    end
    if Hardware::CPU.intel?
      url "https://github.com/KikuchiTomo/lziff/releases/download/v0.1.3/lziff-x86_64-apple-darwin.tar.xz"
      sha256 "c9dc80cfb79969d3ddbbbbabbefc164b63d3bf31edeb615e67837250bb965588"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/KikuchiTomo/lziff/releases/download/v0.1.3/lziff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "48580ba0e9488a79c49c90a0967bc7e0f8c5c07c3e518c824d3ef822afaf8025"
    end
    if Hardware::CPU.intel?
      url "https://github.com/KikuchiTomo/lziff/releases/download/v0.1.3/lziff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c211bc65052fe652d1476ef5dcbd7fc6e9cb1f627f48708e1f7e8977e32dbe55"
    end
  end
  license "MIT"

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
    bin.install "lziff" if OS.mac? && Hardware::CPU.arm?
    bin.install "lziff" if OS.mac? && Hardware::CPU.intel?
    bin.install "lziff" if OS.linux? && Hardware::CPU.arm?
    bin.install "lziff" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
