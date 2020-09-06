# MixReadme

## Installation

```elixir
def deps do
    [
        {:mix_readme, "~> 0.2.0", runtime: false}
    ]
end
```

Generate a README based on the moduledoc of your app.

This so you can write Doctests that get tested and have them in your README.

## Usage
```sh
mix readme > README.md
```

Will use the default template, but you can supply your own template. These are automatically found in ["./readme.eex", "./README.eex", "./Readme.eex"] or you can set the path in the config under the `template_path` key.

## Available commandline arguments

| Flag            | Info                                                   |
| --------------- | ------------------------------------------------------ |
| --app,     -a   | override the app variable                              |
| --module,  -m   | override the module variable                           |
| --template_path | set the path of the template to use                    |
| --module_file   | set the path to the file where the module can be found |

Resolution Order:
- Commandline Arguments
- Config
- Mix.Project

Takes these from the Mix.Project:
- app
- name
- version
- description
- elixir
- package

Takes these from the config file:
- app
- module
- template_path
- module_file

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

## Custom Backend

By default the template format used is EEx, because this is the default Elixir templating engine.
But this can be changed by setting the `:backend` key in the config to a module that implements the `MixReadme.Backend` behaviour.
For instance take a look at `https://github.com/thomas9911/mix_readme_mustache`.

in `mix.exs`:
```
[
    {:mix_readme, "~> 0.2.0", only: :dev, runtime: false},
    {:mix_readme_mustache, "~> 0.1.0", only: :dev, runtime: false}
]
```

in `config/config.exs`:
```
import Config

config :mix_readme,
    backend: MixReadme.Backend.Mustache

```

