defmodule ExCov.Reporter.Console.Mixfile do
  use Mix.Project

  def project do
    [app: :excov_console_reporter,
     version: "0.1.0",
     description: "Console Reporter for ExCov",
     deps: deps(),
     package: package()]
  end

  defp deps do
    [{:excov, "0.1.6", github: "mrinalwadhwa/excov"}]
  end

  defp package do
    [name: :excov_console_reporter,
     maintainers: ["Mrinal Wadhwa"],
     licenses: ["MIT"],
     links: %{"GitHub" =>
       "https://github.com/mrinalwadhwa/excov_console_reporter"
     }]
  end
end
