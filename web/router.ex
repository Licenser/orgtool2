defmodule OrgtoolDb.Router do
  use OrgtoolDb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OrgtoolDb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index


  end

  scope "/auth", OrgtoolDb do
    pipe_through :browser # Use the default browser stack

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  scope "/api", OrgtoolDb do
    pipe_through :api
    resources "/sessions", SessionController, except: [:edit, :show]
    resources "/units", UnitController, except: [:new, :edit]
    resources "/units/:id", UnitController, except: [:new, :edit]
    resources "/item_types", ItemTypeController, except: [:new, :edit]
    resources "/items", ItemController, except: [:new, :edit]
    resources "/members", MemberController, except: [:new, :edit]
    resources "/members/:id", MemberController, except: [:new, :edit]
    resources "/handles", HandleController, except: [:new, :edit]
    resources "/handles/:id", HandleController, except: [:new, :edit]
    resources "/props", PropController, except: [:new, :edit]
    resources "/prop_types", PropTypeController, except: [:new, :edit]
    resources "/rewards", RewardController, except: [:new, :edit]
    resources "/unit_types", UnitTypeController, except: [:new, :edit]
    resources "/reward_types", RewardTypeController, except: [:new, :edit]
    resources "/member_rewards", MemberRewardController, except: [:new, :edit]
    resources "/member_units", MemberUnitController, except: [:new, :edit]\
  end
 
end
