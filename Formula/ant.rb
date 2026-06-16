class Ant < Formula
  desc "Lightweight JavaScript runtime"
  homepage "https://github.com/theMackabu/ant"
  version "0.12.2.1781569582"
  license "MIT"

  head do
    url "https://github.com/theMackabu/ant.git", branch: "master"

    depends_on "cmake" => :build
    depends_on "lld@20" => :build
    depends_on "llvm@20" => :build
    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "node@22" => :build
    depends_on "pkgconf" => :build
    depends_on "python@3.14" => :build
    depends_on "zig@0.15" => :build
  end

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
    if build.head?
      lld = Formula["lld@20"]
      llvm = Formula["llvm@20"]
      node = Formula["node@22"]
      python = Formula["python@3.14"]
      zig = Formula["zig@0.15"]

      ENV.prepend_path "PATH", lld.opt_bin.to_s
      ENV.prepend_path "PATH", llvm.opt_bin.to_s
      ENV.prepend_path "PATH", node.opt_bin.to_s
      ENV.prepend_path "PATH", python.opt_bin.to_s
      ENV.prepend_path "PATH", zig.opt_bin.to_s
      ENV["CC"] = (llvm.opt_bin/"clang").to_s
      ENV["CXX"] = (llvm.opt_bin/"clang++").to_s
      ENV["AR"] = (llvm.opt_bin/"llvm-ar").to_s
      ENV["RANLIB"] = (llvm.opt_bin/"llvm-ranlib").to_s
      ENV.append "LDFLAGS", "-fuse-ld=lld"

      meson_args = std_meson_args.reject { |arg| arg.start_with?("--wrap-mode=") }
      system "meson", "setup", "build", *meson_args, "--wrap-mode=default", "-Dcodesign=false"
      system "meson", "compile", "-C", "build"
      bin.install "build/ant"
      return
    end

    bin.install "ant"
  end

  test do
    (testpath/"hello.js").write "console.log('hello from ant')\n"
    assert_match "hello from ant", shell_output("#{bin}/ant #{testpath/"hello.js"}")
  end
end
