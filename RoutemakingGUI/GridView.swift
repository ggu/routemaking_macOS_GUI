//
//  GridView.swift
//  SimpleGridView
//
//  Created by Gabriel Uribe on 11/25/15.
//

import Cocoa

protocol GridViewDelegate {
  func boatReceived(x: Int, y: Int)
}

public class GridView : NSView {
  // MARK: - Fields
  var grid: Grid = []
  private var activeTileState: Tile.State
  var startCoordinate: Coordinate
  var targetCoordinate: Coordinate
  var path: [TileView] = []
  var delegate: GridViewDelegate?

  // MARK: -
  
  init(size: CGSize) {
    let frame = CGRectMake(0, 0, size.width, size.height)
    
    self.activeTileState = Tile.State.start
    self.startCoordinate = Coordinate(x: 3, y: 3)
    self.targetCoordinate = Coordinate(x: 5, y: 7)
    
    super.init(frame: frame)
    wantsLayer = true
    
    
    setup()
  }
  
  private func setup() {
    layer?.backgroundColor = Color.margin
    createGrid()
  }
  
  // MARK: - Grid Methods
  private func createGrid() {
    var xPos = 0
    var yPos = 0
    let width = Int(frame.size.width)
    let height = Int(frame.size.height)
    
    for x in 0..<(width / (TILE_WIDTH + TILE_MARGIN) + 5) {
      grid.append([])
      for y in 0..<(height / (TILE_HEIGHT + TILE_MARGIN) + 5) {
        let tileFrame = CGRectMake(CGFloat(xPos), CGFloat(yPos), CGFloat(TILE_WIDTH), CGFloat(TILE_HEIGHT))
        let tile = TileView(frame: tileFrame)
        tile.setCoordinate(Coordinate(x: x, y: y))
        
        addSubview(tile)
        grid[x].append(tile)
        
        yPos += TILE_HEIGHT + TILE_MARGIN
      }
      
      yPos = 0
      xPos += TILE_WIDTH + TILE_MARGIN
    }
    Swift.print(grid.count)
    Swift.print(grid[0].count)
  }
  
  private func setInitialCoordinates() {
    let startTile = grid[startCoordinate.x][startCoordinate.y]
    toggleTileState(startTile, state: Tile.State.start)
    
    let targetTile = grid[targetCoordinate.x][targetCoordinate.y]
    toggleTileState(targetTile, state: Tile.State.target)
  }
  
  private func traverseGrid(state: Tile.State, condition: Condition, value: Any?) {
    for x in grid {
      for tile in x {
        switch condition {
        case .setAll:
          toggleTileState(tile, state: state)
        case .location:
          if let point = value as! CGPoint? {
            setTileIfPoint(tile, point: point, state: state)
          }
        }
      }
    }
  }
  
  // MARK: - Tile state methods
  func toggleTileState(tile: TileView, state: Tile.State) {
    switch state {
    case .new:
      tile.reset()
    case .target:
      tile.setTarget()
    case .start:
      tile.setStart()
    case .visited:
      tile.setVisited()
    case .current:
      tile.setCurrent()
    case .travelled:
      tile.setTravelled()
    case .boat:
      tile.setBoat()
      delegate?.boatReceived(tile.coordinate.x, y: tile.coordinate.y)
    }
  }

  public override func mouseUp(theEvent: NSEvent) {
  }
  
  public override func mouseDragged(theEvent: NSEvent) {
    var point = theEvent.locationInWindow
    point.y -= WindowPadding.y
    for subview: NSView in subviews {
      if subview.frame.contains(point) {
        if setViewIfTile(subview, state: activeTileState) {
          handleNewTileState(subview as! TileView)
        }
      }
    }
  }
  
  public override func mouseDown(theEvent: NSEvent) {
    var point = theEvent.locationInWindow
    point.y -= WindowPadding.y
    for subview: NSView in subviews {
      if subview.frame.contains(point) {
        if setViewIfTile(subview, state: activeTileState) {
          handleNewTileState(subview as! TileView)
        }
      }
    }
  }
  
  override public func acceptsFirstMouse(theEvent: NSEvent?) -> Bool {
    return true
  }
  
  public override func mouseMoved(theEvent: NSEvent) {
    //Swift.print("mouse moved")
  }
  
  // MARK: Helper methods
  
  private func handleNewTileState(tileView: TileView) {
    switch activeTileState {
    case .start:
      toggleTileState(tileView, state: .start)
      
      let oldStartTile = grid[startCoordinate.x][startCoordinate.y]
      toggleTileState(oldStartTile, state: Tile.State.new)
      startCoordinate = tileView.getCoordinate()
      break
    case .target:
      toggleTileState(tileView, state: .target)
      
      let oldTargetTile = grid[targetCoordinate.x][targetCoordinate.y]
      toggleTileState(oldTargetTile, state: Tile.State.new)
      targetCoordinate = tileView.getCoordinate()
    default:
      break
    }
  }
  
  internal func setTargetState() {
    activeTileState = Tile.State.target
  }
  
  internal func setStartState() {
    activeTileState = Tile.State.start
  }
  
  internal func setBoatState() {
    activeTileState = Tile.State.boat
  }
  
  func clearGrid() {
    for y in grid {
      for view in y {
        if view.tile.state != Tile.State.start && view.tile.state != Tile.State.target {
          view.reset()
        }
      }
    }
    
    // replot start and target to be safe
    let startTile = grid[startCoordinate.x][startCoordinate.y]
    startTile.setStart()
    
    let targetTile = grid[targetCoordinate.x][targetCoordinate.y]
    targetTile.setTarget()
  }
  
  func clearPath() {
    for view in path {
      if view.tile.state != Tile.State.start || view.tile.state != Tile.State.target {
        view.reset()
      }
    }
    
    path = []
  }
  
  private func setTileIfPoint(tile: TileView, point: CGPoint, state: Tile.State) {
    if tile.containsPoint(point) {
      toggleTileState(tile, state: state)
    }
  }
  
  private func setViewIfTile(view: NSView, state: Tile.State) -> Bool {
    var isATileView = false
    
    if isTileView(view) {
      let tileView = view as! TileView
      if tileView.tile.state == Tile.State.new {
        toggleTileState(tileView, state: state)
        isATileView = true
      }
    }
    
    return isATileView
  }
  
  func shouldResetGrid(count: Int) -> Bool {
    return count > 1
  }
  
  func isTileView(view: NSView) -> Bool {
    return view.isKindOfClass(TileView)
  }
  
  override public func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    
    // Drawing code here.
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
