#
# rb_main.rb
# VikingBlood
#
# Created by Joshua Holt on 2/3/11.
# Copyright Eloqua Ltd. 2011. All rights reserved.
#

# For Embeded MacRuby
#$:.map! { |x| x.sub(/^\/Library\/Frameworks/, NSBundle.mainBundle.privateFrameworksPath) }
#$:.unshift NSBundle.mainBundle.resourcePath.fileSystemRepresentation

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'
framework 'BWToolkitFramework'

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
