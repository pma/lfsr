# LFSR

Elixir implementation of a binary Galois Linear Feedback Shift Register.

It can be used to generate out-of-order counters, since a LFSR of size n can
generate a sequence of length 2<sup>n</sup>-1 (without repetitions).

## Usage

Add LFSR as a dependency in your `mix.exs` file.

```elixir
def deps do
  [{:lfsr, "~> 0.0.1"}]
end
```

After you are done, run `mix deps.get` in your shell to fetch and compile LFSR. Start an interactive Elixir shell with `iex -S mix`.

```iex
iex> lfsr = LFSR.new(1, 16)
%LFSR{mask: 46080, state: 1}
iex> lfsr = lfsr |> LFSR.next |> LFSR.next
%LFSR{mask: 46080, state: 23040}
iex> LFSR.state(lfsr)
23040
```

### Usage with Streams

Let's generate a pseudo-random sequence of numbers between 1_000_000 and 9_999_999.

We need a 24-bit LFSR, since with a 23-bit we can only produce a sequence with length 8_388_607.

```iex
iex> LFSR.new(5_345_234, 24) \
...> |> Stream.iterate(&LFSR.next/1) \
...> |> Stream.map(&LFSR.state/1) \
...> |> Stream.filter(&(&1 in 1_000_000..9_999_999)) \
...> |> Enum.take(100)
[5345234, 2672617, 6697466, 3348733, 6342207, 9312455, 9930289, 9683736,
 4841868, 2420934, 1210467, 5787404, 2893702, 1446851, 5816952, 2908476,
 1454238, 8610569, 5036226, 2518113, 6658840, 3329420, 1664710, 6002284,
 3001142, 1500571, 5823667, 5315478, 2657739, 6230457, 8111214, 4055607,
 8764486, 4382243, 5397444, 2698722, 1349361, 6890940, 3445470, 1722735,
 8472877, 5001803, 5474889, 7922322, 3961161, 6495314, 3247657, 6316938,
 3158469, 6294641, ...]
```

### Usage with Agents

```elixir
defmodule PRNG do
  def start_link do
    Agent.start_link(fn -> LFSR.new(5_345_234, 24) end, name: __MODULE__)
  end

  def next do
    Agent.get_and_update(__MODULE__, fn lfsr ->
      lfsr = next_valid(lfsr)
      {lfsr.state, lfsr}
    end)
  end

  defp next_valid(%LFSR{} = lfsr) do
    lfsr = LFSR.next(lfsr)
    if lfsr.state in 1_000_000..9_999_999, do: lfsr, else: next_valid(lfsr)
  end
end
```

```iex
iex> PRNG.start_link
{:ok, #PID<0.101.0>}
iex> PRNG.next
2672617
iex> PRNG.next
6697466
```
## References

* http://en.wikipedia.org/wiki/Maximum_length_sequence
* http://en.wikipedia.org/wiki/Linear_feedback_shift_register#Galois_LFSRs
* http://www.eej.ulst.ac.uk/~ian/modules/EEE515/files/old_files/lfsr/lfsr_table.pdf