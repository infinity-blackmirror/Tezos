#! /bin/sh

## `ocaml-version` should be in sync with `README.rst` and
## `lib.protocol-compiler/tezos-protocol-compiler.opam`

ocaml_version=4.09.1
opam_version=2.0
recommended_rust_version=1.39.0

## Please update `.gitlab-ci.yml` accordingly
## full_opam_repository is a commit hash of the public OPAM repository, i.e.
## https://github.com/ocaml/opam-repository
full_opam_repository_tag=fb801efd13b2e6370271608f2bfd528f2eea72bb

## opam_repository is an additional, tezos-specific opam repository.
opam_repository_tag=ddcc631c7a7b72c48c8bc7a11047bf0c18ef300e
opam_repository_url=https://gitlab.com/nomadic-labs/opam-repository.git
opam_repository=$opam_repository_url\#$opam_repository_tag

## Other variables, used both in Makefile and scripts
COVERAGE_OUTPUT=_coverage_output
