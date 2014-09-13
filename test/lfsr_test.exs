defmodule LFSRTest do
  use ExUnit.Case
  doctest LFSR

  test "maximum length sequence is generated" do
    sequence = LFSR.new(1, 4)
    |> Stream.iterate(&LFSR.next/1)
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

  test "size not in taps table" do
    assert_raise ArgumentError, "no entry for size 900 found in the table of maximum-cycle LFSR taps", fn ->
      LFSR.new(1, 900)
    end
  end
end
