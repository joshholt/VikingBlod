# Node.rb
# VikingBlood
#
# Created by Joshua Holt on 2/5/11.
# Copyright 2011 Eloqua Ltd. All rights reserved.
require 'pp'

class Node
  
  attr_accessor :name, :container
  
  def initialize(name="")
    @name      = name
    @container = true
  end
  
end

class WorkspaceParser
  attr_accessor :workspace, :tree
  
  def initialize(ws)
    @workspace = ws
    Dir.chdir(ws) {
      @tree = storeAndDescend({ "Name" => ws, "Children" => []})
    }
  end
  
  def treeNodeFromDictionary(dict)
    nodeName = dict["Name"]
    nodeData = Node.new(nodeName)
    result   = NSTreeNode.treeNodeWithRepresentedObject(nodeData)
    children = dict["Children"]
    
    children.each { |item|
      if item.is_a?(Hash)
        childTreeNode = self.treeNodeFromDictionary(item)
      else
        childNodeData = item
        childNodeData.container = false
        childTreeNode = NSTreeNode.treeNodeWithRepresentedObject(childNodeData)
        childNodeData = nil
      end
      result.mutableChildNodes.addObject(childTreeNode)
    }
    return result
  end
  
  def storeAndDescend(tree)
    directories = []
    Dir["*"].sort.each do |name|
      if File.file?(name)
        dataObject = Node.new(name)
        dataObject.container = false
        tree["Children"] << dataObject
      elsif File.directory?(name)
        directories << File.expand_path(name)
      end
    end
    directories.each do |name|
      if !name.match(/(tmp|bin)/)
        shortName = name.match(/(\w+)\/(\w+\.?\w+)$/)
        shortName = shortName.nil? ? name : shortName[2]
        Dir.chdir(name) {tree["Children"] << storeAndDescend({"Name" => shortName, "Children" => []}) } if !Dir.pwd[File.expand_path(name)]
      end
    end
    return tree
  end
  
end
