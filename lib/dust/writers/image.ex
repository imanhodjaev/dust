defmodule Dust.Writers.Image do
  @moduledoc """
  Image loader is responsible to

    1. Extract and resolve all images,
    2. Fetch all image assets,
    3. Inline images as base64 encoded values
  """
  alias ExImageInfo, as: Image
  alias Dust.Dom
  alias Dust.Writers.CSS.Inliner
  alias Dust.Parsers
  alias Dust.Requests.Result

  @type url() :: String.t()
  @type links() :: list(url())
  @type page() :: String.t()
  @type result() :: {:ok, Result.t()} | {:error, Result.t()}
  @type result_list() :: list({url(), result()})

  def tag, do: :image

  @spec extract(Result.t()) :: list(String.t())
  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      Parsers.image(document)
    end
  end

  @spec inline(result_list(), page()) :: String.t()
  def inline(results, page) do
    images =
      results
      |> Enum.map(&get_image/1)

    # Note: it is N^2 by time complexity
    %Result{content: page}
    |> extract()
    |> Enum.map(&remap_urls(&1, images))
    |> Enum.reduce(page, &replace(&1, &2))
    |> Inliner.inline(get_client(results))
  end

  defp get_image({image_url, {:ok, image_result, _client}}) do
    {image_url, image_result.content}
  end

  defp get_image({_image_url, {:error, _image_result, _client}}) do
    Dom.error_image()
  end

  defp get_client(results) do
    {_, {:ok, _, client}} =
      results
      |> Enum.filter(fn {_, {:ok, r, _}} -> r.status < 400 end)
      |> List.first()

    client
  end

  defp remap_urls(relative_url, images) do
    Enum.map(images, fn {url, content} ->
      if String.contains?(url, relative_url) do
        {relative_url, content}
      else
        nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> List.first()
  end

  defp replace({url, image}, inline_to) do
    cond do
      String.ends_with?(url, ".svg") ->
        String.replace(
          inline_to,
          url,
          "data:image/svg+xml;base64,#{Base.encode64(image)}"
        )

      true ->
        String.replace(
          inline_to,
          url,
          encode(image)
        )
    end
  end

  defp encode(asset) do
    case Image.type(asset) do
      {mime, _variant} ->
        "data:#{mime};base64,#{Base.encode64(asset)}"

      _ ->
        Dom.error_image()
    end
  end
end