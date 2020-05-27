![Build Status](https://img.shields.io/travis/com/hive-fleet/hive-state/develop?style=for-the-badge)
![Coverage](https://img.shields.io/coveralls/github/hive-fleet/hive-state/develop?style=for-the-badge)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg?style=for-the-badge)](https://houndci.com)
[![Hex.pm](https://img.shields.io/hexpm/l/hive?color=ff69b4&label=License&style=for-the-badge)](https://opensource.org/licenses/Apache-2.0)

<p align="center">
  <h1 align="center">Dust</h1>
  <p align="center">
    <img width="150" height="150" src="https://raw.githubusercontent.com/hive-fleet/hive-state/develop/assets/logo.svg"/>
  </p>
</p>


## Installation 💾

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dust` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dust, "~> 0.0.1"}
  ]
end
```

## Usage 🧠

```elixir
{:ok, result} = Dust.get(
    url,
    headers: headers,
    proxy: %Proxy{...} | "socks5://user:pass@awesome.host:port",
    max_retries: 3,
    loaders: [:css, :image, :js, :json]
  )
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dust](https://hexdocs.pm/dust).
