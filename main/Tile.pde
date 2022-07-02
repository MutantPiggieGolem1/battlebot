public class Tile {
  protected PImage img;
  protected Location location;
  private boolean collide;
  
  public Tile(Integer id, Location loc) {
        System.out.println("i harrrrtgase ye");

    this.location = loc;
    this.img = sprites[id];
    this.collide = false;
  }
  public Tile(Integer id, Location loc, boolean collides) {
        System.out.println("i hateeejjegase ye");

    this.location = loc;
    this.img = sprites[id];
    this.collide = collides;
  }
  protected Tile(){}
  
  public Location getLocation() {
    return this.location;
  }
  
  //checking if player is overlapping w the given tile
  public boolean checkCollisions(Location loc) {
    return this.collide && this.location.equals(loc);
  }
  
  //draw with scales
  void draw() {
    image(this.img, (float)this.location.loc.x, (float)this.location.loc.y, this.img.width, this.img.height);
  }
}

class Grass extends Tile {
  public Grass(Integer id, Location loc) {
    super(id,loc,false);
  }
  
  @Override
  public boolean checkCollisions(Location loc) {
    if (this.location.equals(loc)) startBattle(new Monster("AirA",0,0));
    return false;
  }
}

class Portal extends Tile {
  private Location location2;
  
  public Portal(String portalid) {
    JSONObject data = portalDatabase.get(portalid);
    JSONArray loc = data.getJSONArray("location");
    this.location = new Location(loc.getJSONObject(0));
    this.location2= new Location(loc.getJSONObject(1));
    this.img = sprites[data.getInt("sprite")];
  }
  
  @Override
  public boolean checkCollisions(Location loc) {
    if (this.location.equals(loc)) {
      player.teleport(this.location2);
    } else if (this.location2.equals(loc)) {
      player.teleport(this.location);
    }
    return false;
  }
  
  @Override
  public void draw() {
    if (maps.get(currentmap).equals(this.location.map)) {
      image(this.img, (float)this.location.loc.x , (float)this.location.loc.y , this.img.width, this.img.height);
    } else if (maps.get(currentmap).equals(this.location2.map)) {
      image(this.img, (float)this.location2.loc.x, (float)this.location2.loc.y, this.img.width, this.img.height);
    }
  }
}
