void toggleSimulation () {
  hasSimStarted = !hasSimStarted;
  println("TS");
}
void createUI() {
  // Simulation Controls
  cp5.addToggle("toggleSimulation")
    .setLabel("Start/Stop Simulation")
    .setPosition(screenSize + 10, 20)
    .setSize(panelWidth - 20, 30) //idk why cant do setValue
    .getCaptionLabel()
    .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.addToggle("transparent")
    .setLabel("Toggle Transparency")
    .setPosition(screenSize + 10, 60)
    .setSize(panelWidth - 20, 30)
    .setValue(transparent)
    .getCaptionLabel()
    .align(ControlP5.CENTER, ControlP5.CENTER);

  // Particle Selection
  cp5.addLabel("particleTypeLabel")
    .setText("Select Particle Type:")
    .setPosition(screenSize + 10, 140)
    .setSize(panelWidth - 20, 20);

  cp5.addButton("selectC1")
    .setLabel("Select C1")
    .setPosition(screenSize + 10, 160)
    .setSize(panelWidth - 20, 30);

  cp5.addButton("selectC2")
    .setLabel("Select C2")
    .setPosition(screenSize + 10, 200)
    .setSize(panelWidth - 20, 30);

  cp5.addButton("selectE1")
    .setLabel("Select E1")
    .setPosition(screenSize + 10, 240)
    .setSize(panelWidth - 20, 30);
    
  cp5.addButton("selectE2")
    .setLabel("Select E2")
    .setPosition(screenSize + 10, 280)
    .setSize(panelWidth - 20, 30);
    
  cp5.addLabel("settings")
    .setText("Settings:")
    .setPosition(screenSize + 10, 400)
    .setSize(panelWidth - 20, 20);
    
  cp5.addButton("toggleIntenseDrag")
    .setLabel("Toggle Intense Drag")
    .setPosition(screenSize + 10, 420)
    .setSize(panelWidth - 20, 30);
}
void toggleIntenseDrag() {
  if (drag == 0.99) {
    drag = 1;
  } else {
    drag = 0.99;
  }
  println("Drag = " + drag);
}

int mod(int x, int m) {
  return ((x % m) + m) % m;
}

float mod(float x, int m) {
  return ((x % m) + m) % m;
}



// --- UI Creation Function ---

boolean shouldPlaceParticle() {
  if (mouseX > 512) return false;
  if (!mousePressed) return false;

  boolean tooClose = false;
  //Must sadly give credit to AI for holping me fix a bug here (i used it in different places tho)
  int cellX = ((int)(mouseX / cellSize))%cellDim;
  int cellY = ((int)(mouseY / cellSize))%cellDim;

  // check current cell and its neighbors
  for (int nx = max(0, cellX-1); nx <= min(cells.length-1, cellX+1); nx++) {
    for (int ny = max(0, cellY-1); ny <= min(cells[0].length-1, cellY+1); ny++) {
      for (Particle p : cells[nx][ny].particles) {  // adjust if different storage
        float dx = p.x - mouseX;
        float dy = p.y - mouseY;
        if (dx*dx + dy*dy < 100 && (isTransparent(p.type) == transparent)) {  // within 10 px
          tooClose = true;
          break;
        }
      }
      if (tooClose) break;
    }
    if (tooClose) break;
  }

  return !tooClose;
}


void selectWater() {
  selectedType = WATER;
  println("Selected: WATER");
}

void selectMB1() {
  //selectedType = MB1;
  println("Selected: MB1");
}

void selectMB2() {
  //selectedType = MB2;
  println("Selected: MB2");
}


// Button callbacks
void selectC1() {
  selectedType = C1;
  println("Selected: C1");
}

void selectC2() {
  selectedType = C2;
  println("Selected: C2");
}

void selectE1() {
  selectedType = E1;
  println("Selected: E1");
}

void selectE2() {
  selectedType = E2;
  println("Selected: E2");
}
