defmodule UshortenWeb.UrlControllerTest do
  use UshortenWeb.ConnCase

  @valid_link %{
    link: "http://localhost:4000",
    "g-recaptcha-token": "a valid token"
  }

  @invalid_link %{
    link: "an invalid link",
    "g-recaptcha-token": "a valid token"
  }


  @invalid_recaptcha_token %{
    link: "http://localhost:4000",
    "g-recaptcha-token": "an invalid token"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create url" do
    test "renders url when data is valid", %{conn: conn} do
      Mox.stub(GoogleClientMock, :recaptcha_verify, fn _token ->
        :ok
      end)

      conn = post(conn, ~p"/api/urls", url: @valid_link)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/urls/#{id}")

      assert %{
               "id" => ^id,
               "hash" => "964DB99C9884EA5FA77BC60FCB6E0D75",
               "link" => "http://localhost:4000"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when captcha invalid", %{conn: conn} do
      Mox.stub(GoogleClientMock, :recaptcha_verify, fn _token ->
        :error
      end)

      conn = post(conn, ~p"/api/urls", url: @invalid_recaptcha_token)
      assert json_response(conn, 400) != %{}
      assert json_response(conn, 400)["error"] == "invalid captcha"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      Mox.stub(GoogleClientMock, :recaptcha_verify, fn _token ->
        :ok
      end)

      conn = post(conn, ~p"/api/urls", url: @invalid_link)
      response = json_response(conn, 422)
      assert response != %{}
      assert response["errors"] != %{}
      assert length(response["errors"]["link"]) > 0
    end
  end

end
