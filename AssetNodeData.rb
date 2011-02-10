# AssetNodeData.rb
# VikingBlood
#
# Created by Joshua Holt on 2/6/11.
# Copyright 2011 Eloqua Ltd. All rights reserved.

require 'pp'
class AssetNodeData
  attr_accessor :project, :assets, :rootTreeNode
  
  def initialize(project)
    @project = project
    parsedWorkspace = WorkspaceParser.new(project)
    @assets = parsedWorkspace.tree
    @rootTreeNode = parsedWorkspace.treeNodeFromDictionary(@assets)
  end
  
  def childrenForItem(item)
    ret = item.nil? ? @rootTreeNode.childNodes : item.childNodes
    return ret
  end
  
    #.............................................................
  #  NSOutlineView DataSource Methods
  #
  def outlineView(view, numberOfChildrenOfItem:item)
    #puts "Number of Children Item: #{item}"
    children = self.childrenForItem item
    children.count
  end

  def outlineView(view, isItemExpandable:item)
    #puts "Is Item Expandable Item: #{item}"
    nodeData = item.representedObject
    nodeData.container
  end
  
  def outlineView(view, child:index, ofItem:item)
    #puts "View: #{view} -- Child: #{index} -- Item: #{item}"
    children = self.childrenForItem item
    children.objectAtIndex index
  end

  def outlineView(view, objectValueForTableColumn:tableColumn, byItem:item)
    nodeData = item.representedObject
    
    if tableColumn.nil? || tableColumn.identifier == "name"
      objectValue = nodeData.name
    end
    return objectValue || nil;
  end
  
  def outlineView(view, isGroupItem:item)
    nodeData = item.representedObject
    nodeData.container
  end
  
  def outlineView(view, willDisplayCell:cell, forTableColumn:tc, item:item)
    nodeData = item.representedObject
    
    if nodeData.container
      newTitle = cell.attributedStringValue.mutableCopy
      newTitle.replaceCharactersInRange NSMakeRange(0, newTitle.length), withString: newTitle.string.upcase
      cell.attributedStringValue = newTitle
    end
  end
  
  #def gatherAssetsFromProject
  #  assets = Dir.glob(File.join("#{@project}/apps", '**')).map { |project| project.match(/(\w+)\/(\w+)$/)[0] }#.find_all { |i| !i.match(/tmp/) }.find_all { |i| !!File.file?(i) && i.match(/(apps|controllers|views|models)/) }
  #  frameworks = Dir.glob(File.join("#{@project}/frameworks", '**')).map { |project| project.match(/(\w+)\/(\w+)$/)[0] }#.find_all { |i| !i.match(/tmp/) }.find_all { |i| !!File.file?(i) && i.match(/(apps|controllers|views|models)/) }
  #  self.buildAssetTree(assets.concat(frameworks))
  #end
  
  #def buildAssetTree(array)
  #  array.inject({}) {|h,i| t = h; i.sub!(/^\//, ""); i.split("/").each {|n| t[n] ||= {}; t = t[n]}; h}    
  #end
  

end