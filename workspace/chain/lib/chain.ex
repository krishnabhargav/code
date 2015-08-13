defmodule Chain do
  def chain(next) do 
    receive do 
      n -> send next, n + 1
    end
  end

  def launch(n) do 
    last = Enum.reduce 1..n, self, 
		 fn (_, state) -> 
                   spawn(Chain, :chain, [state]) 
                 end
    send last, 0
    receive do 
      final_answer when is_integer(final_answer) ->
	"Result is #{inspect(final_answer)}" 
    end
  end

  def run(n) do 
    IO.puts inspect :timer .tc(Chain, :launch, [n])
  end 
end
