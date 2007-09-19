# -*- ruby -*-

require './tasks.rb'

build = AlexandriaBuild.new('alexandria', '0.6.2') do |b|

  b.author = 'Joseph Method'     # Maintainer
  b.email  = 'tristil@gmail.com' # Maintainer e-mail
  b.summary = 'A book library manager for Gnome'

  # ... this next bit is from Hoe and may yet be implemented ....
  # b.description = b.paragraphs_of('doc/README', 2..5).join("\n\n")
  # b.url = b.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  # p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")

  b.files.source = FileList['lib/**/*.rb',
                            'bin/alexandria',
                            'specs/**/*.rb']
  b.files.data = FileList['data/alexandria/**/*.*',
                          'data/gnome/**/*.*',
                          'data/omf/alexandria/*.omf']
  b.files.icons = FileList['data/app-icon/**/*.png',
                           'data/app-icon/scalable/*.svg']
  b.files.rdoc = FileList['doc/*',
                          'COPYING',
                          'ChangeLog',
                          'TODO']
  b.rdoc.main = 'doc/README'
end

##
## Extra tasks (not yet part of AlexandriaBuild tasks)
##


## autogenerated files

# generate lib/alexandria/config.rb
file 'lib/alexandria/config.rb' => ['Rakefile'] do |f|
  build.generate f.name do
<<EOS
module Alexandria
  module Config
    DATA_DIR = '#{build.install.prefix}/share/#{build.name}'
    MAIN_DATA_DIR = DATA_DIR
    LIB_DIR = '#{build.install.rubylib}'
  end
end
EOS
  end
end

# generate lib/alexandria/version.rb
file 'lib/alexandria/version.rb' => ['Rakefile'] do |f|
  build.generate f.name do
<<EOS
module Alexandria
  VERSION = "#{build.version}"
end
EOS
  end
end



# generate default_preferences.rb
def convert_with_type(value, type)
    case type
        when 'int'
            value.to_i
        when 'float'
            value.to_f
        when 'bool'
            value == 'true'
        else
            value.strip
    end
end

SCHEMA_PATH = 'schemas/alexandria.schemas'

file 'lib/alexandria/default_preferences.rb' => [SCHEMA_PATH] do |f|
  require 'rexml/document'
  generated_lines = []

  doc = REXML::Document.new(IO.read(SCHEMA_PATH))
  doc.elements.each('gconfschemafile/schemalist/schema') do |element|
    default = element.elements['default'].text
    next unless default
    varname = File.basename(element.elements['key'].text)
    type = element.elements['type'].text

    if type == 'list' or type == 'pair'
      ary = default[1..-2].split(',')
      next if ary.empty?
      if type == 'list'
        list_type = element.elements['list_type'].text
        ary.map! { |x| convert_with_type(x, list_type) }
      elsif type == 'pair'
        next if ary.length != 2
        ary[0] = convert_with_type(ary[0],
                                   element.elements['car_type'].text)
        ary[1] = convert_with_type(ary[1],
                                   element.elements['cdr_type'].text)
      end
      default = ary.inspect
    else
      default = convert_with_type(default, type).inspect.to_s
    end

    generated_lines << varname.inspect + ' => ' + default
  end

  build.generate f.name do
<<EOS
module Alexandria
  class Preferences
    DEFAULT_VALUES = {#{generated_lines.join(",\n      ")}}
  end
end
EOS
  end
end


autogenerated_files = ['lib/alexandria/config.rb',
                       'lib/alexandria/version.rb',
                       'lib/alexandria/default_preferences.rb']

desc "Generate ruby files needed for the installation"
task :autogen => autogenerated_files

task :autogen_clobber do |t|
  autogenerated_files.each do |file|
    FileUtils.rm_f(file)
  end
end
task :clobber => [:autogen_clobber]


## # # # default task # # # ##

task :build => [:autogen, :gettext, :omf]

task :default => [:build]


## # # # installation # # # ##

task :pre_install => [:build]

task :scrollkeeper do
  unless system("which scrollkeeper-update")
    raise "scrollkeeper-update cannot be found, is Scrollkeeper correctly installed?"
  end
  system('scrollkeeper-update -q') or raise 'Scrollkeeper update failed'
end

task :gconf do
  return if ENV['GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL']

  unless system("which gconftool-2")
    raise "gconftool-2 cannot be found, is GConf2 correctly installed?"
  end

  ENV['GCONF_CONFIG_SOURCE'] = `gconftool-2 --get-default-source`.chomp
  Dir["schemas/*.schemas"].each do |schema|
    system("gconftool-2 --makefile-install-rule '#{schema}'")
  end
end

task :update_icon_cache do
  system("gtk-update-icon-cache -f -t /usr/share/icons/hicolor") # HACK
end

task :post_install => [:scrollkeeper, :gconf, :update_icon_cache]


# vim: syntax=Ruby
