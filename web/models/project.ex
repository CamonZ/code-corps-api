defmodule CodeCorps.Project do
  @moduledoc """
  Represents a project on Code Corps, e.g. the "Code Corps" project itself.
  """

  use CodeCorps.Web, :model

  import CodeCorps.Helpers.RandomIconColor
  import CodeCorps.Helpers.Slug
  import CodeCorps.Helpers.URL, only: [prefix_url: 2]
  import CodeCorps.Validators.SlugValidator

  alias CodeCorps.Services.MarkdownRendererService
  alias CodeCorps.TaskList

  @type t :: %__MODULE__{}

  schema "projects" do
    field :approved, :boolean
    field :cloudinary_public_id
    field :default_color
    field :description, :string
    field :long_description_body, :string
    field :long_description_markdown, :string
    field :should_link_externally, :boolean, default: false # temporary for linking to projects off Code Corps while in alpha
    field :slug, :string
    field :title, :string
    field :total_monthly_donated, :integer, default: 0
    field :website, :string

    belongs_to :organization, CodeCorps.Organization

    has_one :stripe_connect_plan, CodeCorps.StripeConnectPlan

    has_many :donation_goals, CodeCorps.DonationGoal
    has_many :project_categories, CodeCorps.ProjectCategory
    has_many :project_skills, CodeCorps.ProjectSkill
    has_many :project_users, CodeCorps.ProjectUser
    has_many :task_lists, CodeCorps.TaskList
    has_many :tasks, CodeCorps.Task

    has_many :categories, through: [:project_categories, :category]
    has_many :skills, through: [:project_skills, :skill]
    has_many :stripe_connect_subscriptions, through: [:stripe_connect_plan, :stripe_connect_subscriptions]

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:title, :description, :long_description_markdown, :cloudinary_public_id, :default_color])
    |> validate_required(:title)
    |> generate_slug(:title, :slug)
    |> validate_slug(:slug)
    |> unique_constraint(:slug, name: :index_projects_on_slug)
    |> MarkdownRendererService.render_markdown_to_html(:long_description_markdown, :long_description_body)
  end

  @doc """
  Builds a changeset for creating a project.
  """
  def create_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:organization_id])
    |> put_assoc(:task_lists, TaskList.default_task_lists())
    |> generate_icon_color(:default_color)
  end

  @doc """
  Builds a changeset for updating a project.
  """
  def update_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:website])
    |> prefix_url(:website)
    |> validate_format(:website, CodeCorps.Helpers.URL.valid_format())
  end

  def update_total_changeset(struct, params) do
    struct
    |> cast(params, [:total_monthly_donated])
  end
end
