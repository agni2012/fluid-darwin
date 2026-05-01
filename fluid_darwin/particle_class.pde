class Particle {
  float x, y, xv, yv;
  int type;
  Particle(float x, float y, float xv, float yv, int type) {
    this.x = x;
    this.y = y;
    this.xv=xv;
    this.yv=yv;
    this.type = type;
  }

  void draw() {
    fill(getParticleColor(this.type));
    noStroke();
    ellipse(this.x, this.y, 10, 10);
    noFill();
    stroke(0);
    //ellipse(this.x, this.y, 17*4, 17*4);
  }
  float calculateForce(float dist, float coefficient, float falloff){
    if (dist <= 0.0001) {
      dist = 0.0001; // prevent division by zero
    }
    return coefficient / pow(dist, falloff);
  }
  

  void getAffectedBy(Particle particle, float dx, float dy) {
    float repulsion = getParticleProperty(this.type, particle.type, REPULSIONS);
    float collision = getParticleProperty(this.type, particle.type, COLLISIONS);
    float falloff = getParticleProperty(this.type, particle.type, FALLOFF);
    
    float angle = atan2(dy, dx);
    float dist = dist(0,0,dx,dy);
    float f;
    if(dist>cellSize) return;
    else if(dist > 10){
      f = calculateForce(dist, repulsion, falloff);
    }else{
      f = collision * constrain(0.5/dist, 0, 5);
    }
    this.xv += cos(angle) * f;
    this.yv += sin(angle) * f;
    if(dist < 15){
       float xvd = particle.xv - this.xv;
       float yvd = particle.yv - this.yv;
       this.xv += xvd * 0.01;
       this.yv += yvd * 0.01;
     }
     stroke(0, 10);
     line(this.x, this.y, this.x - dx, this.y - dy);
     //cust:
     //switch(this.type){
     //  case TMB1:
     //  case MB1:
     //    if(particle.type == MB2 || particle.type == TMB2){
     //      if(dist > 15){
     //        float xvd = particle.xv - this.xv;
     //        float yvd = particle.yv - this.yv;
     //        this.xv += xvd * 0.2;
     //        this.yv += yvd * 0.2;
     //      }
     //    }
     //    break;
     //  case MB2:
     //    if(particle.type == MB1 || particle.type == TMB2){
     //      if(dist > 15){
     //        float xvd = particle.xv - this.xv;
     //        float yvd = particle.yv - this.yv;
     //        this.xv += xvd * 0.2;
     //        this.yv += yvd * 0.2;
     //      }
     //    }
     //    break;
     //  default:
     //  break;
     //}
  }
  void horizontalLooparound(){
    
    this.x = mod(this.x, screenSize);
    //this.xv*=-1;
  }
  void verticalLooparound(){
    this.y = mod(this.y, screenSize);
    //this.yv*=-1;
  }
  void update(){
    this.x += this.xv;
    this.y += this.yv;
    this.xv *= drag;
    this.yv *= drag;
    this.xv = constrain(this.xv, -10, 10);
    this.yv = constrain(this.yv, -10, 10);
    if(this.x > 100 && this.x < 300){
      this.yv += cos(frameCount/200)/500;
      this.yv *= 0.99;
    }
  }
}
