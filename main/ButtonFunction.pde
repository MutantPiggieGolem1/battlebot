public static class ButtonFunction {
  
  public ButtonFunction() {
    
  }
  
  public static void switchState(GameStates s) {
    GameState.currentState = s;
  }
  public static void switchCombatState(CombatStates s) {
    GameState.combatState = s;
  }
  
  public static void runFunction(String num) {
    //filler func
    if (num == "0") {
      println("this button has been clicked " + GameState.currentState);
    //swap to various states
    } else if (num == "menu") {
      switchState(GameStates.MENU);
    } else if (num == "walk") {
      switchState(GameStates.WALKING);
    //toggle between walking + menu
    } else if (num == "toggle") {
      if (GameState.currentState == GameStates.WALKING) {
        switchState(GameStates.MENU);
      } else if (GameState.currentState == GameStates.MENU) {
        switchState(GameStates.WALKING);
      }
    //swap to various combat states
    } else if (num == "fight") {
      switchCombatState(CombatStates.FIGHT);
<<<<<<< HEAD
    } else if (num == "items") {
=======
    } else if (num == "itemm") {
>>>>>>> deb2afae447bcd71ed55aa6207faca7884157e4f
      switchCombatState(CombatStates.ITEM);
    } else if (num == "battlebots") {
      switchCombatState(CombatStates.BATTLEBOT);
    } else if (num == "run") {
      switchCombatState(CombatStates.RUN);
    //ATTACKING MOVE
    } else if (num == "callmove0") {
      //get a Move and a self monster
      Moves current = activeMonster.move1;
      Monster mon = activeMonster;
      moveNum = 1;
      //play animation, alter stats
      current.useAttackMove(mon);
      mon.moveToEnemyStart(testMonster);
<<<<<<< HEAD
      //at the end, switch battlestate to animation
=======
      //at the end, switch battlestate to AI
>>>>>>> deb2afae447bcd71ed55aa6207faca7884157e4f
      switchCombatState(CombatStates.ANIMATION);
    //DEFENSIVE MOVE
    } else if (num == "callmove1") {
<<<<<<< HEAD
      //get a Move and a self monster
      Moves current = activeMonster.move2;
=======

      Moves current = activeMonster.move2;

>>>>>>> deb2afae447bcd71ed55aa6207faca7884157e4f
      Monster mon = activeMonster;
      moveNum = 2;

      //
      mon.defendStart();
      switchCombatState(CombatStates.ANIMATION);
    } else if (num == "callmove2") {
      Moves current = activeMonster.move3;
      Monster mon = activeMonster;
      moveNum = 3;
      //
      mon.healStart();
      switchCombatState(CombatStates.ANIMATION);
    } else if (num == "callmove3") {
      Moves current = activeMonster.move4;
      Monster mon = activeMonster;
      moveNum = 4;
      //

      mon.dodgeStart();
      switchCombatState(CombatStates.ANIMATION);
    } else if (num == "useitem") {
      JSONObject stats = testPlayer.useItem("id"); //oh no <error here>
      activeMonster.attack *= stats.getInt("attack");
      activeMonster.defense *= stats.getInt("defense");
      activeMonster.speed *= stats.getInt("speed");
      activeMonster.addHp(stats.getInt("health"));

    }
  }
  public static void useItem(String id){
    switchCombatState(CombatStates.ITEM);
    JSONObject stats = testPlayer.useItem(id);
    activeMonster.attack *= stats.getInt("attack");
    activeMonster.defense *= stats.getInt("defense");
    activeMonster.speed *= stats.getInt("speed");
    activeMonster.addHp(stats.getInt("health"));
  }
}
