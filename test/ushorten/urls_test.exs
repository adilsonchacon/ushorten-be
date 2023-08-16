defmodule Ushorten.UrlsTest do
  use Ushorten.DataCase

  alias Ushorten.Urls

  describe "urls" do
    alias Ushorten.Urls.Url

    import Ushorten.UrlsFixtures

    @invalid_attrs %{link: nil, hash: nil}

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert Urls.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert Urls.get_url!(url.id) == url
    end

    test "create_url/1 with valid data creates a url" do
      valid_attrs = %{link: "http://localhost:4000", hash: "964DB99C9884EA5FA77BC60FCB6E0D75"}

      assert {:ok, %Url{} = url} = Urls.create_url(valid_attrs)
      assert url.link == "http://localhost:4000"
      assert url.hash == "964DB99C9884EA5FA77BC60FCB6E0D75"
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(@invalid_attrs)
    end

    test "find_or_create_by_link/1 with valid data creates a url" do
      link = "http://localhost:4000"

      assert {:ok, %Url{} = url} = Urls.find_or_create_by_link(link)
      assert url.link == "http://localhost:4000"
      assert url.hash == "964DB99C9884EA5FA77BC60FCB6E0D75"
    end

    test "find_or_create_by_link/1 with invalid link returns error changeset" do
      link = "invalid link"

      assert {:error, %Ecto.Changeset{}} = Urls.find_or_create_by_link(link)
    end
  end
end
