defmodule MixReadme do
  @moduledoc """
  Documentation for MixReadme.
  """

  @mix_config_keys [
    :app,
    :name,
    :version,
    :description,
    :elixir,
    :package
  ]

  @priv :code.priv_dir(:mix_readme)

  @doc """
  The main function
  """
  def apply(opts) do
    require_files(opts)

    opts =
      opts
      |> Map.put_new(:backend, MixReadme.Backend.EEx)
      |> load_module()
      |> put_module_doc()

    backend = Map.fetch!(opts, :backend)

    backend.default_template()
    |> load_template(opts, backend)
    |> backend.render!(opts)
  end

  @doc """
  Fetches values from the mix project and the configs and combines them with the arguments
  """
  def combine_configs(arguments) do
    mix_config = from_mix_config()

    mix_config
    |> Keyword.merge(from_config())
    |> Keyword.merge(arguments)
    |> Map.new()
    |> module_from_app(mix_config)
  end

  defp put_module_doc(opts) do
    {:docs_v1, _, :elixir, _, %{"en" => module_doc}, _, _} =
      opts |> to_path() |> Code.fetch_docs()

    Map.put(opts, :module_doc, module_doc)
  end

  defp load_module(%{module: module, backend: backend} = configs) do
    module = String.to_existing_atom("Elixir.#{module}")
    {:module, module} = Code.ensure_compiled(module)
    {:module, backend} = Code.ensure_compiled(backend)

    configs 
    |> Map.put(:module, module) 
    |> Map.put(:backend, backend)
  rescue
    _e in ArgumentError ->
      # from to_existing_atom
      reraise("module should be an existing module", __STACKTRACE__)

    _e in MatchError ->
      # from ensure_compiled
      reraise("module not found", __STACKTRACE__)
  end

  defp require_files(%{module_file: module_file}) do
    Code.compiler_options(ignore_module_conflict: true)
    module_file |> List.wrap() |> Kernel.ParallelCompiler.compile()
    Code.compiler_options(ignore_module_conflict: false)
  end

  defp require_files(_) do
    Code.compiler_options(ignore_module_conflict: true)
    "./lib/*.ex" |> Path.wildcard() |> Kernel.ParallelCompiler.compile()
    Code.compiler_options(ignore_module_conflict: false)
  end

  defp to_path(%{app: app, module: module}), do: "./_build/dev/lib/#{app}/ebin/#{module}.beam"

  defp module_from_app(%{module: module} = config, _mix_config) do
    config
    |> Map.put(:module, module)
    |> Map.put(:module_name, module)
  end

  defp module_from_app(config, mix_config) do
    module = mix_config |> Keyword.fetch!(:app) |> Atom.to_string() |> Macro.camelize()

    config
    |> Map.put(:module, module)
    |> Map.put(:module_name, module)
  end

  defp from_config() do
    Application.get_all_env(:mix_readme)
  end

  defp from_mix_config() do
    Mix.Project.config()
    |> Keyword.take(@mix_config_keys)
  end

  defp load_template(default, opts, backend) do
    case find_readme(opts, backend) do
      nil -> default
      readme_file -> File.read!(readme_file)
    end
  end

  defp find_readme(%{template_path: template_path}, _) do
    template_path
  end

  defp find_readme(_, backend) do
    backend.readme_templates()
    |> Enum.map(fn x -> {x, Path.join(@priv, x) |> File.exists?()} end)
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.at(0)
  end

  def mix_config_keys, do: @mix_config_keys
end
