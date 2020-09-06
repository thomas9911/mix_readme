defmodule MixReadme.Backend do
  @moduledoc """
  Behaviour for rendering the readme template 

  render!/2: renders the given template with the opts as variables
  readme_templates/0 returns the paths where the template can be found
  default_template/0 returns the default template for the backend
  """

  @callback render!(binary, map) :: binary
  @callback readme_templates() :: [binary]
  @callback default_template() :: binary
end
