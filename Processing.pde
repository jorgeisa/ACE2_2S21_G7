

Particle[] particles;
float alpha;

void setup() {
  size(640, 640);
  background(0);
  noStroke();
  setParticles();
}

void draw() {
  frameRate(200);
  alpha = map(mouseX, 0, width, 5, 35);
  fill(0, alpha);
  rect(0, 0, width, height);

  loadPixels();
  for (Particle p : particles) {
    p.move();
  }
  updatePixels();
}
float tx;
void setParticles() {
  particles = new Particle[200];
  for (int i = 0; i < 200; i++) { 
    float x = random(width);
    float y = random(height);
    int c;
    if (tx>PI) {
      c = randColor();
    } else {
      c = blueColor();
    }
    particles[i]= new Particle(x, y, c);
  }
}

color randColor() {
  return color(random(0, 256), random(0, 256), random(0, 256));
}
color blueColor() {
  return color(random(7, 17), random(9, 128), random(61, 202));
}
void repaint() {
  color colorNew = blueColor();
  for (int i = 0; i < 200; i++) { 
    particles[i].c=colorNew;
  }
}
void mousePressed() {
  tx=random(0, 2*PI);
  repaint();  
  setParticles();
}

class Particle {
  float posX, posY, incr, theta;
  color  c;

  Particle(float xIn, float yIn, color cIn) {
    posX = xIn;
    posY = yIn;
    c = cIn;
  }

  public void move() {
    update();
    wrap();
    display();
  }

  void update() {
    incr +=  .005;
    theta = noise(posX * .006, posY * .004, tx) * TWO_PI;
    posX += 2 * sin(tx);
    posY += 2 * cos(tx);
  }

  void display() {
    if (posX > 0 && posX < width && posY > 0  && posY < height) {
      pixels[(int)posX + (int)posY * width] =  c;
    }
  }

  void wrap() {
    if (posX < 0) posX = width;
    if (posX > width ) posX =  0;
    if (posY < 0 ) posY = height;
    if (posY > height) posY =  0;
  }
}
