class Onctl < Formula
  desc "Command-line tool for managing cloud resources with onctl"
  homepage "https://github.com/cdalar/onctl"
  url "https://github.com/cdalar/onctl.git",
    tag:      "v0.1.19",
    revision: "6323244fda55d7edff4c5f2718f1c7eaa9cd772d"
  license "AGPL-3.0-or-later"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cdalar/onctl/cmd.Version=#{version}
      -X github.com/cdalar/onctl/cmd.BuildTime=#{Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")}
      -X github.com/cdalar/onctl/cmd.GoVersion=#{Formula["go"].version}
    ]
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags:), "-o", "onctl"
  end

  test do
    # Set environment variables for the test
    ENV["HCLOUD_TOKEN"] = "very_secure_token"
    ENV["ONCTL_CLOUD"]  = "hetzner"

    # Initialize onctl before running other commands
    system bin/"onctl", "init"

    # Run the version command to ensure the binary works
    assert_match "unauthorized", shell_output("#{bin}/onctl ls")
  end
end
