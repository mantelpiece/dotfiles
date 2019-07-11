#!/usr/bin/env bash


running () {
  ps aux | head -n1
  # shellcheck disable=2009
  ps aux | grep --color=always "$@" | grep --color=always -v 'grep'
}
