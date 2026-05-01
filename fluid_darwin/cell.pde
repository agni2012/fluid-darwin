 class Cell {
  int i, j, posX, posY;
  public ArrayList<Particle> particles = new ArrayList<Particle>();

  Cell(int i, int j) {
    this.i = i;
    this.j = j;
    this.posX = int(i * cellSize);
    this.posY = int(j * cellSize);
    for (int ind = 1; ind < random(1); ind++) {
      float particleX = random(posX, posX + cellSize);
      float particleY = random(posY, posY + cellSize);
      
      particles.add(new Particle(particleX, particleY,0, 0, (int) random(1,3)));
    }
  }
  private ArrayList<Particle> getAllAdjacentParticles(/*Cell[][] cells*/) {
    /*int[][] adjacentCoords = {
      {-1, -1}, // top-left
      { 0, -1}, // top
      { 1, -1}, // top-right
      {-1, 0}, // left
      { 0, 0}, // self (optional)
      { 1, 0}, // right
      {-1, 1}, // bottom-left
      { 0, 1}, // bottom
      { 1, 1}  // bottom-right
    };*/
    int[][] adjacentCoords = {
        {-2,-2},{-1,-2},{0,-2},{1,-2},{2,-2},
        {-2,-1},{-1,-1},{0,-1},{1,-1},{2,-1},
        {-2, 0},{-1, 0},{0, 0},{1, 0},{2, 0},
        {-2, 1},{-1, 1},{0, 1},{1, 1},{2, 1},
        {-2, 2},{-1, 2},{0, 2},{1, 2},{2, 2}
    };


    ArrayList<Particle> allAdjacentParticles = new ArrayList();

    for (int ind = 0; ind < 25; ind++) {
      int newI = (this.i + adjacentCoords[ind][0] + cellDim) % cellDim;
      int newJ = (this.j + adjacentCoords[ind][1] + cellDim) % cellDim;
      Cell adjacentCell = cells[newI][newJ];
      allAdjacentParticles.addAll(adjacentCell.particles);
    }
    return allAdjacentParticles;
  }
  public void add(Particle p){
    particles.add(p);
  }

  public void doAllForces() {
    ArrayList<Particle> adjacentParticles = getAllAdjacentParticles();
    for(Particle p1 : this.particles){
      for(Particle p2: adjacentParticles){
        if(p1 != p2){
          float dx = p1.x - p2.x;
          dx -= screenSize * Math.round(dx / screenSize);
          
          float dy = p1.y - p2.y;
          dy -= screenSize * Math.round(dy / screenSize);
          p1.getAffectedBy(p2, dx, dy);
        }
      }

    }
  }
  //Delete (if any) particles from the cell which are near the mouse.
  //Note: This does not check adjacent porticles which may overlap into the cell.
  public void checkDel(){
    for(int i = 0; i < this.particles.size(); i++){
      if(dist(mouseX,//dist func is so good, but dvorak kl is better
        mouseY,//also i never read java style handbook so idk how to format this ssupa long if statament.
        this.particles.get(i).x,
        this.particles.get(i).y) < 20) {
        
      }
    }
  }
  public void update(){
    for(int i = 0; i < this.particles.size(); i++){
      Particle p = this.particles.get(i);
      p.update();
      if(!checkIfInBoundry(p)){
        
        if(p.x < 0 || p.x > screenSize) p.horizontalLooparound();
        if(p.y < 0 || p.y > screenSize) p.verticalLooparound();
        
        int newCellX = mod((int) (p.x / cellSize), cellDim);
        int newCellY = mod((int) (p.y / cellSize), cellDim);
        this.particles.remove(i);
        i--; 
        cells[newCellX][newCellY].add(p);
        
      }
    }
  }
  public boolean checkIfInBoundry(Particle particle){
    
    if(particle.x < this.posX || particle.y < this.posY) return false;
    if(particle.x > this.posX + cellSize || particle.y > this.posY + cellSize) return false;
    return true;
    
  }
  public void draw() {
    noFill();stroke(0, 100);
    rect(this.posX, this.posY, cellSize, cellSize);
    for (Particle p : particles) {
        p.draw();
    }

  }
}
