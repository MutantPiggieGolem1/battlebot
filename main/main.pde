import java.util.*;
import java.io.File;
import java.util.concurrent.TimeUnit;

public String RESOURCEPATH;
public static final int naptime = 200; //delayer var to avoid problems when keys are pressed
public static final int TILECOUNT = 487;
public static final HashMap<MonsterType,HashMap<MonsterType,Float>> efficencies = new HashMap<MonsterType,HashMap<MonsterType,Float>>();
public static final HashMap<Integer,Direction> keydirection = new HashMap<Integer,Direction>();
public static final HashMap<TileType,int[]> specialTiles = new HashMap<TileType,int[]>();
public static final int[] collidableTiles;
public static HashMap<String,Maps> maps = new HashMap<String,Maps>();
public static Battle currentbattle;
public static String currentmap;
public Player player;
static {
  for (MonsterType t : MonsterType.values()) {
    efficencies.put(t,new HashMap<MonsterType,Float>());
  }
  efficencies.get(MonsterType.FIRE).put(MonsterType.WATER, 0.5);
  efficencies.get(MonsterType.AIR).put(MonsterType.EARTH, 0.5);
  efficencies.get(MonsterType.WATER).put(MonsterType.FIRE, 1.5);
  efficencies.get(MonsterType.EARTH).put(MonsterType.AIR, 1.5);
  
  for (HashMap<MonsterType,Float> i : efficencies.values()) {
    for (MonsterType t : MonsterType.values()) {
      if (!i.containsKey(t)) i.put(t,1.0);
    }
  }
  
  keydirection.put(87,Direction.UP);
  keydirection.put(83,Direction.DOWN);
  keydirection.put(65,Direction.LEFT);
  keydirection.put(68,Direction.RIGHT);
  
  collidableTiles = new int[]{170,171,172,189,190,191,192,193,194,195,196,197,198,199,216,217,218,219,220,221,222,223,224,225,226,237,238,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,270,271,272,273,274,275,276,278,279,280,286,287,288,289,290,291,292,297,298,299,300,301,302,303,304,305,306,307,327,328,329,330,331,332,333,334,335,336,337,338,340,341,342,344,345,346,354,355,356,357,358,359,360,361,362,363,364,365,367,368,369,370,371,372,373,381,382,383,384,385,386,387,388,389,390,391,392,414,415,416,417,418,419,420,421,422,423,424,425,426,427,443,444,445,446,453,454,470,471,472,473,474,475,476,477,478,479,480,481};
  specialTiles.put(TileType.PORTAL, new int[]{281,282,283,284,285,339,412,413});
  specialTiles.put(TileType.ENEMY, new int[]{0,1,2,3,4,5,6,7,27,28,29,30,31,32,33,34,54,55,56,57,58,59,60,61});
  System.out.println("i hate ye");
}
//hashmaps for each json file
public HashMap<String, JSONObject> monsterDatabase=new HashMap<String, JSONObject>();
public HashMap<String, JSONObject> moveDatabase   =new HashMap<String, JSONObject>();
public HashMap<String, HashMap<Stat,Float>> itemDatabase = new HashMap<String, HashMap<Stat,Float>>();
public HashMap<String, JSONObject> mapsDatabase   =new HashMap<String, JSONObject>();
public HashMap<String, JSONObject> portalDatabase =new HashMap<String, JSONObject>();

//sprite stuff
public HashMap<String,PImage> monstersprites = new HashMap<String,PImage>(); // sprites hashmap
public HashMap<String,PImage> itemsprites = new HashMap<String,PImage>();

//gameplay vars
Menu mainmenu;
Button sandwich;


Timer restartTimer;

