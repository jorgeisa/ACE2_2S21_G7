

Particle[] particles;
//Variables del Arduino
int speed=0;            //0 - 18
float direction;      //0 - 2PI
float hum;            //0 - 100
float temp;           //16 - 40
float alpha;
float[] dirs = {0, 90, 180, 270};


void setVars() {
  speed = (int)random(0, 18);  
  hum = (int)random(0, 100);
  temp = (int)random(16, 40);
  direction=dirs[(int)random(0, 4)];
}

void setup() {
  size(640, 640);
  background(0);
  noStroke();
  setVars();
  setParticles();
}

void drawSpeed() {
  if (speed > 0) {
    frameRate(speed*4);
  } else {
    frameRate(20);
  }
  println("velocidad:"+speed);
}
String dirText="Sin datos";
void drawDirection() {
  if (direction == 0) {
    direction=PI/2;
    dirText="Este";
  } else if (direction == 90) {
    direction=PI;
    dirText="Norte";
  } else if (direction == 180) {
    direction=3*PI/2;    
    dirText="Oeste";
  } else if (direction == 270) {
    direction=0;
    dirText="Sur";
  }
  println("Direccion:"+direction);
  println();
  println();
  println();
}
void drawHumidity() {
  alpha = map(hum, 0, 100, 20, 80);
  fill(0, alpha);
  rect(0, 0, width, height);
  println("Humedad:"+hum);
}

void drawTemp() {
  if (temp <24) {
    for (int i = 0; i < 400; i++) { 
      particles[i].c=blueColor();
      textColor=color(0,0,255);
    }
  } else if (temp >=24 && temp <32) {
    for (int i = 0; i < 400; i++) { 
      particles[i].c=greenColor();
      textColor=color(0,255,0);
    }
  } else if (temp >=32) {
    for (int i = 0; i < 400; i++) { 
      particles[i].c=redColor();
      textColor=color(255,0,0);
    }
  }
  println("Temperatura:"+temp);
}
color textColor;


color blueColor() {
  return color(random(7, 17), random(9, 20), random(61, 202));
}
color redColor() {
  return color(random(102, 204), random(2, 56), random(0, 53));
}
color greenColor() {
  return color(random(0, 17), random(100, 224), 0);
}

void draw() {
  textSize(24);
  fill(red(textColor),green(textColor),blue(textColor));
  text("Temperatura:"+temp,   40, 40);
  text("Humedad:"+hum,        380, 40);
  text("Velocidad:"+speed,    380, 80);
  text("Direccion:"+dirText,  40, 80);
  drawSpeed();
  drawTemp();
  drawHumidity();
  drawDirection();
  loadPixels();
  for (Particle p : particles) {
    p.move();
  }

  updatePixels();
}


void setParticles() {
  particles = new Particle[400];
  for (int i = 0; i < 400; i++) { 
    float x = random(width);
    float y = random(height);
    int c;

    c = greenColor();
    particles[i]= new Particle(x, y, c);
  }
}





void mousePressed() {
  setup();
}

class Particle {
  float posX, posY, theta;
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
    posX += sin(direction);
    posY += cos(direction);
  }

  void display() {

    if (posX > 2 && posX < width && posY > 0  && posY < height-2) {

      pixels[(int)posX + (int)posY * width ] =  c;
      pixels[(int)posX-1 + (int)posY * width ] =  c;
      pixels[(int)posX-2 + (int)posY * width ] =  c;
      pixels[(int)posX + ((int)posY+1) * width ] =  c;
      pixels[(int)posX-1 + ((int)posY+1) * width ] =  c; 
      pixels[(int)posX-2 + ((int)posY+1) * width ] =  c;     
      pixels[(int)posX + ((int)posY+2) * width ] =  c;
      pixels[(int)posX-1 + ((int)posY+2) * width ] =  c; 
      pixels[(int)posX-2 + ((int)posY+2) * width ] =  c;  
    }
  }

  void wrap() {
    if (posX < 0) posX = width;
    if (posX > width ) posX =  0;
    if (posY < 0 ) posY = height;
    if (posY > height) posY =  0;
  }
}
