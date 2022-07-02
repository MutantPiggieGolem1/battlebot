public Layer getLayer(LayerType t, Maps p) {
  switch (t) {
    case BASE:
      return new Layer(p,t);
    case OVERLAY:
      return new Layer(p,t);
    case INTERACT:
      return new InteractLayer(p);
    case COLLIDE:
      return new CollideLayer(p);
    case TOP:
      return new Layer(p,t);
    default:
      return null;
  }
}

class Layer {
  private Maps parent;
  private Tile[][] tiles;
  private LayerType type;
  private Dimension tilesize;
  
  public Layer(Maps p, LayerType t) {
      System.out.println("i hate sdfaye");

    this.parent = p;
    this.type = t;
    this.tilesize = p.getTileSize();
    int[][] ld = p.getLayerData(t);
    for (int x = 0; x < ld.length; x++) {
      int[] ld1= ld[x];
      for (int y = 0; y < ld1.length; y++) {
        int ld2= ld1[y];
        if (ld2 == 486) continue;
        tiles[x][y] = new Tile(ld2,new Location(p,this.tilesize.width*x,this.tilesize.height*y));
      }
    }
  }
  public void draw() {
    for (Tile[] tt : this.tiles) {
      for (Tile t : tt) {
        if (t != null) t.draw();
      }
    }
  }
  public Tile getTile(int cx, int cy) {
    return tiles[cx][cy];
  }
  public Tile getTile(Location l) {
    return tiles[l.loc.x/this.tilesize.width][l.loc.y/this.tilesize.height];
  }
  
  public boolean checkCollisions(Location l) {return false;};
}

class InteractLayer extends Layer {
  public InteractLayer(Maps p) {
    super(p,LayerType.INTERACT);
  }
  
  @Override
  public boolean checkCollisions(Location l) {
    return this.getTile(l).checkCollisions(l);
  }
}

class CollideLayer extends Layer {
  public CollideLayer(Maps p) {
    super(p,LayerType.COLLIDE);
  }
  
  @Override
  public boolean checkCollisions(Location l) {
    return this.getTile(l) != null;
  }
}
