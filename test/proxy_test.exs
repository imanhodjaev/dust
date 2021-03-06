defmodule Dust.ProxyTest do
  use ExUnit.Case
  alias Dust.Requests.Proxy

  describe "proxy :: 📡" do
    test "can parse socks proxy" do
      proxy = %Proxy{
        address: "socks5://192.168.0.1:1234"
      }

      expected = [
        proxy: {:socks5, '192.168.0.1', 1234},
      ]

      assert expected == Proxy.get_config(proxy)

      proxy = %Proxy{
        address: "socks5://192.168.0.1:1234",
        username: "user",
        password: "password",
      }

      expected = [
        proxy: {:socks5, '192.168.0.1', 1234},
        socks5_user: "user",
        socks5_pass: "password"
      ]

      assert expected == Proxy.get_config(proxy)

      proxy = %Proxy{
        address: "socks5://user:password@192.168.0.1:1234"
      }

      expected = [
        proxy: {:socks5, '192.168.0.1', 1234},
        socks5_user: "user",
        socks5_pass: "password"
      ]

      assert expected == Proxy.get_config(proxy)
    end

    test "can parse tcp proxy" do
      proxy = %Proxy{
        address: "http://192.168.0.1:1234"
      }

      expected = [
        proxy: '192.168.0.1'
      ]

      assert expected == Proxy.get_config(proxy)

      proxy = %Proxy{
        address: "http://192.168.0.1:1234",
        username: "user",
        password: "password",
      }

      expected = [
        proxy_auth: {"user", "password"},
        proxy: '192.168.0.1'
      ]

      assert expected == Proxy.get_config(proxy)

      proxy = %Proxy{
        address: "http://user:password@192.168.0.1:1234"
      }

      expected = [
        proxy_auth: {"user", "password"},
        proxy: '192.168.0.1'
      ]

      assert expected == Proxy.get_config(proxy)
    end
  end
end
