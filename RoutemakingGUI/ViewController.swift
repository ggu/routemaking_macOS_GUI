//
//  ViewController.swift
//  RoutemakingGUI
//
//  Created by Gabriel Uribe on 7/27/16.
//  Copyright © 2016 Gabriel Uribe. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {
  private var gridView : GridView?
  var matrix: UnsafeMutablePointer<UnsafeMutablePointer<ATile>>?
  var currentTime: Int = 0
  var playTimer = NSTimer()
  var boats: [(Int, Int, Int, Int)] = []
  
  @IBOutlet weak var bearingTextField: NSTextField!
  @IBOutlet weak var sogTextField: NSTextField!
  @IBOutlet weak var targetButton: NSButton!
  @IBOutlet weak var startButton: NSButton!
  @IBOutlet weak var horizontalSlider: NSSlider!
  @IBOutlet weak var boatButton: NSButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.wantsLayer = true

    gridView = GridView(size: CGSize(width: view.frame.size.width - WindowPadding.x, height: view.frame.size.height - WindowPadding.y))
    gridView?.delegate = self
    gridView?.frame.origin = NSPoint(x: 0,y: WindowPadding.y)
    view.layer?.backgroundColor = NSColor.whiteColor().CGColor
    view.addSubview(gridView!)
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  @IBAction func runAction(sender: AnyObject) {
    reset()
    var int32_boats: Array<Int32> = []
    var count = 0
    for boat in boats {
      int32_boats += [Int32(boat.0), Int32(boat.1), Int32(boat.2), Int32(boat.3)]
      count += 1
    }
    
    let boatsPointer: UnsafeMutablePointer<Int32> = UnsafeMutablePointer(int32_boats)
    
    // dealloc previous pointers?
    matrix = GetPath(Int32((gridView?.startCoordinate.x)!),
            Int32((gridView?.startCoordinate.y)!),
            Int32((gridView?.targetCoordinate.x)!),
            Int32((gridView?.targetCoordinate.y)!), boatsPointer, Int32(count))
    
    mapGrid()
  }
  @IBAction func playAction(sender: AnyObject) {
    playTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.play), userInfo: nil, repeats: true)

  }
  
  @IBAction func resetAction(sender: AnyObject) {
    boats = []
    reset()
  }
  
  @IBAction func startAction(sender: AnyObject) {
    if startButton.state == NSOnState {
      targetButton.state = NSOffState
      boatButton.state = NSOffState
    }
    
    gridView?.setStartState()
  }
  
  
  @IBAction func targetAction(sender: AnyObject) {
    if targetButton.state == NSOnState {
      startButton.state = NSOffState
      boatButton.state = NSOffState
    }
    
    gridView?.setTargetState()
  }
  
  @IBAction func boatAction(sender: AnyObject) {
    if boatButton.state == NSOnState {
      startButton.state = NSOffState
      targetButton.state = NSOffState
    }
    
    gridView?.setBoatState()
  }
  
  @IBAction func sliderMoved(sender: AnyObject) {
    playTimer.invalidate()
    
    let t = horizontalSlider.integerValue
    if t != currentTime {
      currentTime = t
      // rebuild grid
      mapGrid()
    }
  }
  
  func play() {
    if (currentTime != 100) {
      horizontalSlider.integerValue += 1
      currentTime = horizontalSlider.integerValue
      
      mapGrid()
    } else {
      reset()
    }
  }
  
  func reset() {
    playTimer.invalidate()

    horizontalSlider.integerValue = 0
    currentTime = 0
    gridView?.clearGrid()
  }
  
  func mapGrid() {
    for y in UnsafeBufferPointer(start: matrix!, count: 62) {
      for tile in UnsafeBufferPointer(start: y, count: 29) {
        let tileView = gridView!.grid[Int(tile.x)][Int(tile.y)]

        if tile.tiles[currentTime].type == typeNew {
            tileView.reset()
        } else if tile.tiles[currentTime].type == typeVisited {
            tileView.setVisited()
        }
        
        if tile.tiles[currentTime].obstacle_risk != 0 {
          tileView.setBoat()
        }
        
        if tile.tiles[currentTime].type == typeObstacle {
          tileView.setBoat()
        }
        
        if tile.tiles[currentTime].type == typeTraveled {
          tileView.setTravelled()
        } else if tile.tiles[currentTime].type == typeCurrent {
          tileView.setCurrent()
        }
        
        if tile.type == typeTarget {
          tileView.setTarget()
        }
      }
    }
  }
}

extension ViewController: GridViewDelegate {
  func boatReceived(x: Int, y: Int) {
    boats += [(x, y, bearingTextField.integerValue, sogTextField.integerValue)]
  }
}
