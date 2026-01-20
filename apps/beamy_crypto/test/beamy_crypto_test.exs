defmodule BeamyCryptoTest do
  use ExUnit.Case
  doctest BeamyCrypto

  test "greets the world" do
    assert BeamyCrypto.hello() == :world
  end
end
