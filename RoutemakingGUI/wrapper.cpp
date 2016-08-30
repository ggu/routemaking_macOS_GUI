//
//  wrapper.cpp
//  RoutemakingGUI
//
//  Created by Gabriel Uribe on 7/27/16.
//  Copyright © 2016 Gabriel Uribe. All rights reserved.
//

#include <stdio.h>

#include <PathfinderController.h>
#include <pathfinding/LocalPathfinder.h>
#include <pathfinding/Astar.h>

Boat SimpleAISBoat(double lat, double lon, int trueHeading, float sog_knots,
                                std::chrono::steady_clock::time_point timeReceived){
  Boat simpleBoat = Boat();
  simpleBoat.m_latitude = lat;
  simpleBoat.m_longitude = lon;
  simpleBoat.m_trueHeading = trueHeading;
  simpleBoat.m_sog = sog_knots;
  simpleBoat.m_timeReceived = timeReceived;
  
  simpleBoat.m_positionValid = true;
  simpleBoat.m_trueHeadingValid = true;
  simpleBoat.m_sogValid = true;
  
  return simpleBoat;
}

struct DynamicTile {
  Type type;
  int obstacle_risk;
};

struct ATile {
  Type type;
  int x;
  int y;
  DynamicTile* tiles;
};


typedef ATile Matrix[62][29];

extern "C" ATile** GetPath(int startX, int startY, int targetX, int targetY, int* boats, int numBoats) {
  LocalPathfinder pathfinder = LocalPathfinder(49.2984988, -123.276173, 10, 49.45584988, -122.750173);
  
  std::list<Boat> theBoats;
  
  for (int i = 0; i < numBoats * 4; i += 4) {
    std::shared_ptr<Tile> boatTile = pathfinder.matrix_[boats[i]][boats[i + 1]];
    Boat boat = SimpleAISBoat(boatTile->lat_, boatTile->lng_, boats[i + 2], boats[i + 3], std::chrono::steady_clock::now());
    theBoats.push_back(boat);
  }
  
  pathfinder.SetStart(startX, startY, 0);
  pathfinder.SetTarget(targetX, targetY);
  pathfinder.SetBoats(theBoats, theBoats);
  pathfinder.Run();
  pathfinder.VisualizePath();
  
  ATile** arr = new ATile*[62];
  for(int i = 0; i < 62; ++i) {
    arr[i] = new ATile[29];
    
    for (int j = 0; j < 29; j++) {
      arr[i][j].tiles = new DynamicTile[100];
    }
  }
  
  for (int y = 0; y < 29; y++) { // pathfinder.y_len
    for (int x = 0; x < 62; x++) { // pathfinder.x_len
      std::shared_ptr<Tile> pTile = pathfinder.matrix_[x][y];
      DynamicTile *dTiles = new DynamicTile[100];
      for (int i = 0; i < 100; i++) {
        dTiles[i].obstacle_risk = pTile->t_[i].obstacle_risk_;
        dTiles[i].type = pTile->t_[i].type_;
      }
      // for dynamic tile
      ATile tile = {pTile->type_, pTile->x_, pTile->y_, dTiles};
      arr[x][y] = tile;
    }
  }
  
  
  return arr;
}
