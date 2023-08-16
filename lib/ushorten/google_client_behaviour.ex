 defmodule GoogleClientBehaviour do
    @callback recaptcha_verify(token ::String.t()) :: :ok | {:error, :String.t()}
 end
