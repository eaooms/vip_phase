#!/bin/bash
filter () {
  args+=("-i" "!{vcfPath}")

  local operator;
  if [[ "!{params.filter_classes}" =~ .+,.+ ]]; then
    args+=("-f" "VIPC in !{params.filter_classes}")
  else
    args+=("-f" "VIPC is !{params.filter_classes}")
  fi
  if [ "!{params.filter_consequences}" = true ]; then
    args+=("--only_matched")
  fi

  !{singularity_vep} filter_vep "${args[@]}"  | !{singularity_vep} bgzip -c > "!{vcfFilteredPath}"
}

filter
