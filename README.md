visual_studio_files
===================

Manipulating visual studio files using ruby

## Why is this useful?

For instance if you have lots of links in a csproj to different files and don't want to manually add them every time you change the name of a file.

## How do you use this project?

For instance in your rake file you could add all the files from ProjectY into ProjectX as references:

```
require 'visual_studio_files'

desc "regenerate links in project X"
task :regen_links do
  project_y = VisualStudioFiles::CsProj.new(File.open(File.join($dir,'ProjectY','ProjectY.csproj'), "r").read)
  project_y_files = v.files.select do |file|
    file.type=='Compile' && !file.file.end_with?('AssemblyInfo.cs')
  end
  project_x = VisualStudioFiles::CsProj.new(File.open(File.join($dir,'ProjectX','ProjectX.csproj'), "r").read)
  project_x.clear_links
  project_y_files.each do |file|
    hash = file.to_hash
    hash[:file] = "..\\ProjectX\\#{file.file}"
    hash[:link] = "ProjectX\\#{file.file}"
    project_x.add(hash)
  end

  File.open(File.join($dir,'ProjectX','ProjectX.csproj'), "w") do |f|
    project_x.write f
  end
end
```
