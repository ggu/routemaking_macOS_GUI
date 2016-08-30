//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

enum Type {
  typeStart, typeTarget, typeObstacle, typeNew, typeVisited, typeCurrent, typeTraveled
};

struct DynamicTile {
  enum Type type;
  int obstacle_risk;
};

struct ATile {
  enum Type type;
  int x;
  int y;
  struct DynamicTile* tiles;
};


struct ATile** GetPath(int startX, int startY, int targetX, int targetY, int* boats, int numBoats);
