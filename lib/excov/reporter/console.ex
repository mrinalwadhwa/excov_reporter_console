defmodule ExCov.Reporter.Console do
  @behaviour ExCov.Reporter

  alias ExCov.Line,    as: Line
  alias ExCov.Module,  as: Module
  alias ExCov.Project, as: Project

  @default_width 120

  def report!(project, options \\ []) do
    sorted = Enum.sort(project.modules, &(&1.source_path >= &2.source_path)
    project = %{project | modules: sorted}

    printer = Keyword.get(options, :printer, &IO.puts/1)
    printer.(render_project_summary(project, options))
    printer.(render_project_detail(project, options))

    :ok
  end

  @doc """
  Render the project report summary if :show_summary?` is `true`.
  """
  @spec render_project_summary(Project.t, Keyword.t) :: iolist
  def render_project_summary(project, options) do
    if Keyword.get(options, :show_summary?, true) do
      width = Keyword.get(options, :width, @default_width)
      separator = [
        "|",
        String.duplicate("-", width-45),"|",
        String.duplicate("-", 12),"|",
        String.duplicate("-", 10),"|",
        String.duplicate("-", 8),"|",
        String.duplicate("-", 9),
        "|\n"
      ]

      [
        "\n",
        separator,
        :io_lib.format("| ~-#{width-47}s | ~10s | ~8s | ~6s | ~7s |\n", [
          "", "LINES", "RELEVANT", "MISSED", "COVERED",
        ]),

        separator,
        :io_lib.format("| ~-#{width-47}s | ~10w | ~8w | ~6w | ~6.1f% |\n", [
          "PROJECT:",
          project.statistics.count_of_lines,
          project.statistics.count_of_lines_missed,
          project.statistics.count_of_lines_covered,
          project.statistics.percentage_of_relevant_lines_covered
        ]),
        separator,

        Enum.reduce(project.modules, [], fn(module, report) ->
          [:io_lib.format("| ~-#{width-47}s | ~10w | ~8w | ~6w | ~6.1f% |\n", [
            Path.relative_to(module.source_path, Project.root),
            module.statistics.count_of_lines,
            module.statistics.count_of_lines_relevant,
            module.statistics.count_of_lines_missed,
            module.statistics.percentage_of_relevant_lines_covered
          ]) | report]
        end),
        separator
      ]
    else
      ""
    end
  end

  @doc """
  Render the project report detail if :show_detail?` is `true`.
  """
  @spec render_project_detail(Project.t, Keyword.t) :: iolist
  def render_project_detail(project, options) do
    if Keyword.get(options, :show_detail?, true) do
      render_modules(project.modules, options)
    else
      ""
    end
  end

  @doc """
  Render a list of Modules.
  """
  @spec render_modules([Module.t], Keyword.t) :: iolist
  def render_modules(modules, options) do
    Enum.map(modules, fn(module) ->
      render_module(module, options)
    end)
  end

  @doc """
  Render a module.
  """
  @spec render_module(Module.t, Keyword.t) :: iolist
  def render_module(module = %Module{}, options) do
    width = Keyword.get(options, :width, @default_width)
    [
      "\n\n",
      module.source_path,
      "\n",String.duplicate("-", width),"\n",
      render_lines(module.lines, options)
    ]
  end

  @doc """
  Render a list of lines.
  """
  @spec render_lines([Line.t], Keyword.t) :: iolist
  def render_lines(lines, options) do
    Enum.map(lines, fn(line) ->
      render_line(line, options)
    end)
  end

  @doc """
  Render a line.

  If a line is `relevant?` and `covered?` render it in green.
  If a line is `relevant?` but not `covered?` render it in red.
  If a line is not `relevant?` render it normally.
  """
  @spec render_line(Line.t, Keyword.t) :: iolist
  def render_line(line = %Line{}, options) do
    [
      render_line_number(line, options),
      if line.relevant?do
        if line.covered? do
          IO.ANSI.format([:green, line.content])
        else
          IO.ANSI.format([:red, line.content])
        end
      else
        line.content
      end
    ]
  end

  @doc """
  Render a line number if `:show_line_number?` option is `true`.
  """
  @spec render_line_number(Line.t, Keyword.t) :: iolist
  def render_line_number(line = %Line{}, options) do
    if Keyword.get(options, :show_line_number?, true) do
      [
        IO.ANSI.format([
          :light_black,
          :io_lib.format("~4w", [line.index + 1])
        ]),
        " | "
      ]
    else
      ""
    end
  end

end
