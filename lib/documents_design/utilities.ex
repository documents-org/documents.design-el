defmodule DocumentsDesign.Utilities do
  def random_token(len \\ 60) do
    :crypto.strong_rand_bytes(len) |> Base.url_encode64()
  end
end
