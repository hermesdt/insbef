#!/bin/bash

##############################################################################################################################
# Instead of tagging the master branch manually it will be tagged with a new version whenever a branch is merged into master.
#
# We provide a VERSION_CHANGE file in the root directory that indicates if it is a MAJOR, MINOR or PATCH upgrade. The script
# post-merge.sh, that gets executed in the CI, reads the VERSION_CHANGE file in, get the latest git version tag that matches
# the pattern 0-9.0-9.0-9, increment specified part of the version, tag git with the update version and push it to the
# repository.
#
# It also provides safety guards to ensure the new version is not identical to the old version and does not exist in the
# repo yet.
##############################################################################################################################

git_version=$(git version)
echo "post-merge: Running ${git_version}"

# fetch all tags from remote
git fetch --tags

# get all tags with the format 'digit.digit.digit' e.g. '3.1.115'
tagged_versions=$(git tag -l --format "%(refname:short)" --sort=-version:refname --merged HEAD | grep '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$')

# read space separated string into array
read -a all_versions <<< ${tagged_versions}
echo "post-merge: all_versions ${all_versions[@]}"

# get the latest tag
latest_version=${all_versions[0]}
echo "post-merge: latest version is ${latest_version}"

# read in the version change configuration
IFS='.' read -ra version_levels <<< "${latest_version}"
version_change=$(cat VERSION_CHANGE)
echo "post-merge: version_levels ${version_levels[@]}"

# initialise new version with old version
new_version=${latest_version}

# update version depending on the configured version level
case ${version_change} in
  MAJOR)
    echo "post-merge: update MAJOR version"
    update=$((version_levels[0] + 1))
    new_version="${update}.0.0"
    ;;
  MINOR)
    echo "post-merge: update MINOR version"
    update=$((version_levels[1] + 1))
    new_version="${version_levels[0]}.${update}.0"
    ;;
  PATCH)
    echo "post-merge: update PATCH version"
    update=$((version_levels[2] + 1))
    new_version="${version_levels[0]}.${version_levels[1]}.${update}"
    ;;
  *)
    echo "post-merge: no valid version level ${version_change}"
    exit 1
esac

version_has_not_changed() {
  if [[ "${new_version}" == "${latest_version}" ]]
  then
    echo "post-merge: can not tag, new version ${new_version} is identical with latest version ${latest_version}"
    exit 1
  fi
}

version_already_exists() {
  for version in "${all_versions[@]}"; do
    if [[ "${version}" == "${new_version}" ]]
    then
      echo "post-merge: can not tag, new version ${new_version} already exists"
      exit 1
    fi
  done
}

version_has_not_changed

version_already_exists

echo "post-merge: tag merge request with new version ${new_version}"
git tag ${new_version}

echo "post-merge: push new tag ${new_version}"
git push origin ${new_version}
