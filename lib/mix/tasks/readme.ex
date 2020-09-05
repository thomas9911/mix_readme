defmodule Mix.Tasks.Readme do
  @shortdoc "Generates Readme"

  @aliases [
    a: :app,
    m: :module
  ]

  @strict [
    app: :string,
    module: :string,
    template_path: :string,
    module_file: :string
  ]

  @config_keys [
    :app,
    :module,
    :template_path,
    :module_file
  ]

  @mix_config_keys MixReadme.mix_config_keys()

  @readme_names MixReadme.readme_names()

  @moduledoc """
  Generate a README based on the moduledoc of your app.

  This so you can write Doctests that get tested and have them in your README.

  ## Usage
  ```sh
  mix readme > README.md
  ```

  Will use the default template, but you can supply your own template. These are automatically found in #{
    inspect(@readme_names)
  } or you can set the path in the config under the `template_path` key.

  ## Available commandline arguments

  | Flag            | Info                                                   |
  | --------------- | ------------------------------------------------------ |
  | --app,     -a   | override the app variable                              |
  | --module,  -m   | override the module variable                           |
  | --template_path | set the path of the template to use                    |
  | --module_file   | set the path to the file where the module can be found |

  Resolutation Order:
  - Commandline Arguments
  - Config
  - Mix.Project

  Takes these from the Mix.Project:
  - #{Enum.join(@mix_config_keys, "\n- ")}

  Takes these from the config file:
  - #{Enum.join(@config_keys, "\n- ")}

  But arbitrary keys can be set in the config, so that these can be used in your template.

  ## Example 1

  ```sh
  mix readme --module MyApp.OddModule --module_file ./priv/odd_place/odd_module.ex > README.md
  ``` 

  ## Example 2

  in `config/config.ex`
  ```elixir
  import Config

  config :mix_readme,
    module_file: "./lib/my_app.ex",
    template_path: "./docs/readme.eex",
    my_arbitrary_data: [1, 2, 3, 4, 5]
  ```

  in `docs/readme.eex`, because we set that in the config:
  ```markdown
      # <%= module_name %>

      Some text I want in the README but not in the moduledoc.

      ## Installation

      ```elixir
      def deps do
        [
          {:my_app, "~> <%= version %>"}
        ]
      end
      ```

      <%= module_doc %>

      <%= Enum.map(my_arbitrary_data, fn item -> %>
      - <%= item %>
      <%= end) %>
  ```

  """

  use Mix.Task

  def run(argv) do
    {opts, _argv} = OptionParser.parse!(argv, aliases: @aliases, strict: @strict)

    opts
    |> MixReadme.combine_configs()
    |> IO.inspect()
    |> MixReadme.apply()
    |> IO.puts()
  end
end
