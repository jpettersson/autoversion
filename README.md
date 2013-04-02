Autoversion
===========

Autoversion is a command line tool that can help you automate aspects around your [semantic versioning](http://semver.org).

Basics
---------

**Read current version**
```Bash
$ autoversion
```

**Increment versions**
```Bash
$ autoversion major
$ autoversion minor
$ autoversion patch
$ autoversion build 'named-version'
```

The Versionfile
--------------------

The Versionfile is a ruby script which is used by Autoversion to read and write version.

**Example**

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



