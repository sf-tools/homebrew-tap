class Ant < Formula
  desc "Lightweight JavaScript runtime"
  homepage "https://github.com/theMackabu/ant"
  version "0.12.2.1781569582"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/theMackabu/ant/releases/download/v0.12.2.1781569582/ant-darwin-aarch64.zip"
      sha256 "c16ca1f3a8fbdce23aee99b779e2c2b6a8c5aaaa7ceed6760debded77d0612dc"
    else
      url "https://github.com/theMackabu/ant/releases/download/v0.12.2.1781569582/ant-darwin-x64.zip"
      sha256 "1b1e960cdbc85f1d9c998b3a1c295019ed1c46a8ba3f4a2eb1f7c186ffc5bf4b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/theMackabu/ant/releases/download/v0.12.2.1781569582/ant-linux-aarch64.zip"
      sha256 "54658a5ad7b8144dc88a85158664be21b82e72efc75266912e9ab291797a87af"
    else
      url "https://github.com/theMackabu/ant/releases/download/v0.12.2.1781569582/ant-linux-x64.zip"
      sha256 "3b1f3a22c83ed8831ccf8cfce04f5cb72f484428dbf3c832ae17f7eda282e630"
    end
  end

  def install
    bin.install "ant"
  end

  test do
    (testpath/"hello.js").write "console.log('hello from ant')\n"
    assert_match "hello from ant", shell_output("#{bin}/ant #{testpath/"hello.js"}")
  end
end
