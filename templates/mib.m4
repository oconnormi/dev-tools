#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.6.1
# ARG_OPTIONAL_BOOLEAN([skip-tests], [s], [Skips all tests], [off])
# ARG_OPTIONAL_BOOLEAN([skip-it], [i], [Skips integration tests], [off])
# ARG_OPTIONAL_BOOLEAN([skip-static], [S], [Skips static analysis plugins], [off])
# ARG_OPTIONAL_SINGLE([branch], [b], [Specify the branch to use for incremental build comparison], [origin/master])
# ARG_POSITIONAL_INF([maven-goals], [Specify any maven goals to execute. (Note: non-goal arguments not yet supported)], [0], [install])
# ARG_DEFAULTS_POS
# ARG_HELP([Execute a maven incremental build (requires gitflow-incremental-builder maven extension)])
# ARGBASH_GO

# [ <-- needed because of Argbash 

_comparison_branch=""

[[ ${_arg_branch} =~ ^[a-z0-9]+\/[a-z0-9]+ ]] && _comparison_branch="remotes/${_arg_branch}" || _comparison_branch="heads/${_arg_branch}"

_global_options="-Dgib.enabled -Dgib.referenceBranch=refs/${_comparison_branch}"
_mvn_args=${_global_options}
_skip_static_options="-Dfindbugs.skip=true -Dcheckstyle.skip=true -DskipStatic"
_skip_test_options="-DskipTests"
_skip_it_options="-DskipITs"

if [ "${_arg_skip_tests}" = "on" ] && [ "${_arg_skip_it}" = "off" ]; then
  _mvn_args="${_mvn_args} ${_skip_test_options}"
fi
if [ "${_arg_skip_it}" = "on" ] && [ "${_arg_skip_tests}" = "off" ]; then
  _mvn_args="${_mvn_args} ${_skip_it_options}"
fi
if [ "${_arg_skip_static}" = "on" ]; then
  _mvn_args="${_mvn_args} ${_skip_static_options}"
fi
mvn ${_mvn_args} ${_arg_maven_goals[@]}
exit $?

# ] <-- needed because of Argbash
