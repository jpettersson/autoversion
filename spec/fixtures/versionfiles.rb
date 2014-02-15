module Versionfiles

  BASE_VERSIONFILE = <<-eos
    read_version do
      File.read File.join(File.dirname(__FILE__), 'spec', 'tmp', 'cli', 'version.txt')
    end

    write_version do |currentVersion, nextVersion|
      File.open(File.join(File.dirname(__FILE__), 'spec', 'tmp', 'cli', 'version.txt'), 'w') do |file| 
        file.write currentVersion.to_s
      end
    end
  eos

  PATTERN_VERSIONFILE = <<-eof
    VERSION_PATTERN = /^\s*VERSION = \"(.+)\"$/

    matcher = proc do |line|
      if m = VERSION_PATTERN.match(line)
        m[1]
      else
        nil
      end
    end

    read_version do
      parse_file "spec/tmp/cli/lib/your-project/version.rb", matcher
    end

    write_version do |oldVersion, newVersion|
      update_files Dir.glob("spec/tmp/cli/**/version.rb"), matcher, oldVersion, newVersion
    end
  eof

  VALID_BASIC = <<-eof
    read_version do
      '1.2.3'
    end

    write_version do |currentVersion, nextVersion|

    end
  eof

  INVALID = <<-eof

  eof

end