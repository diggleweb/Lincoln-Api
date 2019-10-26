defmodule LincolnApiWeb.ProjectControllerTest do
  use LincolnApiWeb.ConnCase

  alias LincolnApi.Dashboard
  alias LincolnApi.Dashboard.Project

  @create_attrs %{
    attachment: "some attachment",
    description: "some description",
    end_date: ~D[2010-04-17],
   
    name: "some name",
    start_date: ~D[2010-04-17]
  }
  @update_attrs %{
    attachment: "some updated attachment",
    description: "some updated description",
    end_date: ~D[2011-05-18],
    name: "some updated name",
    start_date: ~D[2011-05-18]
  }
  @invalid_attrs %{attachment: nil, description: nil, end_date: nil,  : nil, name: nil, start_date: nil}

  def fixture(:project) do
    {:ok, project} = Dashboard.create_project(@create_attrs)
    project
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get(conn, Routes.project_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      conn = post(conn, Routes.project_path(conn, :create), project: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.project_path(conn, :show, id))

      assert %{
               "id" => id,
               "attachment" => "some attachment",
               "description" => "some description",
               "end_date" => "2010-04-17",
               "name" => "some name",
               "start_date" => "2010-04-17"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.project_path(conn, :create), project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id} = project} do
      conn = put(conn, Routes.project_path(conn, :update, project), project: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.project_path(conn, :show, id))

      assert %{
               "id" => id,
               "attachment" => "some updated attachment",
               "description" => "some updated description",
               "end_date" => "2011-05-18",
               "name" => "some updated name",
               "start_date" => "2011-05-18"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put(conn, Routes.project_path(conn, :update, project), project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete(conn, Routes.project_path(conn, :delete, project))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.project_path(conn, :show, project))
      end
    end
  end

  defp create_project(_) do
    project = fixture(:project)
    {:ok, project: project}
  end
end
