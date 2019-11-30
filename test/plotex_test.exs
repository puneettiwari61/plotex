
defmodule PlotexTest do
  require Logger
  use ExUnit.Case
  alias Plotex.Axis
  alias Plotex.Axis.Units
  alias Plotex.Output.Options
  alias Plotex.Output.Formatter

  # @default_css

  doctest Plotex


  test "simple plot" do
    xdata = 1..4 |> Enum.map(& &1 )
    ydata = xdata |> Enum.map(& :math.sin(&1/10.0) )

    plt = Plotex.plot([{xdata, ydata}])
    assert plt != nil
    # Logger.warn("plotex cfg: #{inspect plt }")
  end

  test "nil plot" do
    xdata = []
    ydata = []

    plt = Plotex.plot([{xdata, ydata}])
    assert plt != nil
    # Logger.warn("plotex cfg: #{inspect plt }")
  end

  test "date plot" do
    xdata = [0.0, 2.0, 3.0, 4.0]
    ydata = [0.1, 0.25, 0.15, 0.1]

    plt = Plotex.plot([{xdata, ydata}], xkind: :numeric)
    # Logger.warn("plotex cfg: #{inspect plt }")

    # Logger.info("xticks: #{inspect plt.xticks}")
    # Logger.info("yticks: #{inspect plt.yticks |> Enum.to_list()}")
    assert plt.xticks == [{0.0, 13.636363636363637}, {0.5, 22.727272727272727}, {1.0, 31.818181818181817}, {1.5, 40.90909090909091}, {2.0, 50.0}, {2.5, 59.090909090909086}, {3.0, 68.18181818181819}, {3.5, 77.27272727272727}, {4.0, 86.36363636363636}]
    assert Enum.to_list(plt.yticks) == [{0.1, 13.63636363636364}, {0.12, 23.33333333333333}, {0.14, 33.03030303030303}, {0.16, 42.72727272727273}, {0.18, 52.42424242424242}, {0.2, 62.121212121212125}, {0.22000000000000003, 71.81818181818183}, {0.24, 81.5151515151515}]

    # for xt <- plt.xticks do
    #   Logger.info("xtick: #{inspect xt}")
    # end

    # for yt <- plt.yticks do
    #   Logger.info("xtick: #{inspect yt}")
    # end

    # for data <- plt.datasets do
    #   for {x,y} <- data do
    #     Logger.info("data: #{inspect {x,y}}")
    #   end
    # end

  end

  test "svg plot" do
    xdata = [0.0, 2.0, 3.0, 4.0]
    ydata = [0.1, 0.25, 0.15, 0.1]

    plt = Plotex.plot([{xdata, ydata}], xkind: :numeric, xaxis: [padding: 0.05])
    # Logger.warn("svg plotex cfg: #{inspect plt, pretty: true }")

    svg_str = Plotex.Output.Svg.generate(
                plt,
                %Options{
                  xaxis: %Options.Axis{ label: %Options.Item{ rotate: 35 }},
                }
            ) |> Phoenix.HTML.safe_to_string()

    # Logger.warn("SVG: \n#{svg_str}")

    html_str = """
    <html>
    <head>
      <style>
        #{Plotex.Output.Svg.default_css()}
      </style>
    </head>
    <body>
      #{svg_str}
    </body>
    </html>
    """
    File.write!("output.html", html_str)
  end

  test "svg datetime (short) plot" do
    xdata = [
      DateTime.from_iso8601("2019-05-20T05:04:12.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:04:17.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:04:23.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:04:25.836Z") |> elem(1),
    ]
    ydata = [0.1, 0.25, 0.15, 0.1]

    plt = Plotex.plot(
      [{xdata, ydata}],
      xaxis: [kind: :datetime,
              ticks: 5,
              padding: 0.05]
    )
    # Logger.warn("svg plotex cfg: #{inspect plt, pretty: true }")

    svg_str =
      Plotex.Output.Svg.generate(
        plt,
        %Options{
          # xaxis: [rotate: 35, offset: '2.5em' ],
          xaxis: %Options.Axis{ label: %Options.Item{ rotate: 35 } },
          yaxis: %Options.Axis{ label: %Options.Item{ } },
        }
      ) |> Phoenix.HTML.safe_to_string()

    # Logger.warn("SVG: \n#{svg_str}")

    html_str = """
    <html>
    <head>
      <style>
        #{Plotex.Output.Svg.default_css()}
      </style>
    </head>
    <body>
      #{svg_str}
    </body>
    </html>
    """
    File.write!("output-dt.html", html_str)
  end

  test "svg cldr-datetime (short) plot" do
    xdata = [
      DateTime.from_iso8601("2019-05-20T05:04:12.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:04:17.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:04:23.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:04:25.836Z") |> elem(1),
    ]
    ydata = [0.1, 0.25, 0.15, 0.1]

    plt = Plotex.plot(
      [{xdata, ydata}],
      xaxis: [
              units: %Axis.Units.Time{},
              formatter: Formatter.DateTime.Cldr,
              ticks: 5,
              padding: 0.05]
    )
    # Logger.warn("svg plotex cfg: #{inspect plt, pretty: true }")

    svg_str =
      Plotex.Output.Svg.generate(
        plt,
        %Options{
          # xaxis: [rotate: 35, offset: '2.5em' ],
          xaxis: %Options.Axis{ label: %Options.Item{ rotate: 35 } },
          yaxis: %Options.Axis{ label: %Options.Item{ } },
        }
      ) |> Phoenix.HTML.safe_to_string()

    # Logger.warn("SVG: \n#{svg_str}")

    html_str = """
    <html>
    <head>
      <style>
        #{Plotex.Output.Svg.default_css()}
      </style>
    </head>
    <body>
      #{svg_str}
    </body>
    </html>
    """
    File.write!("output-dt-cldr.html", html_str)
  end

  test "svg datetime (hours) plot" do
    xdata = [
      DateTime.from_iso8601("2019-05-20T05:04:12.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:13:17.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:21:23.836Z") |> elem(1),
      DateTime.from_iso8601("2019-05-20T05:33:25.836Z") |> elem(1),
    ]
    ydata = [0.1, 0.25, 0.15, 0.1]

    plt = Plotex.plot(
      [{xdata, ydata}],
      xaxis: [
              kind: :datetime,
              units: %Units.Time{ticks: 5},
              padding: 0.05]
    )
    # Logger.warn("svg plotex cfg: #{inspect plt, pretty: true }")

    svg_str =
      Plotex.Output.Svg.generate(
        plt,
        %Options{
          # xaxis: [rotate: 35, offset: '2.5em' ],
          xaxis: %Options.Axis{ label: %Options.Item{ rotate: 35 } },
          yaxis: %Options.Axis{ },
        }
      ) |> Phoenix.HTML.safe_to_string()

    # Logger.warn("SVG: \n#{svg_str}")

    html_str = """
    <html>
    <head>
      <style>
        #{Plotex.Output.Svg.default_css()}
      </style>
    </head>
    <body>
      #{svg_str}
    </body>
    </html>
    """
    File.write!("output-dt-hours.html", html_str)
  end

  test "svg naivedatetime (hours) plot" do
    xdata = [
      NaiveDateTime.from_iso8601("2019-05-20T05:04:12.836") |> elem(1),
      NaiveDateTime.from_iso8601("2019-05-20T05:13:17.836") |> elem(1),
      NaiveDateTime.from_iso8601("2019-05-20T05:21:23.836") |> elem(1),
      NaiveDateTime.from_iso8601("2019-05-20T05:33:25.836") |> elem(1),
    ]
    ydata = [0.1, 0.25, 0.15, 0.1]

    plt = Plotex.plot(
      [{xdata, ydata}],
      xaxis: [kind: :datetime,
              ticks: 5,
              padding: 0.05]
    )
    # Logger.warn("svg plotex cfg: #{inspect plt, pretty: true }")

    svg_str =
      Plotex.Output.Svg.generate(
        plt,
        %Options{
          xaxis: %Options.Axis{ label: %Options.Item{ rotate: 35, offset: 5.0 } },
          yaxis: %Options.Axis{ label: %Options.Item{ offset: 5.0 } },
        }
      ) |> Phoenix.HTML.safe_to_string()

    # Logger.warn("SVG: \n#{svg_str}")

    File.write!("output-naive-dt-hours.html", svg_wrap(svg_str))
  end

  defp svg_wrap(html_str, css_str \\ Plotex.Output.Svg.default_css()) do
    """
    <html>
    <head>
      <style>
        #{css_str}
      </style>
    </head>
    <body>
      #{html_str}
    </body>
    </html>
    """
  end
end
