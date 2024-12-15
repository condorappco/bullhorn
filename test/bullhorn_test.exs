defmodule BullhornTest do
  use ExUnit.Case
  doctest Bullhorn

  test "version/0" do
    assert Bullhorn.version() == Mix.Project.config()[:version]
  end
end
