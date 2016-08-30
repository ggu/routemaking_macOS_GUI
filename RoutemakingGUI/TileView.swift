//
//  TileView.swift
//  RoutemakingGUI
//
//  Created by Gabriel Uribe on 8/3/16.
//  Copyright © 2016 Gabriel Uribe. All rights reserved.
//

import Cocoa

var TILE_WIDTH = 20
var TILE_HEIGHT = 20
var TILE_MARGIN = 1

class TileView: NSView {
  
  var tile : Tile
  var coordinate: Coordinate

  
  override init(frame: CGRect) {
    tile = Tile()
    self.coordinate = Coordinate(x: 0, y: 0)
    
    super.init(frame: frame)
    wantsLayer = true
    layer?.backgroundColor = Color.inactiveTile
    
  }
  
  func setCoordinate(coordinate: Coordinate) {
    self.coordinate = coordinate
  }
  
  func getCoordinate() -> Coordinate {
    return coordinate
  }
  
  func setTarget() {
    layer?.backgroundColor = Color.targetTile
    tile.setTarget()
  }
  
  func setStart() {
    layer?.backgroundColor = Color.startTile
    tile.setStart()
  }
  
  func setCurrent() {
    layer?.backgroundColor = Color.startTile
    tile.setCurrent()
  }
  
  func setVisited() {
    layer?.backgroundColor = Color.visitedTile
    tile.setVisited()
  }
  
  func setTravelled() {
    layer?.backgroundColor = Color.travelledTile
    tile.setTravelled()
  }
  
  func setBoat() {
    layer?.backgroundColor = Color.boatRiskTile
    tile.setBoat()
  }
  
  func reset() {
    layer?.backgroundColor = Color.inactiveTile
    tile.reset()
  }
  
  func containsPoint(point: CGPoint) -> Bool {
    return frame.contains(point)
  }
  
  static func changeTileWidth(width: Int) {
    TILE_WIDTH = width
  }
  
  static func changeTileHeight(height: Int) {
    TILE_HEIGHT = height
  }
  
  static func changeTileMargin(margin: Int) {
    TILE_MARGIN = margin
  }
  
  internal override func print(sender: AnyObject?) {
    //
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.tile = Tile()
    self.coordinate = Coordinate(x: 0, y: 0)
    super.init(coder: aDecoder)
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    
    // Drawing code here.
  }
  
}
