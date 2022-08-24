int num = 1000;
int particleIndex = 0;
Particle[] particles = new Particle[num];

void setup() {
  size(480, 640);
  frameRate(60);
  colorMode(HSB, 360, 100, 100, 100);
  translate(width/2, height/2);
  background(0);
  noStroke();
  smooth();
  for (int i = 0; i < num; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
  fill(0, 15);
  rect(0, 0, width, height);
  for (int i = 0; i < num; i++) {
    particles[i].update();
    particles[i].render();
  }
}

void mouseMoved() {
  Particle nextParticle = particles[particleIndex];
  nextParticle.reset();
  if (++particleIndex >= num) particleIndex = 0;
}

class Particle {
  float x = 0.0;
  float y = 0.0;
  float vx = 0.0;
  float vy = 0.0;
  int life = 0;
  
  void update() {
    this.life--;
    if (life < 30) {
      this.vx += random(4.0) - 2.0;
      this.vx *= 0.9;
      this.vy += random(4.0) - 2.0;
      this.vy *= 0.9;
      this.x += vx;
      this.y += vy;
    }
  }
  
  void reset() {
    this.x = mouseX;
    this.y = mouseY;
    this.vx = 0.0;
    this.vy = 0.0;
    this.life = 90;
  }
  
  void render() {
    float dx = this.x - width / 2;
    float dy = this.y - height / 2;
    float hue = degrees(atan2(dy, dx)) + 180;
    float saturation = map(abs(dx) + abs(dy), 0, width / 2 + height / 2, 50, 100);
    float brightness = life * 10;
    fill(hue, saturation, brightness, life * 10);
    ellipse(this.x, this.y, 6, 6);
  }
}
