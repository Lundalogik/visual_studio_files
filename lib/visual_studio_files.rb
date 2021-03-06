require 'rexml/document'
require 'fileutils'

module VisualStudioFiles
  class CsProj
    attr_reader :content
    def initialize(content)
      @content = content
      @xmldoc = REXML::Document.new(@content)
      @xmlns = {"x"=>"http://schemas.microsoft.com/developer/msbuild/2003"};
    end

    def element_types
      ['Compile','Content','EmbeddedResource','None', 'Page']
    end
    def files()
      files=[]
      element_types.each { |elementType|
          REXML::XPath.each(@xmldoc,"/x:Project/x:ItemGroup/x:#{elementType}", @xmlns) { |file|
            links = file.elements.select{ |el| el.name == 'Link' }.map { |e| e.get_text.value }
            depend_upon = file.elements.select { |el| el.name == 'DependentUpon'  }.map { |e| e.get_text.value }
            generator = file.elements.select { |el| el.name == 'Generator' }.map { |e| e.get_text.value }
            sub_type =  file.elements.select { |el| el.name == 'SubType' }.map { |e| e.get_text.value }
            copy_to_output_directory = file.elements.select { |el| el.name == 'CopyToOutputDirectory' }.map { |e| e.get_text.value }
            hash = {
              :file=>file.attributes['Include'], 
              :type=>elementType, 
              :link=> links.first,
              :dependent_upon=>depend_upon.first,
              :sub_type => sub_type.first
            }
            if generator!=nil
              hash[:generator] = generator.first
            end
            if copy_to_output_directory!=nil
              hash[:copy_to_output_directory] = copy_to_output_directory.first
            end
            files.push(FileReference.new(hash))
          }
      }
      return files
    end
    def add(ref)
      
      ref = FileReference.new(ref) if !ref.is_a? FileReference

      last = REXML::XPath.match(@xmldoc,"/x:Project/x:ItemGroup/", @xmlns).last
      el = last.add_element(ref.type,{'Include'=>ref.file})
      if ref.link
        el.add_element('Link').add_text(ref.link)
      end
      if ref.dependent_upon
        el.add_element('DependentUpon').add_text(ref.dependent_upon)
      end
      if ref.generator
        el.add_element('Generator').add_text(ref.generator)
      end
      if ref.sub_type
        el.add_element('SubType').add_text(ref.sub_type)
      end
      if ref.copy_to_output_directory
        el.add_element('CopyToOutputDirectory').add_text(ref.copy_to_output_directory)
      end
    end
    def clear_links()
      element_types.each { |elementType|
          REXML::XPath.each(@xmldoc,"/x:Project/x:ItemGroup/x:#{elementType}", @xmlns) { |file|
            links = file.elements.select{ |el| el.name == 'Link' }
            if (links.any?)
              file.parent.delete_element(file)
            end
          }
      }
    end
    def to_s
      return @xmldoc.to_s
    end
    def write output
      formatter = REXML::Formatters::Pretty.new(2)
      formatter.compact = true # This is the magic line that does what you need!
      formatter.write(@xmldoc, output)
    end
  end

  class FileReference
    attr_reader :file, :downcase_and_path_replaced, :type, :link, :dependent_upon, :generator, :sub_type, :copy_to_output_directory
    def initialize opts
      opts.each do |key,value|
        self[key]=value
      end
    end
    def downcase_and_path_replaced
      @file.downcase.gsub(/\//,'\\')
    end
    def ==(other)
      other.downcase_and_path_replaced == @downcase_and_path_replaced
    end
    def []=(idx,value)
      case idx
      when :file
        @file = value
      when :type
        @type = value
      when :link
        @link = value
      when :dependent_upon
        @dependent_upon = value
      when :sub_type
        @sub_type = value
      when :generator
        @generator = value
      when :copy_to_output_directory
        @copy_to_output_directory = value
      end
    end
    def link?
      @link!=nil && !@link.empty?
    end
    def none?
      @type=="None"
    end
    def compile?
      @type=="Compile"
    end
    def content?
      @type=="Content"
    end
    def embedded_resource?
      @type=="EmbeddedResource"
    end
    def page?
      @type=="Page"
    end
    alias_method :eql?, :==
    def hash
      @downcase_and_path_replaced.hash
    end
    def to_hash
      return {
        :file=>@file,
        :type=>@type,
        :link=>@link,
        :dependent_upon=>@dependent_upon,
        :sub_type=>@sub_type,
        :generator=>@generator,
        :copy_to_output_directory=>@copy_to_output_directory
      }
    end
    def to_s
      "#{@file} #{@type} #{@link}"
    end
  end

end
