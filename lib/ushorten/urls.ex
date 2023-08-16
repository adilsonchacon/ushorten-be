defmodule Ushorten.Urls do
  @moduledoc """
  The Urls context.
  """

  import Ecto.Query, warn: false
  alias Ushorten.Repo

  alias Ushorten.Urls.Url

  @doc """
  Returns the list of urls.

  ## Examples

      iex> list_urls()
      [%Url{}, ...]

  """
  def list_urls do
    Repo.all(Url)
  end

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(123)
      %Url{}

      iex> get_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url!(id), do: Repo.get!(Url, id)

  @doc """
  Tries to find an existent URL. If URL does not exist, it tries to create a new one.

  ## Examples

      iex> find_or_create_by_link(link)
      {:ok, %Url{}}

      iex> find_or_create_by_link(link)
      {:error, %Ecto.Changeset{}}

      iex> find_or_create_by_link(link)
      {:error, "some DB constraint"}

  """
  def find_or_create_by_link(link) do
    hash_md5 = :crypto.hash(:md5, link) |> Base.encode16()

    url = get_by_hash(hash_md5)
    case url do
      nil ->
        %{link: link}
        |> Map.put(:hash, hash_md5)
        |> create_url
      _ ->
        {:ok, url}
    end
  end

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %Url{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> create_url(%{field: bad_value})
      {:error, "some DB constraint"}
  """
  def create_url((attrs \\ %{})) do
    try do
      %Url{}
      |> Url.changeset(attrs)
      |> Repo.insert()
    rescue
      error -> {:error, error}
    end
  end

  def get_by_hash(hash) do
    Repo.one(from(u in Url, where: u.hash == ^hash))
  end
end
