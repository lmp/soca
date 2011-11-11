module Soca
  module BuildHelpers
    # takes an array of file pairs [[src1, dest1], [src2, dest2], ...]
    # loops through them, ensuring target directory exists
    # if destination modified more recently than source, it is assumed up-to-date, build not required.
    def build_files(pairs, &block)
      pairs.each do |src, dest|
        next if File.exist?(dest) && File.mtime(src) < File.mtime(dest) && File.size(dest) > 5
        FileUtils.mkdir_p(File.dirname(dest))
        yield src, dest
      end
    end
  end
end
