# AppController.rb
# VikingBlood
#
# Created by Joshua Holt on 2/3/11.
# Copyright 2011 Eloqua Ltd. All rights reserved.

class AppController
  attr_accessor :files_outline_view, :projects_outline_view, :ws_text_field
  
  def awakeFromNib
    @workspace = NSUserDefaults.standardUserDefaults.stringForKey("last_workspace") || nil
    if !@workspace.nil?
      @ws_text_field.stringValue = @workspace
      self.set_app_in_motion
    else
      # figure this out
    end
  end
  
  def outlineViewSelectionDidChange(notification)
    ov = notification.object
    sn = ov.itemAtRow(ov.selectedRow)
    assets_DEL = AssetNodeData.new("#{@workspace}/#{sn}")
    @files_outline_view.dataSource = assets_DEL
    @files_outline_view.delegate   = assets_DEL
  end
  
  def outlineView(view, isGroupItem:item)
    ret = !view.dataSource.projects[item].nil? ? true : false
  end
  
  def outlineView(view, willDisplayCell:cell, forTableColumn:tc, item:item)
    if !view.dataSource.projects[item].nil?
      newTitle = cell.attributedStringValue.mutableCopy
      newTitle.replaceCharactersInRange NSMakeRange(0, newTitle.length), withString: newTitle.string.upcase
      cell.attributedStringValue = newTitle
    end
  end
  
  def choose_workspace(sender)
    prefs = NSUserDefaults.standardUserDefaults
    
    panel = NSOpenPanel.new
    panel.allowsMultipleSelection = false
    panel.canChooseFiles = false
    panel.canChooseDirectories = true
    panel.setContentSize(NSSize.new(600,600))
    dialogResult = panel.runModal
    
    if dialogResult == 1
      @ws_text_field.stringValue = panel.URLs[0].path
      @workspace = panel.URLs[0].path
      prefs.setObject(@workspace, forKey:"last_workspace")
      set_app_in_motion
    end
  end
  
  def set_app_in_motion
    project_DS_DEL = ProjectNodeData.new(@workspace)
    @projects_outline_view.dataSource = project_DS_DEL
    @projects_outline_view.delegate   = self
  end

  
end