import java.util.stream.IntStream;


float drag = 1; //Coefficient of that thingy


import controlP5.*;

boolean hasSimStarted = false;
int screenSize = 512; //Change size() too
int cellDim = 16;

int selectedType = 3;
boolean transparent = false;


float cellSize = screenSize / cellDim;

import java.util.ArrayList;

ArrayList<Particle> allParticles = new ArrayList<Particle>();

Cell[][] cells = new Cell[cellDim][cellDim];


ControlP5 cp5;
int panelWidth = 200;


void setup() {
  cp5 = new ControlP5(this);
  size(712, 512);
  particleTypesSetup();
  for (int i = 0; i < cellDim; i++) {
    for (int j = 0; j < cellDim; j++) {
      cells[i][j] = new Cell(i, j);
    }
  }
  frameRate(1200);
  createUI();
  selectedType = E1;
  
  startingPattern();
}

void draw() {
  frameRate(keyCode == 83?1:10000);
  background(100, 100);
  fill(67, 67, 67); //i solomly wear this was not on purpouse only after i typed it in i realised...
  rect(100, 0, 200, 512);
  for (int i = 0; i < cellDim; i++) {
    for (int j = 0; j < cellDim; j++) {

      cells[i][j].draw();
    }
  }
  if (hasSimStarted) {

    //for (int i = 0; i < cellDim; i++) {
    //  for (int j = 0; j < cellDim; j++) {

    //    cells[i][j].doAllForces();
    //  }
    //}
    
    // Parallel loop over rows
    IntStream.range(0, cellDim).parallel().forEach(i -> {
        for (int j = 0; j < cellDim; j++) {
            cells[i][j].doAllForces(); // physics only, safe to parallelize
        }
    });
    for (int i = 0; i < cellDim; i++) {
      for (int j = 0; j < cellDim; j++) {

        cells[i][j].update();
      }
    }

  }//else frameRate(12);



  fill(255);
  textSize(16);
  String status = hasSimStarted ? "Unpaused" : "Paused";
  text(status, 10, height - 10);
  
  // Draw the side panel background
  fill(50);
  noStroke();
  rect(screenSize, 0, panelWidth, 512);
  if(mousePressed) handleClick();
  
}

void handleClick(){
  int cellX = mod((int)(mouseX / cellSize), cellDim);
  int cellY = mod((int)(mouseY / cellSize), cellDim);
  if(mouseButton == LEFT){
    boolean isShiftPressed = (keyCode == 16 && keyPressed);
    if(isShiftPressed){
      cells[cellX][cellY].add(new Particle(mouseX+random(-10, 10), mouseY+random(-10, 10), 0, 0, selectedType));
    }else if(shouldPlaceParticle()){
      cells[cellX][cellY].add(new Particle(mouseX, mouseY, 0, 0, selectedType));
    }
  }else if(shouldPlaceParticle()){
    cells[cellX][cellY].checkDel();
  }
}


void keyPressed(){
  if(key == ' '){
    hasSimStarted =! hasSimStarted;
  }
}