void setup(){
  System.out.println("i hate yepD");

  RESOURCEPATH = sketchPath()+File.separator+"data";
  //load in sprites
  //after loading each image from the monster folder place it into a hashmap containing name of monster and image
  for (File sfile : new File(RESOURCEPATH + File.separator + "monsters").listFiles()){
    if (sfile.getName().contains(".json")) continue;
    monstersprites.put(sfile.getName().replace(".png",""), loadImage(sfile.getAbsolutePath()));
  }
  for (File sfile : new File(RESOURCEPATH + File.separator + "items").listFiles()) {
    if (sfile.getName().contains(".json")) continue;
    itemsprites.put(sfile.getName().replace(".png",""), loadImage(sfile.getAbsolutePath()));
  }
  
  
  //load the moves.json file
  JSONArray moveArray = loadJSONArray("data/moves.json");
  for(int i=0; i<moveArray.size();i++){
    JSONObject move = moveArray.getJSONObject(i);
    moveDatabase.put(move.getString("name"),move);
  }
  //load the monsters.json file
  JSONArray monsterArray = loadJSONArray("data/monsters/monsters.json");
  for(int i=0; i<monsterArray.size();i++){
    JSONObject monster = monsterArray.getJSONObject(i);
    monsterDatabase.put(monster.getString("name"),monster);
  }
  //load the items.json file
  JSONArray itemArray = loadJSONArray("data/items/items.json");
  for (int i=0; i<itemArray.size();i++){
    JSONObject jitem = itemArray.getJSONObject(i);
    HashMap<Stat,Float> hitem = new HashMap<Stat,Float>();
    for (Stat stat : Stat.values()) {
      String sstat = stat.name().toLowerCase();
      if (!jitem.isNull(sstat)) {
        hitem.put(stat,jitem.getFloat(sstat));
      }
    }
    itemDatabase.put(jitem.getString("name"),hitem);
  }
  
  //load the maps.json file
  JSONObject mapjson = loadJSONObject("data/maps.json");
  JSONObject mapdata = mapjson.getJSONObject("maps");
  for (Object mkey : mapdata.keys()) {
    String mapid = mkey.toString();
    mapsDatabase.put(mapid,mapdata.getJSONObject(mapid));
  }
  JSONObject portaldata = mapjson.getJSONObject("portals");
  for (Object pkey : portaldata.keys()) {
    String portalid = pkey.toString();
    portalDatabase.put(portalid,portaldata.getJSONObject(portalid));
  }

  //initiatize misc variables
  player = new Player();

  String[] monsterids = new String[]{"AirA", "Goku", "ChickenA", "KlackonA"};
  player.summonMonsterStack(monsterids);
  player.addItem("Health Potion");

  //initialize the maps
  maps.put("citymap",new Maps("citymap"));
  maps.put("fieldmap",new Maps("fieldmap"));
  maps.put("jailmap",new Maps("jailmap"));
  
  //sets the active map as field to start
  currentmap = "fieldmap";
  
  //initialize menus
  mainmenu = new Menu(0, 0, 4, 30, 80, 5);

  sandwich = new Button(10, 10, "toggle");
  //values for main menu
  mainmenu = new Menu(0, 0, 4, 30, 80, 5);
  mainmenu.buttons.get(0).txt = "button1";
  mainmenu.buttons.get(1).txt = "button2";
  mainmenu.buttons.get(2).txt = "button3";
  
  //size of game window:
  fullScreen();
}

void draw() {
  background(0);
  update(); // TODO: Seperate this
  switch (GameState.currentState) {
    case WALKING:
      player.display();
      updateDrawables(sandwich);
    break;
    case COMBAT:
      currentbattle.render();
    break;
    case MENU:
      //draw stuff (not update; no movement)
      // TODO: map render!!
      updateDrawables(sandwich);
      updateDrawables(mainmenu);
    break;
    case LOSE:
    break;
  }
}
void update() {
  switch (GameState.currentState) {
    case WALKING:
      player.update();
      updateClickables(sandwich);
      
      //for (GroundItem gi : dqueue) {
      //  currentmap.removeItem(gi);
      //}
      //keypress to go into menu - backup if button breaks
      if (keyPressed && key == 'm') {
        GameState.currentState = GameStates.MENU;
        delay(naptime);
      }
    break;
     case MENU:
      //updating the menu
      updateClickables(sandwich);
      updateClickables(mainmenu);
      //for button clicks
      //keypress to go into walking - backup if button breaks
      if (keyPressed && key == 'm') {
        GameState.currentState = GameStates.WALKING;
        delay(naptime);
      }
    break;
    case COMBAT:
      currentbattle.update();
    break;
    case LOSE:
      System.out.println("skill issue");
      System.exit(0);
    break;
  }
}

