defmodule FromSupplier6 do
  use CyberOS.DSL
  require Types
  alias Types.T2
  alias Types.T3
  alias Types.T4
  alias Types.T5

  actor I do
    input("f", spec: T4.input_spec())
    input("g", spec: T5.input_spec())
    output("e", spec: T4.output_spec())
  end

  actor R do
    output("d", spec: T3.output_spec())
  end

  actor M do
    input("e", spec: T4.input_spec())
    input("d", spec: T3.input_spec())
    output("c", spec: T2.output_spec())
  end

  composite Supplier6 do
    input("f")
    input("g")
    output("c")

    @impl true
    def initialize(this) do
      {:ok, i} = add_component(this, "I", I, %{}, %{"f" => get_input("f"), "g" => get_input("g")})
      {:ok, r} = add_component(this, "R", R, %{}, %{})

      {:ok, m} =
        add_component(this, "M", M, %{}, %{"e" => get_output(i, "e"), "d" => get_output(r, "d")})

      expose_output(this, get_output(m, "c"))
    end
  end
end