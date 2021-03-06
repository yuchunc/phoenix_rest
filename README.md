# PhoenixRest

[![Build Status](https://travis-ci.org/christopheradams/phoenix_rest.svg?branch=master)](https://travis-ci.org/christopheradams/phoenix_rest)
[![Hex Version](https://img.shields.io/hexpm/v/phoenix_rest.svg)](https://hex.pm/packages/phoenix_rest)

Resource routing and REST behaviour for Phoenix web applications.

PhoenixRest integrates the
[PlugRest](https://github.com/christopheradams/plug_rest) library into
your Phoenix application by making a new `resource` macro available in
the existing router.

Instead of writing a Phoenix `Controller` and implementing an `action`
function for each HTTP verb and path, use this library to create a
`Resource` and define one or more optional callbacks that describe
your resource's RESTful behavior.

[Documentation for PhoenixRest is available on hexdocs](http://hexdocs.pm/phoenix_rest/).<br/>
[Source code is available on Github](https://github.com/christopheradams/phoenix_rest).<br/>
[Package is available on hex](https://hex.pm/packages/phoenix_rest).

## Hello World

Add a new route to your router to match a path with a resource
handler:

```elixir
defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router

  resource "/hello", HelloPhoenix.HelloResource
end
```

Create a resource at `web/resources/hello_resource.ex` defining the
resource handler, and implement the optional callbacks:

```elixir
defmodule HelloPhoenix.HelloResource do
  use PhoenixRest.Resource

  def to_html(conn, state) do
    {"Hello world", conn, state}
  end
end
```

The [docs](https://hexdocs.pm/phoenix_rest/PhoenixRest.Resource.html)
for `PhoenixRest.Resource` list all of the supported REST callbacks
and their default values.

## Installation

Add PhoenixRest to your Phoenix project in three steps:

  1. Add `:phoenix_rest` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:phoenix_rest, "~> 0.4.0"}]
    end
    ```

  2. Ensure `phoenix_rest` is started before your application:

    ```elixir
    def application do
      [applications: [:phoenix_rest]]
    end
    ```

  3. Edit `web/web.ex` and add the router:

    ```elixir
    def router do
      quote do
        use Phoenix.Router
        use PhoenixRest.Router
      end
    end
    ```

## Tasks

You can generate a new PhoenixRest resource (with all of the callbacks
implemented) by using a Mix task:

```sh
$ mix phoenix_rest.gen.resource UserResource
```

## Upgrading

PhoenixRest is still in an initial development phase. Expect breaking
changes at least in each minor version.

See the [CHANGELOG](CHANGELOG.md) for more information.

## License

PhoenixRest copyright &copy; 2016, [Christopher Adams](https://github.com/christopheradams)
