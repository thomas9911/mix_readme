defmodule MixReadme.Backend.EExTest do
  use ExUnit.Case

  test "backend works" do
    opts = %{module_name: "Testing", module_doc: "This is some text"}

    assert "# Testing\n\nThis is some text" ==
             MixReadme.Backend.EEx.default_template()
             |> MixReadme.Backend.EEx.render!(opts)
  end

  test "paths" do
    assert MixReadme.Backend.EEx.readme_templates()
           |> Enum.any?(fn x -> x == "./readme.eex" end)
  end
end
