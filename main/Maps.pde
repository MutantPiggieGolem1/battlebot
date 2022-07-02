class Maps {
  public String id;
  
  private HashMap<LayerType,Layer> layers = new HashMap<LayerType,Layer>();

  public Maps nextmap = null;
  
  public Maps(String id) {
        System.out.println("i hatadfagase ye");

    this.id = id;
    for (LayerType lt : LayerType.values()) {
      layers.put(lt,getLayer(lt,this));
    }
    maps.put(this.id,this);
  }
  
  public Dimension getTileSize() {
    return new Dimension(16,16);
  }
  
  public int[][] getLayerData(LayerType t) {
    JSONArray ljson = mapsDatabase.get(id).getJSONObject("layers").getJSONArray(t.toString());
    if (ljson != null) return convert2dArray(ljson);
    return null;
  }
  
  public boolean checkCollisions(Location pt) {
    nextmap = null;
    for (Layer l : this.layers.values()) {
      if (l.checkCollisions(pt)) return true;
    }
    return false;
  }
  
  public void draw() {
    for (Layer l : this.layers.values()) {
      l.draw();
    }
  }
}
