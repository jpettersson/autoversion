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

# This block should return a valid Semantic object. Typically it will read a file and parse it.
read_version do
  # Return a valid Semantic object
end

# This block should take a Semantic object and persist it. Usually this means rewriting some version file.
write_version do |semver|
  # Write a Semantic object
end

after :version do
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
* Git is automatically integrated and a new atomic commit and tag will be created for each version.
* After a version has been created the script will run any 'after' hooks defined, and in the order they were defined in this file.

