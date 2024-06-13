# This file generated by `dagger_codegen`. Please DO NOT EDIT.
defmodule Dagger.GitModuleSource do
  @moduledoc "Module source originating from a git repo."

  use Dagger.Core.QueryBuilder

  @derive Dagger.ID

  defstruct [:selection, :client]

  @type t() :: %__MODULE__{}

  @doc "The URL to clone the root of the git repo from"
  @spec clone_url(t()) :: {:ok, String.t()} | {:error, term()}
  def clone_url(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("cloneURL")

    execute(selection, git_module_source.client)
  end

  @doc "The resolved commit of the git repo this source points to."
  @spec commit(t()) :: {:ok, String.t()} | {:error, term()}
  def commit(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("commit")

    execute(selection, git_module_source.client)
  end

  @doc "The directory containing everything needed to load load and use the module."
  @spec context_directory(t()) :: Dagger.Directory.t()
  def context_directory(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("contextDirectory")

    %Dagger.Directory{
      selection: selection,
      client: git_module_source.client
    }
  end

  @doc "The URL to the source's git repo in a web browser"
  @spec html_url(t()) :: {:ok, String.t()} | {:error, term()}
  def html_url(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("htmlURL")

    execute(selection, git_module_source.client)
  end

  @doc "A unique identifier for this GitModuleSource."
  @spec id(t()) :: {:ok, Dagger.GitModuleSourceID.t()} | {:error, term()}
  def id(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("id")

    execute(selection, git_module_source.client)
  end

  @doc "The clean module name of the root of the module"
  @spec root(t()) :: {:ok, String.t()} | {:error, term()}
  def root(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("root")

    execute(selection, git_module_source.client)
  end

  @doc "The path to the root of the module source under the context directory. This directory contains its configuration file. It also contains its source code (possibly as a subdirectory)."
  @spec root_subpath(t()) :: {:ok, String.t()} | {:error, term()}
  def root_subpath(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("rootSubpath")

    execute(selection, git_module_source.client)
  end

  @doc "The specified version of the git repo this source points to."
  @spec version(t()) :: {:ok, String.t()} | {:error, term()}
  def version(%__MODULE__{} = git_module_source) do
    selection =
      git_module_source.selection |> select("version")

    execute(selection, git_module_source.client)
  end
end
