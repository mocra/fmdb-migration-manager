require "rubygems"
require "rake"

Dir['tasks/**/*.rake'].each { |rake| load rake }

namespace :objc do
  desc "Compiles all Objective-C bundles for testing"
  task :compile
end

task :compile => "objc:compile"

fmdb_dir = File.dirname(__FILE__) + "/fmdb"

FileList['fmdb/FM*.m'].each do |fmdb_file|
  FileUtils.mkdir_p "build"
  base = fmdb_file.gsub(/\.m$/,'')
  dot_o = "build/#{File.basename base}.o"
  file dot_o => ["#{base}.m", "#{base}.h"] do
    sh "gcc -c #{base}.m -o #{dot_o}"
  end
end

fmdb_o_files = FileList['fmdb/FM*.m'].map { |fmdb_file| File.join("build", File.basename(fmdb_file).gsub(/m$/,'o')) }

namespace :objc do
  # look for Classes/*.m files containing a line "void Init_ClassName"
  # These are the primary classes for bundles; make a bundle for each
  model_file_paths = `find Classes/*.m  -exec grep -l "^void Init_" {} \\;`.split("\n")
  model_file_paths.each do |path|
    path =~ /Classes\/(.*)\.m/
    model_name = $1

    task :compile => "build/bundles/#{model_name}.bundle" do
      if Dir.glob("**/#{model_name}.bundle").length == 0
        STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        STDERR.puts "Bundle actually failed to build."
        STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        exit(1)
      end
    end

    file "build/bundles/#{model_name}.bundle" => fmdb_o_files + ["Classes/#{model_name}.m", "Classes/#{model_name}.h"] do |t|
      FileUtils.mkdir_p "build/bundles"
      FileUtils.rm Dir["build/bundles/#{model_name}.bundle"]
      fmdb_files = FileList['build/FM*.o'].join(" ")
      sh "gcc -o build/bundles/#{model_name}.bundle #{fmdb_files} -bundle -framework Foundation -lsqlite3 -I#{fmdb_dir} Classes/#{model_name}.m"
    end
  end

end

