require "rubygems"
require "rake"

Dir['tasks/**/*.rake'].each { |rake| load rake }

namespace :objc do
  desc "Compiles all Objective-C bundles for testing"
  task :compile
end

task :compile => "objc:compile"

fmdb_dir  = File.dirname(__FILE__) + "/fmdb"
src_files = FileList['fmdb/FM*.m', 'Classes/*.m']

src_files.each do |file|
  FileUtils.mkdir_p "build"
  base = file.gsub(/\.m$/,'')
  dot_o = "build/#{File.basename base}.o"
  file dot_o => ["#{base}.m", "#{base}.h"] do
    sh "gcc -c #{base}.m -o #{dot_o} -I#{fmdb_dir} -IClasses"
  end
end

dot_o_files = src_files.map { |file| "build/" + File.basename(file).gsub(/\.m$/,'') + ".o" }

namespace :objc do
  bundle_name = 'FmdbMigrationManager'

  task :compile => "build/bundles/#{bundle_name}.bundle" do
    if Dir.glob("**/#{bundle_name}.bundle").length == 0
      STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      STDERR.puts "Bundle actually failed to build."
      STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      exit(1)
    end
  end

  file "build/bundles/#{bundle_name}.bundle" => dot_o_files do |t|
    FileUtils.mkdir_p "build/bundles"
    FileUtils.rm Dir["build/bundles/#{bundle_name}.bundle"]
    sh "gcc -o build/bundles/#{bundle_name}.bundle #{dot_o_files.join(" ")} -bundle -framework Foundation -lsqlite3 -I#{fmdb_dir} -IClasses"
  end
end

