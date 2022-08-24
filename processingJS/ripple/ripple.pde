int num = 20;
Ripple[] ripples = new Ripple[num];

void setup() {
  size(480, 640);
  frameRate(30);
  colorMode(HSB, 100);
  background(100);
  smooth();
  
  for(int i = 0; i < num; i++) {
    ripples[i] = new Ripple(0, 0, 0, 0, 0, false);
  }
}

void draw() {
  background(100);
  for(int i = 0; i < num; i++) {
    if(ripples[i].getFlag()) {
      ripples[i].move();
      ripples[i].rippleDraw();
    }
  }
}

void mousePressed() {
  for(int i = num-1; i > 0; i--) {
    ripples[i] = new Ripple(ripples[i-1].x, ripples[i-1].y, ripples[i-1].diameter, ripples[i-1].speed, ripples[i-1].hue, true);
  }
  ripples[0] = new Ripple(mouseX, mouseY, 0, random(5,15), int(random(10,80)), true);
}

class Ripple{
  int x,y;
  float diameter;
  float speed;
  float friction = 0.985;
  int hue;
  boolean flag;
  
  Ripple(int _x, int _y, float _diameter, float _speed, int _hue, boolean _flag) {
    x = _x;
    y = _y;
    diameter = _diameter;
    speed = _speed;
    hue = _hue;
    flag = _flag;
  }

  void rippleDraw() {
    noFill();
    if(speed > 1.0) {
      stroke(hue, 60, 99, 100*(speed-1)/3);
      strokeWeight(4);
      ellipse(x, y, diameter, diameter);
    }
    if(speed > 1.5) {
      stroke(hue, 60, 99, 100*(speed-1.5)/3);
      strokeWeight(2);
      ellipse(x, y, diameter*0.7, diameter*0.7);
    }
    if(speed > 2.0) {
      stroke(hue, 60, 99, 100*(speed-2)/3);
      strokeWeight(1);
      ellipse(x, y, diameter*0.6, diameter*0.6);
    }
  }

  void move() {
    diameter += speed;
    speed *= friction;
    if(speed < 0.5) {
      flag = false;
    }
  }

  public boolean getFlag() {
    return flag;
  }
}
