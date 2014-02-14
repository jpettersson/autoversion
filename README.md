### Status
[![Build Status](https://travis-ci.org/jpettersson/autoversion.png)](https://travis-ci.org/jpettersson/autoversion)

Autoversion
===========

Autoversion is a command line tool that can automate [semantic versioning](http://semver.org) in your application. It 
integrates nicely with git to give you automatic & atomic commits of version increments. It also supports hooks that can be run before and after a new version has been comitted.

Autoversion is not finished, but it's used enough to be public. Consider it an experiment.<br />
And yes, Autoversion uses Autoversion for versioning ;)

Installation
------------
```
gem install autoversion
```

Usage
-----

**Read current version**
```Bash
$ autoversion
```

**Increment versions**
```Bash
$ autoversion major
$ autoversion minor
$ autoversion patch
```

The Versionfile
--------------------

The project you want to version needs to have a file called 'Versionfile'. Autoversion will evaluate this file as a ruby script. Autoversion provides a small DSL to allow you to read and write versions to your files. Below is an example of the DSL usage:

**Example**

```Ruby

# This block should return a valid Semantic object. Typically it will read a file and parse it.
read_version do
  # Should return a string representation of a semantic version
end

# This block takes the current and next version (strings). Usually this means rewriting some version file.
write_version do |currentVersion, nextVersion|
  # Write the new version to a file
end

after :version do
  # Run some command after any versioning action
  # Example: Run a package script, trigger CI, etc.
end

after :patch do
  # Run some command after patch
end

after :minor do
  # Run some command after minor
end

after :major do
  # Run some command after release
end

```

Versionfile Examples
----------------------------

**A ruby gem**

```Ruby
automate_git

read_version do
  contents = File.read File.join(Dir.pwd, "lib/autoversion/version.rb")
  instance_eval(contents)
  Autoversion::VERSION
end

write_version do |currentVersion, nextVersion|
  contents = File.read File.join(Dir.pwd, "lib/autoversion/version.rb")
  contents = contents.sub(currentVersion.to_s, nextVersion.to_s)

  File.open(File.join(Dir.pwd, "lib/autoversion/version.rb"), 'w') do |file| 
    file.write contents
  end
end
```

**A Chrome Extension**

```Ruby
require 'json'
require 'crxmake'

automate_git :actions => [:commit]

read_version do
  doc = JSON.load File.read('./app/source/manifest.json')
  doc['version']
end

write_version do |currentVersion, nextVersion|
  doc = JSON.load File.read './app/source/manifest.json'
  doc['version'] = nextVersion.to_s
  File.open('./app/source/manifest.json', 'w') {|f| f.write JSON.pretty_generate(doc) }
end

after :version do |currentVersion|
  CrxMake.make(
    :ex_dir => "./app/build",
    :pkey   => "./app/build.pem",
    :crx_output => "./app/releases/#{currentVersion.to_s}.crx",
    :verbose => true,
    :ignorefile => /\.swp/,
    :ignoredir => /\.(?:svn|git|cvs)/
  )
end
```

**A bower module**

```Ruby
require 'json'

# Automatically create an atomic commit of the version file update
# and create a new tag.
automate_git :actions => [:commit, :tag]

file = './bower.json'

read_version do
  doc = JSON.load File.read file
  doc['version']
end

write_version do |currentVersion, nextVersion|
  doc = JSON.load File.read file
  doc['version'] = nextVersion.to_s
  File.open(file, 'w') {|f| f.write JSON.pretty_generate(doc) }
end
```


