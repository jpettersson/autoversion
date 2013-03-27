Semantic Versioning
==================

tasks
-----

Read current version
* semver

These functions will refuse to run if the current git dir is 'dirty':

Increment version
* semver patch
* semver minor
* semver special 'named-version'
* semver release

Undo last version
* semver rollback

Versionfile

```Ruby

module Hooks
  def read_version
    # Return a valid Semantic object
  end

  def write_version semver
    # Write a Semantic object
  end
end

after :versione do
  # Run some command after any versioning action
end

after :patch do
  # Run some command after patch
end

after :minor do
  # Run some command after minor
end

after :release do
  # Run some command after release
end

```

Workflow
--------
Git is automatically integrated and a new atomic commit and tag will be created for each version.

After a version has been created the script will run any 'after' hooks defined.
--
