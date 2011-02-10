# ProjectNodeData.rb
# VikingBlood
#
# Created by Joshua Holt on 2/4/11.
# Copyright 2011 Eloqua Ltd. All rights reserved.
require 'rubygems'
require 'ap'

class ProjectNodeData
  attr_accessor :workspace, :projects
  
  def initialize(ws)
    @workspace = ws || "/Users/Joshholt/dev/sandbox/SCAPPS"
    @projects  = self.gatherProjectsFromWorkspace(ws)
  end
  
  #.............................................................
  #  NSOutlineView DataSource Methods
  #
  def outlineView(view, numberOfChildrenOfItem:item)
    #puts "Number of Children Item: #{item}"
    return @projects.length if item.nil?
    return @projects[item].empty? ? 1 : @projects[item].length || 0
  end

  def outlineView(view, isItemExpandable:item)
    #puts "Is Item Expandable Item: #{item}"
    if item.is_a?(Hash)
      item.empty? ? false : true
    elsif item.is_a?(String)
      @projects[item].nil? ? false : true
    end
  end

  def outlineView(view, objectValueForTableColumn:tableColumn, byItem:item)
    #puts "Object Value For TC Item: #{item}"
    item
  end

  def outlineView(view, child:index, ofItem:item)
    ret = {}
    #puts "View: #{view} -- Child: #{index} -- Item: #{@projects[item]}"
    if !item.nil?
      @projects[item].to_a[index][0]
    else
      @projects.first[index]
    end
  end
 
  #.............................................................
  #  Internal Methods
  #
  def gatherProjectsFromWorkspace(ws)
    projects = Dir.glob( File.join("#{ws}", '**') )
      .find_all { |i| !File.file?(i) }
      .map { |project| project.match(/(\w+)\/(\w+)$/)[0] }
    self.treeGenerator(projects)
  end
  
  def treeGenerator(array)
    array.inject({}) {|h,i| t = h; i.sub!(/^\//, ""); i.split("/").each {|n| t[n] ||= {}; t = t[n]}; h}    
  end
end
