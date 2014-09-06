defmodule LfsrTest do
  use ExUnit.Case

  test "maximum length sequence is generated" do
    sequence = Stream.iterate(LFSR.new(1, 4), &LFSR.next/1)
    |> Stream.map(&LFSR.state/1)
    |> Enum.take(15)
    |> Enum.sort

    assert sequence == Enum.map(1..15, &(&1))
  end

  test "mask is correctly derived from taps" do
    assert 0xB400 == LFSR.new(1, [16, 14, 13, 11]).mask
  end

  test "default mask is correctly derived from register size" do
    assert 0xB400 == LFSR.new(1, 16).mask
  end

  test "next state" do
    assert 46080 == LFSR.new(1, 16) |> LFSR.next |> LFSR.state
  end

end
