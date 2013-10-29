require "spec_helper"

describe "VisualStudioFiles" do
  let :csproj do 
     VisualStudioFiles::CsProj.new(SampleFiles.project_csproj)
  end
  it "should contain files" do
    expect(csproj.files.map { |e| e.to_hash }).to match_array [
      {:file=>"..\\\\Isop.WpfControls\\\\BoolToVisibilityConverter.cs", :type=>"Compile", :link=>"WpfControls\\\\BoolToVisibilityConverter.cs", :dependent_upon=>nil, :sub_type=>nil, :generator=>nil}, 
      {:file=>"App.xaml.cs", :type=>"Compile", :link=>nil, :dependent_upon=>"App.xaml", :sub_type=>"Code", :generator=>nil}, 
      {:file=>"MainWindow.xaml.cs", :type=>"Compile", :link=>nil, :dependent_upon=>"MainWindow.xaml", :sub_type=>"Code", :generator=>nil}, 
      {:file=>"Properties\\\\AssemblyInfo.cs", :type=>"Compile", :link=>nil, :dependent_upon=>nil, :sub_type=>"Code", :generator=>nil}, 
      {:file=>"..\\\\Isop.WpfControls\\\\MethodView.xaml", :type=>"Page", :link=>"WpfControls\\\\MethodView.xaml", :dependent_upon=>nil, :sub_type=>"Designer", :generator=>"MSBuild:Compile"}, 
      {:file=>"MainWindow.xaml", :type=>"Page", :link=>nil, :dependent_upon=>nil, :sub_type=>"Designer", :generator=>"MSBuild:Compile"}]
  end
  it "can add" do
    csproj.add(VisualStudioFiles::FileReference.new({
      :file=>"..\\Isop.WpfControls\\SomeFile.cs",
      :type=>'Compile',
      :link=>'WpfControls\\SomeFile.cs'
      }))
    csproj.to_s.should match /SomeFile\.cs/
  end
  it "can add using hash" do
    csproj.add({
      :file=>"..\\Isop.WpfControls\\SomeOtherFile.cs",
      :type=>'Compile',
      :link=>'WpfControls\\SomeOtherFile.cs'
      })
    csproj.to_s.should match /SomeOtherFile\.cs/
  end
  it "can clear links" do
    csproj.clear_links
    csproj.to_s.should_not match /BoolToVisibilityConverter\.cs/
  end
end

describe "" do
  let :isop do 
     VisualStudioFiles::CsProj.new(SampleFiles.isop_csproj)
  end

  let :cli do 
     VisualStudioFiles::CsProj.new(SampleFiles.isop_cli_csproj)
  end

  it "can regen links" do 
    isop_files = isop.files.select do |file|
      file.type=='Compile' && !file.file.end_with?('AssemblyInfo.cs')
    end
    
    cli.clear_links
    isop_files.each do |file|
      file[:file] = "..\\Isop\\#{file.file}"
      file[:link] = "Isop\\#{file.file}"
      cli.add(file)
    end

    links = VisualStudioFiles::CsProj.new(cli.to_s).files.select do |file|
      file.link?
    end
    expect(links.size).not_to eq 0
  end

end
