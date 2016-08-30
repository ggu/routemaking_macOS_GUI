//
//  Tile.swift
//  SimpleGridView
//
//  Created by Gabriel Uribe on 11/25/15.
//

import Foundation

internal struct Tile {
  enum State {
    case new
    case start
    case target
    case visited
    case current
    case travelled
    case boat
  }
  
  var state = State.new
  
  mutating func setStart() {
    state = .start
  }
  
  mutating func setTarget() {
    state = .target
  }
  
  mutating func setVisited() {
    state = .visited
  }
  
  mutating func setTravelled() {
    state = .travelled
  }
  
  mutating func setCurrent() {
    state = .current
  }
  
  mutating func setBoat() {
    state = .boat
  }
  
  mutating func reset() {
    state = .new
  }
}
