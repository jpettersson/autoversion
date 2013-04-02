Automate your Semantic Versioning
==================

tasks
-----

Read current version
* autoversion

These functions will refuse to run if the current git dir is 'dirty':

Increment version
* autoversion major
* autoversion minor
* autoversion patch
* autoversion build 'named-version'

Undo last version
* autoversion rollback

Versionfile

```Ruby

automate_git 
  :actions => [:commit, :tag], 
  :prefix => 'v', 
  :stable_branch => 'master'

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
  # Example: Export a .crx file, copy & name it for Blackberry
end

after :patch do
  # Run some command after patch
end

after :minor do
  # Run some command after minor
end

after :major do
  # Run some command after release
  # Example: Copy lib/ files from Exo.js to exojs-gem
end

```

Workflow
--------
* Git is automatically integrated and a new atomic commit and tag will be created for each version.
* After a version has been created the script will run any 'after' hooks defined, and in the order they were defined in this file.

Ideas
-----
* Automatically detect lib/gemname/version.rb

Gitflow Integration
-------------------
Use a git hook to detect when a release branch is created


