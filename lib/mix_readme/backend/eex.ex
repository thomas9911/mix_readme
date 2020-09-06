defmodule MixReadme.Backend.EEx do
  @behaviour MixReadme.Backend

  @readme_names ["./readme.eex", "./README.eex", "./Readme.eex"]

  @default_template "# <%= module_name %>\n\n<%= module_doc %>"

  @impl true
  def render!(template, opts) do
    EEx.eval_string(template, Map.to_list(opts))
  end

  @impl true
  def readme_templates, do: @readme_names

  @impl true
  def default_template, do: @default_template
end
