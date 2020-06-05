defmodule Dust.Requests.Result do
  @moduledoc """
  Result struct to store response data
  """
  use TypedStruct
  alias __MODULE__

  @typedoc "Result struct"
  typedstruct do
    field :content, String.t() | nil
    field :full_content, String.t() | nil
    field :status, non_neg_integer()
    field :duration, non_neg_integer()
    field :headers, map()
    field :error, HTTPoison.Error.t() | nil
    field :original_request, HTTPoison.Response.t() | nil
    field :assets, list({atom(), Result.t()}) | []
  end

  def from_request({:ok, %HTTPoison.Response{} = response}, duration) do
    {
      :ok,
      %Result{
        content: response.body,
        full_content: nil,
        status: response.status_code,
        duration: duration,
        headers: response.headers,
        error: nil,
        original_request: response.request,
        assets: []
      }
    }
  end

  def from_request({:error, %HTTPoison.Error{reason: reason}}, duration) do
    {
      :error,
      %Result{
        content: nil,
        full_content: nil,
        status: 0,
        duration: duration,
        headers: [],
        error: reason,
        original_request: nil,
        assets: []
      }
    }
  end
end
