public enum GameStates{
  WALKING,
  COMBAT,
  MENU,
  LOSE
}

public static class GameState{
  public static GameStates currentState = GameStates.WALKING;
}
