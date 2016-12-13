defmodule CodeCorps.ProjectView do
  use CodeCorps.PreloadHelpers,
    default_preloads: [
      :donation_goals, :organization, :project_categories,
      :stripe_connect_plan, :project_skills, :task_lists, :tasks
    ]
  use CodeCorps.Web, :view
  use JaSerializer.PhoenixView

  attributes [
  	:slug, :title, :description, :donations_active, :icon_thumb_url,
    :icon_large_url, :long_description_body, :long_description_markdown,
  	:inserted_at, :total_monthly_donated, :updated_at]

  has_one :organization, serializer: CodeCorps.OrganizationView
  has_one :stripe_connect_plan, serializer: CodeCorps.StripeConnectPlanView

  has_many :donation_goals, serializer: CodeCorps.DonationGoalView, identifiers: :always
  has_many :project_categories, serializer: CodeCorps.ProjectCategoryView, identifiers: :always
  has_many :project_skills, serializer: CodeCorps.ProjectSkillView, identifiers: :always
  has_many :task_lists, serializer: CodeCorps.TaskListView, identifiers: :always
  has_many :tasks, serializer: CodeCorps.TaskView, identifiers: :always

  def donations_active(project, _conn) do
    Enum.any?(project.donation_goals) && project.stripe_connect_plan != nil
  end

  def icon_large_url(project, _conn) do
    CodeCorps.ProjectIcon.url({project.icon, project}, :large)
  end

  def icon_thumb_url(project, _conn) do
    CodeCorps.ProjectIcon.url({project.icon, project}, :thumb)
  end
end
