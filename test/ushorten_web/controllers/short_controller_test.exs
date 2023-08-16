defmodule UshortenWeb.ShortControllerTest do
  use UshortenWeb.ConnCase

  alias Ushorten.Urls
  alias Ushorten.Urls.Url

  def url_fixture do
    {:ok, %Url{} = url} = Urls.find_or_create_by_link("http://localhost:4000")
    url
  end

  describe "show url" do
    test "redicted if short URL exists", %{conn: conn} do
      url =  __MODULE__.url_fixture
      conn = get(conn, "/#{Base62.encode(url.id)}")

      assert html_response(conn, 301)
    end

    test "not found errror if short URL does not exist", %{conn: conn} do
      conn = get(conn, "/does_not_exist")
      assert html_response(conn, 404)
    end
  end
end
