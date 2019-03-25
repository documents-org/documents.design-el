defmodule DocumentsDesignWeb.Router do
  use DocumentsDesignWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :global do
    plug DocumentsDesignWeb.Plugs.NeedsFirstUser
    plug DocumentsDesignWeb.Plugs.SetUser
  end

  pipeline :admin do
    plug DocumentsDesignWeb.Plugs.NeedsFirstUser
    plug DocumentsDesignWeb.Plugs.NeedsAuth
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

  scope "/admin", DocumentsDesignWeb do
    pipe_through [:browser, :global, :admin]
    get "/", AdminController, :index
    post "/tags", AdminController, :add_tag
    delete "/tag", AdminController, :delete_tag
    get "/tags", AdminController, :tags
    get "/sequence", AdminController, :sequence
    get "/info", AdminController, :info
    get "/projects", AdminController, :projects
    get "/projects/edit/:id", AdminController, :edit_project
    get "/projects/new", AdminController, :new_project
  end

  scope "/", DocumentsDesignWeb do
    pipe_through [:browser, :global]
    get "/", PageController, :index
    get "/index", PageController, :projects
    get "/project/:slug", PageController, :project

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
