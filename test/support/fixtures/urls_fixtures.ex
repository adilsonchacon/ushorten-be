defmodule Ushorten.UrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ushorten.Urls` context.
  """

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        link: "http://localhost:4000",
        hash: "964DB99C9884EA5FA77BC60FCB6E0D75"
      })
      |> Ushorten.Urls.create_url()

    url
  end
end
