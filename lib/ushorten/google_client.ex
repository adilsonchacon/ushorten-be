defmodule GoogleClient do
  @behaviour GoogleClientBehaviour

  def recaptcha_verify(token) do
    case GoogleRecaptcha.verify(token) do
      :ok ->
        :ok
      _ ->
        :error
    end
  end
end
