//
//  Constants.swift
//  SimpleGridView
//
//  Created by Gabriel Uribe on 11/25/15.
//

import Foundation
import Cocoa

// MARK: UI: -

// MARK: typealias

typealias Grid = [[TileView]]
typealias GridSize = (width: Int, height: Int)

// MARK: constant

enum WindowPadding {
  static let x: CGFloat = 0
  static let y: CGFloat = 96
}

// MARK: enum

enum Color {
  static let margin = NSColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1).CGColor
  static let visitedTile = NSColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1).CGColor
  static let inactiveTile = NSColor(red: 0.8, green: 0.8, blue: 1, alpha: 1.0).CGColor
  static let startTile = NSColor(red: 0.631, green: 0.996, blue: 0.710, alpha: 1.0).CGColor
  static let travelledTile = NSColor(red: 230/255, green: 1, blue: 230/255, alpha: 1.0).CGColor
  static let targetTile = NSColor.yellowColor().CGColor
  //static let pathTile = NSColor.greenColor().CGColor
  static let boatRiskTile = NSColor(red: 1, green: 0.5, blue: 0.5, alpha: 1).CGColor
}

// MARK: - Logic: -

// MARK: typealias

// MARK: constant

// MARK: enum

enum Condition {
  case location
  case setAll
}