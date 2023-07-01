defmodule FlashyTest do
  use ExUnit.Case
  doctest Flashy

  test "version/0" do
    assert Flashy.version() == Mix.Project.config()[:version]
  end
end
