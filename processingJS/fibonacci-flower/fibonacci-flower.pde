void setup() {
  size(480, 640);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  noStroke();
  smooth();
}

void draw() {
  fill(0, 1);
  rect(0, 0, width, height);

  int totalPetals = frameCount % 600;
  float rotation = 0.0;
  float gAngle = PI * 2 / ((sqrt(5) - 1) / 2);
  float radius = 60;
  float radiusGrowth = 1.005;  
  for (int i = 0; i < totalPetals; i++) {
    rotation += gAngle;
    radius *= radiusGrowth;
    Petal petal = new Petal();
    petal.hue = 180;
    petal.x = width / 2 + cos(rotation) * radius;
    petal.y = height / 2 + sin(rotation) * radius;
    petal.rotation = rotation;
    petal.render();
  }

  if(frameCount % 600 == 0) {setup();}
}

class Petal {
  float hue = 0;
  float x = 0.0;
  float y = 0.0;
  float rotation = 0.0;
  
  void render (){
    color baseColor = color(this.hue, 100, 70, 3);
    color detailColor = color(this.hue, 100, 100, 3);
    color trimColor = color(0);

    pushMatrix();
    translate(this.x, this.y);
    fill(baseColor);
    rotate(this.rotation);
    rect(-10, -1, 20, 2);
    ellipse(0, 0, 10, 10);
    fill(detailColor);
    ellipse(0, 0, 8, 8);
    fill(trimColor);
    ellipse(0, 0, 5, 5);
    popMatrix();
  }
}
