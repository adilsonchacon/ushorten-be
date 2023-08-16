defmodule Ushorten.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :link, :string
    field :hash, :string

    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:link, :hash])
    |> validate_required([:link, :hash])
    |> unique_constraint(:hash)
    |> validate_length(:link, max: 2083)
    |> validate_url_format(:link, &validate_url_format/2)
  end

  def validate_url_format(changeset, field, _ \\ []) do
    validate_change(changeset, field, fn _, link ->
      case URI.parse(link) do
        %URI{scheme: nil} ->
          "is missing a schema (e.g. https)"

        %URI{host: nil} ->
          "is missing a host"

        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist(host)) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        nil -> []
        error -> [{field, error}]
      end
    end)
  end
end
