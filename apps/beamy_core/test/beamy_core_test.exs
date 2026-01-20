defmodule BeamyCoreTest do
  use ExUnit.Case
  doctest BeamyCore

  test "greets the world" do
    assert BeamyCore.hello() == :world
  end
end
