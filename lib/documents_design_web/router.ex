defmodule DocumentsDesignWeb.Router do
  use DocumentsDesignWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :global do
    plug DocumentsDesignWeb.Plugs.NeedsFirstUser
    plug DocumentsDesignWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", DocumentsDesignWeb do
    pipe_through :browser
    get "/register", AuthController, :register
    post "/register", AuthController, :do_register
    get "/verify", AuthController, :verify
    post "/verify", AuthController, :do_verify
    get "/login", AuthController, :login
    post "/login", AuthController, :do_login
  end

  scope "/", DocumentsDesignWeb do
    pipe_through [:browser, :global]
    get "/", PageController, :index

    scope "/auth" do
      get "/logout", AuthController, :logout
      get "/forgot", AuthController, :forgot
      post "/forgot", AuthController, :do_forgot
      get "/reset", AuthController, :reset
      post "/reset", AuthController, :do_reset
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", DocumentsDesignWeb do
  #   pipe_through :api
  # end
end
