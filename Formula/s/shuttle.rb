class Shuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "fe13c6a0717edd1d6ec838c6abf02d3230b379083d4daf8f63621d47d1ceded6"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    generate_completions_from_executable(bin/"shuttle", "generate", "shell")
    (man1/"shuttle.1").write Utils.safe_popen_read(bin/"shuttle", "generate", "manpage")

    # cargo-shuttle is the same as shuttle
    rm bin/"cargo-shuttle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Error: \e[1m401 Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    assert_match "Error: failed to get cargo metadata", shell_output("#{bin}/shuttle deployment status 2>&1", 1)
  end
end
