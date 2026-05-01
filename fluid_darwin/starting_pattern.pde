void startingPattern (){
  int n = 70;
  float b = 0.05;
  for(int j = 0; j < 7; j++){
    for(int i = 0; i < 7; i++){
      // random velocity for E1–C1–E1 group
      float vx1 = random(-b, b);
      float vy1 = random(-b, b);
      
      cells[0][0].add(new Particle(i*n+n/2, 10 + j*n, vx1, vy1, E1));
      cells[0][0].add(new Particle(i*n+n/2, 20 + j*n, vx1, vy1, C1));
      cells[0][0].add(new Particle(i*n+n/2, 30 + j*n, vx1, vy1, E1));
      
      // random velocity for E2–C2–E2 group
      float vx2 = random(-b, b);
      float vy2 = random(-b, b);
      
      cells[0][0].add(new Particle(i*n+n-10, 0 + j*n, vx2, vy2, E2));
      cells[0][0].add(new Particle(i*n+n, 0 + j*n, vx2, vy2, C2));
      cells[0][0].add(new Particle(i*n+n+10, 0 + j*n, vx2, vy2, E2));
    }
  }
}
