require "rubygems"
require "rake"

Dir['tasks/**/*.rake'].each { |rake| load rake }

namespace :objc do
  desc "Compiles all Objective-C bundles for testing"
  task :compile
end

task :compile => "objc:compile"

namespace :objc do
  # look for Classes/*.m files containing a line "void Init_ClassName"
  # These are the primary classes for bundles; make a bundle for each
  model_file_paths = `find Classes/*.m -exec grep -l "^void Init_" {} \\;`.split("\n")
  model_file_paths.each do |path|
    path =~ /Classes\/(.*)\.m/
    model_name = $1

    task :compile => model_name do
      if Dir.glob("**/#{model_name}.bundle").length == 0
        STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        STDERR.puts "Bundle actually failed to build."
        STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        exit(1)
      end
    end

    task model_name.to_sym => "build/bundles/#{model_name}.bundle"

    file "build/bundles/#{model_name}.bundle" => ["Classes/#{model_name}.m", "Classes/#{model_name}.h"] do |t|
      FileUtils.mkdir_p "build/bundles"
      FileUtils.rm Dir["build/bundles/#{model_name}.bundle"]
      sh "gcc -o build/bundles/#{model_name}.bundle -bundle -framework Foundation Classes/#{model_name}.m"
    end
  end

end

