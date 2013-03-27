Semantic Versioning
==================

tasks
-----

semver minor +bump
semver patch +bump
semver release +bump

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

after :versioned do
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