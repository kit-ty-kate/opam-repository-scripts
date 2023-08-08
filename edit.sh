#!/bin/sh

set -e
set -o pipefail

if test "$#" -lt 3 ; then
  echo "Usage: $0 COMMANDS -- FILES"
  echo "For the list of accepted commands, see \"opam-ed --help\""
  exit 1
fi

# arrays in POSIX-complient shell are pretty funny:
# - "set --" sets it
# - "$@" gets it
# - there is only one array at any time per function
first=yes
files_section=no
for x in "$@" ; do
  if test "$first" = "yes" ; then
    set --
    first=no
  fi
  if test "$x" = "--" ; then 
    files_section=yes
    continue
  fi
  if test "$files_section" = "yes" ; then
    set -- "$@" -f "$x"
  else
    set -- "$@" "$x"
  fi
done

if test "$files_section" = "no" ; then
  echo "Error: No files given"
  exit 1
fi

opam-ed --preserve -i "$@"
