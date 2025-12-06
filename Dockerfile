FROM elixir:slim

RUN apt-get update -y && apt-get install -y build-essential inotify-tools npm git \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

ARG host_user_name
ARG host_group_name
ARG host_uid
ARG host_gid

RUN groupadd -g $host_gid $host_group_name \
  && useradd -m -s /bin/bash -u $host_uid -g $host_gid $host_user_name

USER $host_user_name

RUN mix do local.hex --force, local.rebar --force, archive.install --force hex phx_new