public JSONObject JSONCopy(JSONObject original){
  JSONObject duplicate = new JSONObject();
  String[] keys = new String[original.keys().size()];
  Object[] temp = original.keys().toArray();
  for(int i=0; i<keys.length; i++){
    keys[i] = temp[i].toString();
  }
  
  for(String keyi : keys){
    if(original.get(keyi) instanceof Boolean){
      duplicate.setBoolean(keyi, original.getBoolean(keyi));
    }else if(original.get(keyi) instanceof String){
      duplicate.setString(keyi, original.getString(keyi));
    }else if(original.get(keyi) instanceof Integer){
      duplicate.setInt(keyi, original.getInt(keyi));
    }else if(original.get(keyi) instanceof Float){
      duplicate.setFloat(keyi, original.getFloat(keyi));
    }else if(original.get(keyi) instanceof Double){
      duplicate.setDouble(keyi, original.getDouble(keyi));
    }else if(original.get(keyi) instanceof JSONObject){
      duplicate.setJSONObject(keyi, original.getJSONObject(keyi));
    }else if(original.get(keyi) instanceof JSONArray){
      duplicate.setJSONArray(keyi, original.getJSONArray(keyi));
    }else{
      warn("Did not copy key '"+original.get(keyi).getClass()+"' because it did not match type! Class: "+keyi+"\n"+original.get(keyi));
    }
  }
  return duplicate;
}

interface Clickable { // all clickable features should have this interface
  abstract void onClick();          // what happens opon being clicked
  abstract boolean isClickable();   // can this item be clicked at this time
  abstract float[] getDimensions(); // [x,y,w,h]
}
void updateClickables(ArrayList<Clickable> clickables){
  if (!mousePressed) return;
  for (Clickable clickable : clickables){
    updateClickables(clickable);
  }
}
void updateClickables(Clickable clickable) {
  if (!mousePressed) return;
  float[] dims = clickable.getDimensions();
  if (clickable.isClickable() && (mouseX >= dims[0] && mouseX <= dims[0]+dims[2]) && (mouseY >= dims[1] && mouseY <= dims[1]+dims[3])) {
    clickable.onClick();
    delay(naptime);
  }
}

interface Drawable {
  abstract void draw(); // draw this feature
}
void updateDrawables(ArrayList<Drawable> drawables){
  for (Drawable drawable : drawables){
    updateDrawables(drawable);
  }
}
void updateDrawables(Drawable drawable){
  drawable.draw();
}
void warn(String message) {
  println("!WARNING! "+message);
}

//given a 2d JSONArray, copy contents and return as a 2d intarray
int[][] convert2dArray(JSONArray ogarr) {
  //int[size of outer JSONArray][size of first JSONArray within the outer JSONArray]
  int[][] arr = new int[ogarr.size()][ogarr.getJSONArray(0).size()];
  //for each JSONArray within the original JSONArray
  for (int i = 0; i < ogarr.size(); i++) {
    //create a dummy int[] identical to an int-only version of the current JSONArray within the outer JSONArray (ogarr)
    int[]  dummy = ogarr.getJSONArray(i).getIntArray();
    //set the current row to be equal to the current dummy array
    for (int k = 0; k < dummy.length; k++) {
      arr[i][k] = dummy[k];
    }
  }
  return arr;
}

import java.awt.Point;
public class Location {
  public final Maps map;
  public final Point loc;
    
  public Location(Location l) {
    this.map = l.map;
    this.loc = l.loc;
  }
  
  public Location(Maps m, Point p) {
    this.map = m;
    this.loc = p;
  }
  
  public Location(JSONObject jo) {
    this.map = maps.get(jo.getString("map"));
    JSONArray location = jo.getJSONArray("location");
    this.loc = new Point(location.getInt(0),location.getInt(1));
  }
  
  public Location(Maps m, int x, int y) {
    this.map = m;
    this.loc = new Point(x,y);
  }
  
  public Location(int x, int y) {
    this.map = null;
    this.loc = new Point(x,y);
  }
  
  public void translate(int dx,int dy) {
    this.loc.translate(dx,dy);
  }
  
  @Override
  public boolean equals(Object l) {
    return ( this.map == null || this.map.equals(l) ) && this.loc.equals(l);
  }
  
  public boolean isAt(Point p) {
    return this.loc.equals(p);
  }
}

enum TileType {
  DEFAULT, ENEMY, PORTAL
}

enum LayerType {
  BASE,     // Underlay, the base terrain
  OVERLAY,  // Overlay, fixes base terrain transparency
  INTERACT, // Handles all interactions, like portals & items
  COLLIDE,  // Handles all collisions, like walls & border
    // Player renders here
  TOP       // Toplayer, draws what renders above the player
}

enum Direction {
  UP, DOWN, LEFT, RIGHT, NONE
}

enum MonsterType {
  WATER, EARTH, FIRE, AIR
}

enum Stat {
  ATTACK,
	DEFENSE,
	MAXHEALTH, // a.k.a. health
	SPEED,
	AGILITY,

  ACCURACY
}

enum MoveType {
  ATTACK,
  DEFEND,
  HEAL,
  DODGE
}
