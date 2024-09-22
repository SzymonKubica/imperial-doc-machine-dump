# Modified by Szymon Kubica (sk4520) 18 Feb 2023
# distributed algorithms, n.dulay, 31 jan 2023
# coursework, paxos made moderately complex
#
# some functions for debugging

defmodule Debug do
  def info(config, message, verbose \\ 1) do
    if config.debug_level >= verbose do
      IO.puts("--> Debug #{config.node_name} at #{config.node_location} #{message}")
    end
  end

  def map(config, themap, verbose \\ 1) do
    if config.debug_level >= verbose do
      for {key, value} <- themap do
        IO.puts("  #{key} #{inspect(value)}")
      end
    end
  end

  def starting(config, verbose \\ 0) do
    if config.debug_level >= verbose do
      IO.puts("--> Starting #{config.node_name} at #{config.node_location}")
    end
  end

  def letter(config, letter, verbose \\ 3) do
    if config.debug_level >= verbose do
      IO.write(letter)
    end
  end

  def mapstring(map) do
    for {key, value} <- map, into: "" do
      "\n  #{key}\t #{inspect(value)}"
    end
  end

  # This function logs a message only if the level (:quiet, :error, :success, :verbose)
  # in the arguments is lower or equal to the logger_config for the particular module
  # (entity, i.e. replica, leader, commander etc.). The default parameter is level
  # value is :verbose which means that such message will only be printed when
  # configured with the highest level of logging (:verbose)
  def log(entity, message, level \\ :verbose) do
    config = entity.config

    id_line = "#{String.capitalize(Atom.to_string(entity.type))}#{entity.config.node_num}"

    if config.debug_level > 1 and
         get_priority(level) <= get_priority(config.logger_level[entity.type]) do
      IO.puts(id_line <> ": log_#{entity.config.line_num}" <> "\n--> " <> message <> "\n")

      entity |> increment_line_num
    else
      entity
    end
  end

  def increment_line_num(entity) do
    %{entity | config: %{entity.config | line_num: entity.config.line_num + 1}}
  end

  def get_priority(level) do
    case level do
      :quiet -> 0
      :error -> 1
      :success -> 2
      :verbose -> 3
    end
  end
end

# Log
