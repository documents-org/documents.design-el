defmodule DocumentsDesign.Utilities do
  def random_token(len \\ 60) do
    :crypto.strong_rand_bytes(len) |> Base.url_encode64()
  end

  def slugify(string) do
    str = Regex.replace(~r/\s/, string, "-")
    Regex.replace(~r/[^A-Za-z0-9]/, str, "")
  end

  def slug_title(%{"title" => t} = attrs) do
    Map.put(attrs, "slug", slugify(t))
  end
end
