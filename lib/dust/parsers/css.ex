defmodule Dust.Parsers.CSS do
  @moduledoc """
  Parse document and returl all links/URIs to
  styles with absolute urls.
  """
  alias Dust.Dom

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    links =
      document
      |> Dom.find("link[rel=stylesheet]", "href")

    links_preloaded =
      document
      |> Dom.find("link[as=style]", "href")

    styles =
      document
      |> Dom.find("style", "src")

    links ++ links_preloaded ++ styles
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
