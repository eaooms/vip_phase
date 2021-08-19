#!/bin/bash
set -euo pipefail

cleanup() {
  rm -rf "${TMP_WORK_DIR}"
}

if [ -z "${TMPDIR+x}" ]; then
  TMPDIR=/tmp
fi

if [ -z "${TMP_WORK_DIR+x}" ]; then
  TMP_WORK_DIR=$(mktemp -d)
  export TMP_WORK_DIR
  trap cleanup EXIT
fi

declare -A VIP_CFG_MAP

VIP_VERSION="2.4.3"

MOD_BCF_TOOLS="BCFtools/1.11-GCCcore-7.3.0"
MOD_CADD="CADD/v1.4-foss-2018b-minimal"
MOD_CAPICE="CAPICE/v1.3.0-foss-2018b"
MOD_GATK="GATK/4.1.4.1-Java-8-LTS"
MOD_GENMOD="genmod/3.7.4-GCCcore-7.3.0-Python-3.9.1"
MOD_HTS_LIB="HTSlib/1.11-GCCcore-7.3.0"
MOD_VCF_ANNO="vcfanno/v0.3.2"
MOD_VCF_DECISION_TREE="vcf-decision-tree/v0.0.3-Java-11-LTS"
MOD_VCF_INHERITANCE_MATCHER="vcf-inheritance-matcher/v0.1.1-Java-11-LTS"
MOD_VCF_REPORT="vcf-report/v2.4.2-Java-11-LTS"
MOD_VEP="VEP/104.2-foss-2018b-Perl-5.28.0"
MOD_VIBE="VIBE/5.1.4-Java-11-LTS"
MOD_ANNOTSV="AnnotSV/v3.0.9-GCCcore-7.3.0"

# Use non-minimal CADD module if the minimal module is not available
if ! module is-avail "${MOD_CADD}"; then
  MOD_CADD="${MOD_CADD%-minimal}"
fi

# Exits if (the specific version of) a module is missing.
for i in ${!MOD_*}; do if ! module is-avail ${!i}; then
  echo -e "missing module: ${!i}"
  exit 1
fi; done
