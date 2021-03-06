defmodule Dust.HTML.Scripts do
  @moduledoc """
  Handles JavaScript assets.
  """
  alias Dust.Asset
  alias Dust.HTML.Format

  @type scripts() :: [binary()]


  @doc """
  Split and prepare each script

  Parameters:

    * `assets` collection of scripts.

  Returns:

    * `[String.t()]` list of JavaScript sources.
  """
  @spec inline([Asset.t()] | keyword()) :: scripts()
  def inline(assets) do
    assets
    |> Keyword.get(:js, [])
    |> Enum.map(&async_inline/1)
    |> Enum.map(&Task.await/1)
  end

  defp async_inline(js) do
    Task.async(fn ->
      case js do
        %{result: {:ok, result, _state}} ->
          [
            "<script lang=\"javascript\">",
            "/*", "Script source:", js.relative_url, "*/",
            Format.split(result.content),
            "</script>"
          ]

        %{result: {:error, _result, _state}} ->
          ["<!--", "Unable to load script:", js.relative_url, "-->"]
      end
    end)
  end
end
