defmodule PhoenixRest.RouterTest do
  use ExUnit.Case
  use Plug.Test

  defmodule HelloResource do
    use PhoenixRest.Resource

    def to_html(conn, state) do
      {"Hello world!", conn, state}
    end
  end

  defmodule MessageResource do
    use PhoenixRest.Resource

    def init(conn, []) do
      {:ok, conn, "Hello"}
    end

    def init(conn, greeting) do
      {:ok, conn, greeting}
    end

    def to_html(%{params: params} = conn, greeting) do
      %{"message" => message} = params
      {"#{greeting} #{message}!", conn, greeting}
    end
  end

  defmodule OptionsResource do
    use PhoenixRest.Resource

    def to_html(conn, state) do
      {conn.assigns.msg, conn, state}
    end
  end

  defmodule OtherPlug do
    def init(options) do
      options
    end

    def call(conn, options) do
      send_resp(conn, 200, options)
    end
  end

  defmodule RestRouter do
    use PhoenixRest.Router

    resource "/hello", HelloResource
    resource "/hello/:message", MessageResource
    resource "/greeting/:message", MessageResource, "Welcome"

    resource "/options", OptionsResource, [], assigns: %{msg: "Hello world"}

    resource "/plug", OtherPlug, "Hello world"
  end

  test "GET /plug" do
    conn = conn(:get, "/plug")
    conn = RestRouter.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "Hello world"
  end

  test "GET /hello" do
    conn = conn(:get, "/hello")

    conn = RestRouter.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "Hello world!"
  end

  test "OPTIONS /hello" do
    conn = conn(:options, "/hello")

    conn = RestRouter.call(conn, [])

    assert conn.status == 200
    assert (Plug.Conn.get_resp_header(conn, "allow")) == ["HEAD, GET, OPTIONS"]
  end

  test "POST /hello" do
    conn = conn(:post, "/hello")

    conn = RestRouter.call(conn, [])

    assert conn.status == 405
    assert (Plug.Conn.get_resp_header(conn, "allow")) == ["HEAD, GET, OPTIONS"]
  end

  test "GET /hello/:message" do
    conn = conn(:get, "/hello/world")
    conn = RestRouter.call(conn, [])
    assert conn.resp_body == "Hello world!"

    conn = conn(:get, "/hello/everyone")
    conn = RestRouter.call(conn, [])
    assert conn.resp_body == "Hello everyone!"
  end

  test "GET /greeting/:message" do
    conn = conn(:get, "/greeting/everyone")
    conn = RestRouter.call(conn, [])
    assert conn.resp_body == "Welcome everyone!"
  end

  test "GET /options" do
    conn = conn(:get, "/options")
    conn = RestRouter.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "Hello world"
  end
end
