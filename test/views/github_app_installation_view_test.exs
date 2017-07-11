defmodule CodeCorps.GithubAppInstallationViewTest do
  use CodeCorps.ViewCase

  test "renders all attributes and relationships properly" do
    organization = insert(:organization)
    project = insert(:project)
    user = insert(:user)
    github_app_installation = insert(:github_app_installation, project: project, user: user)
    organization_github_app_installation = insert(:organization_github_app_installation, github_app_installation: github_app_installation, organization: organization)

    rendered_json = render(CodeCorps.GithubAppInstallationView, "show.json-api", data: github_app_installation)

    expected_json = %{
      "data" => %{
        "id" => github_app_installation.id |> Integer.to_string,
        "type" => "github-app-installation",
        "attributes" => %{
          "github-id" => github_app_installation.github_id,
          "inserted-at" => github_app_installation.inserted_at,
          "installed" => github_app_installation.installed,
          "state" => github_app_installation.state,
          "updated-at" => github_app_installation.updated_at
        },
        "relationships" => %{
          "organization-github-app-installations" => %{
            "data" => [
              %{"id" => organization_github_app_installation.id |> Integer.to_string, "type" => "organization-github-app-installation"}
            ]
          },
          "project" => %{
            "data" => %{"id" => github_app_installation.project_id |> Integer.to_string, "type" => "project"}
          },
          "user" => %{
            "data" => %{"id" => github_app_installation.user_id |> Integer.to_string, "type" => "user"}
          }
        }
      },
      "jsonapi" => %{
        "version" => "1.0"
      }
    }

    assert rendered_json == expected_json
  end
end
