interface CallBack {
  //just an interface with a function; it works for some reason
    public void callback();
}

class Button {
  //variables :>
  String txt;
  float x;
  float y;
  float h;
  float w;
  String state;
  String func;
  Menu mymenu;
  //function-storing variable
  CallBack f;
  
  //menu button
  public Button(Menu m, float x, float y, float h, float w, String f) { //this, this.x + 50, tempy, buttonh, buttonw, "0"
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.mymenu = m;
    this.func = f;
  }
  
  //sandwich
  public Button(float x, float y, String f) {
    this.x = x;
    this.y = y;
    this.h = 5;
    this.w = 30;
    this.func = f;
  }
  
  void draw() {
    fill(255, 255, 255);
    rect(this.x, this.y, this.w, this.h);
    fill(0, 0, 0);

    if (this.txt != null) {
      text(this.txt, this.x + mymenu.buttonw/4, this.y + mymenu.buttonh/2);
    }
    fill(256, 256, 256);

  }
  
  void drawSandwich() {
    rect(this.x, this.y, this.w, this.h);
    rect(this.x, this.y + (this.h * 2), this.w, this.h);
    rect(this.x, this.y + (this.h * 4), this.w, this.h);
  }
  
  void update(){
    
  }
  
  //sets whatever function is loaded into the parameter into a variable
  public void setOnClick(CallBack function){
    this.f = function;
  }
  
  //use whatever function is stored in the f variable
  public void onClick(){
    if (this.func == "useitem"){
      if (Integer.parseInt(this.txt.split("x")[1].trim()) > 0){
        testPlayer.useItem(this.txt.split("x")[0].trim());
        ButtonFunction.runFunction("return");
      }
    }else{
      ButtonFunction.runFunction(this.func);
    }
  }
}
