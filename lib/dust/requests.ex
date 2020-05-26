defmodule Dust.Requests do
  @moduledoc false
  use Retry

  alias Dust.Requests.{
    ClientState,
    Proxy,
    Result,
    Util
  }

  @type url() :: String.t()
  @type options() :: Keyword.t() | any()

  @max_retries 3
  @wait_ms 100
  def get(url, headers \\ [], options \\ [])

  def get(url, headers, options) do
    {max_retries, options} = Keyword.pop(options, :max_retries, @max_retries)

    retry with: constant_backoff(@wait_ms) |> Stream.take(max_retries) do
      fetch(url, headers, options)
    after
      result -> result
    else
      error -> error
    end
  end

  defp fetch(url, headers, options) do
    start_ms = System.monotonic_time(:millisecond)
    client = ClientState.new(url, headers, options)

    {status, result} =
      url
      |> full_url()
      |> HTTPoison.get(headers, options)
      |> Result.from_request(Util.duration(start_ms))

    {status, result, client}
  end

  def full_url(url) do
    with %{scheme: scheme, host: host, path: path} <- URI.parse(url) do
      "#{scheme || :https}://#{host || path}"
    end
  end
end