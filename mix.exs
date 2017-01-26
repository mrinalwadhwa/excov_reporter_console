defmodule ExCov.Reporter.Console.Mixfile do
  use Mix.Project

  def project do
    [app: :excov_reporter_console,
     version: "0.1.8",
     description: "Console Reporter for ExCov",
     deps: deps(),
     package: package()]
  end

  defp deps do
    [{:excov, "0.1.7"},
     {:ex_doc, "~> 0.14.5", only: :dev}]
  end

  defp package do
    [name: :excov_reporter_console,
     maintainers: ["Mrinal Wadhwa"],
     licenses: ["MIT"],
     links: %{"GitHub" =>
       "https://github.com/mrinalwadhwa/excov_reporter_console"
     }]
  end
end
