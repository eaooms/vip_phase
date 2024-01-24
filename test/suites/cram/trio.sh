#!/bin/bash
set -euo pipefail

# shellcheck disable=SC1091
source "${TEST_UTILS_DIR}/utils.sh"

download "$base_url/illumina_WES_GRCh38_chr20.bam" "a50b0cbac22d19197b868e4d81826e38" "${TEST_RESOURCES_DIR}/downloads"
download "$base_url/illumina_WES_GRCh38_chr20.cram" "5172c5531002d3a417da4744526caceb" "${TEST_RESOURCES_DIR}/downloads"
ln -sf "${TEST_RESOURCES_DIR}/downloads/illumina_WES_GRCh38_chr20.bam" "${TEST_RESOURCES_DIR}/downloads/trio_patient.bam"
ln -sf "${TEST_RESOURCES_DIR}/downloads/illumina_WES_GRCh38_chr20.cram" "${TEST_RESOURCES_DIR}/downloads/trio_father.cram"
ln -sf "${TEST_RESOURCES_DIR}/downloads/illumina_WES_GRCh38_chr20.cram" "${TEST_RESOURCES_DIR}/downloads/trio_mother.cram"

args=()
args+=("--workflow" "cram")
args+=("--input" "${TEST_RESOURCES_DIR}/trio.tsv")
args+=("--config" "${TEST_RESOURCES_DIR}/trio.cfg")
args+=("--output" "${OUTPUT_DIR}")
args+=("--resume")

vip "${args[@]}" 1> /dev/null

# compare expected to actual output and store result
if [ "$(zcat "${OUTPUT_DIR}/vip.vcf.gz" | grep -vc "^#")" -gt 0 ]; then
  result="0"
else
  result="1"
fi
echo -n "${result}" > "${OUTPUT_DIR}/.exitcode"

# always exit with success error code
exit 0