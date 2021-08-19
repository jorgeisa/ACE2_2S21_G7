

Particle[] particles;
//Variables del Arduino
String [] cadena = loadStrings("http//localhost:3000/");
json = parseJSONObject(cadena[0]);

int speed;            //0 - 18
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
    frameRate(50);
  }
  println("velocidad:"+speed);
}
void drawDirection() {
  if (direction == 0) {
    direction=PI/2;
  } else if (direction == 90) {
    direction=PI;
  } else if (direction == 180) {
    direction=3*PI/2;
  } else if (direction == 270) {
    direction=0;
  }
  println("Direccion:"+direction);
  println();
  println();
  println();
}
void drawHumidity() {
  alpha = map(hum, 0, 100, 5, 50);
  fill(0, alpha);
  rect(0, 0, width, height);
  println("Humedad:"+hum);
}

void drawTemp() {
  if (temp <24) {
    for (int i = 0; i < 300; i++) { 
      particles[i].c=blueColor();
    }
  } else if (temp >=24 && temp <32) {
    for (int i = 0; i < 300; i++) { 
      particles[i].c=greenColor();
    }
  } else if (temp >=32) {
    for (int i = 0; i < 300; i++) { 
      particles[i].c=redColor();
    }
  }
  println("Temperatura:"+temp);
}
color blueColor() {
  return color(random(7, 17), random(9, 128), random(61, 202));
}
color redColor() {
  return color(random(102, 204), random(2, 56), random(0, 53));
}
color greenColor() {
  return color(random(0, 112), random(100, 224), 0);
}
int counter=1;
void draw() {
  println(frameCount);
  println(counter);
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
  particles = new Particle[300];
  for (int i = 0; i < 300; i++) { 
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
    fill(200, 100);
    stroke(255);
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
