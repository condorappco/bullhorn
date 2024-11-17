defmodule WalkyTalkyTest do
  use ExUnit.Case
  doctest WalkyTalky

  test "version/0" do
    assert WalkyTalky.version() == Mix.Project.config()[:version]
  end
end
