#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.6.1
# ARG_OPTIONAL_BOOLEAN([update-image], [], [Updates the underlying docker image prior to starting])
# ARG_OPTIONAL_SINGLE([image], [], [Image to use for isolated maven build], [oconnormi/dind-maven])
# ARG_OPTIONAL_BOOLEAN([share-m2], [], [Mounts local m2 directory into container. While this breaks isolation somewhat, it is useful for verifying certain build steps without downloading all dependencies every time])
# ARG_LEFTOVERS([Remaining arguments forwarded to containerized build])
# ARG_HELP([Execute maven builds inside a container. Copies local changes into container to be built in isolation.])
# ARGBASH_GO

# [ <-- needed because of Argbash 

# Name for the git archive that will be generated and mounted into the build environment
_archive_name=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)

printf "\nCreating archive of current git HEAD+changes...\n"
if git diff-index --quiet HEAD --; then
  git archive -o /tmp/${_archive_name}.tar.gz HEAD
else
  git archive -o /tmp/${_archive_name}.tar.gz $(git stash create)
fi

_mounts="--mount type=bind,source=/tmp/${_archive_name}.tar.gz,target=/usr/local/src/src.tar.gz"

if [ "${_arg_share_m2}" = "on" ]; then
  _mounts="${_mounts} --mount type=bind,source=${HOME}/.m2,target=/root/.m2"
fi

if [ "${_arg_update_image}" = "on" ]; then
  docker pull ${_arg_image}
fi

docker container run --rm -it --privileged ${_mounts} ${_arg_image} ${_arg_leftovers}

rm -rf /tmp/${_archive_name}.tar.gz


# ] <-- needed because of Argbash
