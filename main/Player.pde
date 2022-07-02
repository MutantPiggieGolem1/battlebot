//helper function that will generate the character sprites for NPC and player
public PImage[] createCharacterSprites(int playerNum){
  int i = 0;
  PImage[] characterSprites = new PImage[12];
  //locate which row in the tilelayerguide the player starts at
  int row = 0 + playerNum*3;
  //locate which tile num col in the tilelayerguide the player starts at
  int tilenum = (27*(row+1))-4;
  //for loop that will go through each column
  for(int c = tilenum; c<tilenum+4; c++){
    for(int r = 0; r< 3;r++){
      characterSprites[i] = sprites[c + (r*27)];
      i++;
    }
  }
  return characterSprites;
}

import java.awt.Dimension;

enum PlayerMovementStates{
  UP,
  DOWN,
  LEFT,
  RIGHT,
  SUDDENSTOP,
  STATIC,
  MOVEUP,
  MOVEDOWN,
  MOVELEFT,
  MOVERIGHT
}

//player class
class Player extends Character {
  private PlayerMovementStates direction = PlayerMovementStates.RIGHT;
  private Location location = new Location(400,400);
  private final Dimension dim = new Dimension(16,16);

  private PImage[] sprites; //character sprites
  private Spritesheet animations;

  private HashMap<String,Integer> inventory = new HashMap<String,Integer>();
  private ArrayList<Monster> monsters = new ArrayList<Monster>();
  private int selectedmonster;
  
  public Player() {
    this(createCharacterSprites(0),new ArrayList<Monster>());
  }
  public Player(PImage[] sprites,ArrayList<Monster> mnstrs){
        System.out.println("i hatGNAANGiohGRgase ye");

    this.monsters = (ArrayList)mnstrs.clone();
    this.selectedmonster = 0;
    this.sprites = sprites;
    animations = new Spritesheet(this.sprites, 120);
    animations.setxywh(this.location.loc.x, this.location.loc.y, dim.width, dim.height);
    animations.createAnimation("walkLeft", new int[]{0,1,2});
    animations.createAnimation("walkDown", new int[]{3,4,5});
    animations.createAnimation("walkUp", new int[]{6,7,8});
    animations.createAnimation("walkRight", new int[]{9,10,11});
    animations.createAnimation("lookLeft", new int[]{0});
    animations.createAnimation("lookDown", new int[]{3});
    animations.createAnimation("lookUp", new int[]{6});
    animations.createAnimation("lookRight", new int[]{9});
  }

  public void addItem(String id){
    Integer a = inventory.get(id);
    inventory.put(id, a == null ? 1 : a+1);
  }
  public void useItem(String id){
    Integer a = inventory.get(id);
    if (a != null && a > 0){
      if (a-1 == 0){
        inventory.remove(id);
      }else{
        inventory.put(id, a-1); // "healthPotion": 0
      }
      HashMap<Stat,Float> stats = itemDatabase.get(id);
      this.getSelectedMonster().modStats(stats);
    }else{
      throw new Error("You insolent fool, thou hast disturbed the balance of the universe. (["+id+"] was not in the database.)");
    }
  }
  
  public void summonMonsterStack(String[] idarray) {
    for (int i = 0; i < idarray.length; i++) {
      addMonster(new Monster(idarray[i],400,400));
    }
  }
  
  public Location getLocation() {
    return this.location;
  }
  
  public void addMonster(Monster m) {
      monsters.add(m);
  }
  
  public Monster getSelectedMonster() {
    return this.monsters.get(this.selectedmonster);
  }
  
  private void update() {
    if(!keyPressed) return;
    switch (key) {
      case 'w':
        this.direction= PlayerMovementStates.MOVEUP;
      break;
      case 's':
        this.direction= PlayerMovementStates.MOVEDOWN;
      break;
      case 'a':
        this.direction= PlayerMovementStates.MOVELEFT;
      break;
      case 'd':
        this.direction= PlayerMovementStates.MOVERIGHT;
      break;
    }
  }
  
  public void display(){
    
    //if(animations.stoploop){
    //  animations.softReset();
    //  //keyTimer.refresh();
    //  direction = PlayerMovementStates.STATIC;
    //}
    
    switch(direction){
      case MOVEUP:
        move(Direction.UP);
      break;
      case MOVEDOWN:
        move(Direction.DOWN);
      break;
      case MOVELEFT:
        move(Direction.LEFT);
      break;
      case MOVERIGHT:
        move(Direction.RIGHT);
      break;
      case UP:
        animations.play("lookUp");
      break;
      case DOWN:
        animations.play("lookDown");
      break;
      case LEFT:
        animations.play("lookLeft");
      break;
      case RIGHT:
        animations.play("lookRight");
      break;
      default:
        //if(animations.animationTimer.countDownOnce()){
        //  animations.increment = animations.loopstart;
        //}
        //animations.display(400,400);
        break;
    }
  }
  
  void move(Direction dir){
    Location goal = new Location(this.location);
    switch (dir) {
      case UP:
        goal.translate(0,4);
        animations.play("walkUp");
        if(animations.finished("walkUp")){
          direction = PlayerMovementStates.UP;
        }
      break;
      case DOWN:
        goal.translate(0,-4);
        animations.play("walkDown");
        if(animations.finished("walkDown")){
          direction = PlayerMovementStates.DOWN;
        }
      break;
      case LEFT:
        goal.translate(4,0);
        animations.play("walkLeft");
        if(animations.finished("walkLeft")){
          direction = PlayerMovementStates.LEFT;
        }
      break;
      case RIGHT:
        goal.translate(-4,0);
        animations.play("walkRight");
        if(animations.finished("walkRight")){
          direction = PlayerMovementStates.RIGHT;
        }
      break;
      case NONE:
      default:
      
    } 
    if (!maps.get(currentmap).checkCollisions(goal)) this.location = goal;
  }
  
  public void teleport(Location l) {
    this.location = new Location(l);
  }
}
  
