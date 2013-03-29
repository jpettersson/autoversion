module Versionfiles
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