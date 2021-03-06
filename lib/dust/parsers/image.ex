defmodule Dust.Parsers.Image do
  @moduledoc """
  Parse document and returl all links/URIs to
  scripts with absolute urls.
  """
  alias Dust.Dom
  alias Dust.Parsers

  @doc """
  Extract all links to images

  Following selectors are used:

    * `img`
    * `picture > source`
  """
  @spec parse(Floki.html_tree() | Floki.html_tag()) :: [String.t()]
  def parse(document) do
    imgs = [
      Dom.attr(document, "img", "src"),
      Dom.attr(document, "picture > source", "srcset")
    ]

    imgs
    |> List.flatten()
    |> Enum.reject(&Parsers.URI.is_empty?/1)
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
  end
end
