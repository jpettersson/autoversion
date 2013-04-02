Autoversion
===========

Autoversion is a command line tool that can automate [semantic versioning](http://semver.org) in your application. The git integration can be used to get automatic atomic commits of version increments.

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

**An npm module**

```Ruby
```


