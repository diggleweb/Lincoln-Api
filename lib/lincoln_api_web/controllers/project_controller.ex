defmodule LincolnApiWeb.API.V1.ProjectController do
  use LincolnApiWeb, :controller

  alias LincolnApi.Dashboard
  alias LincolnApi.Dashboard.Project
  alias LincolnApiWeb.ApiAuthPlug

  action_fallback LincolnApiWeb.FallbackController

  def index(conn, _params) do
    projects = Dashboard.list_projects()
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    with {:ok, %Project{} = project} <- Dashboard.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_project_path(conn, :show, project))
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    project = Dashboard.get_project!(id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Dashboard.get_project!(id)

    with {:ok, %Project{} = project} <- Dashboard.update_project(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Dashboard.get_project!(id)

    with {:ok, %Project{}} <- Dashboard.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
