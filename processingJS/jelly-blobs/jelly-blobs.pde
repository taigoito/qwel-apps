int num = 10;
Blob[] blobs = new Blob[num];

void setup() {
    size(480, 640);
    frameRate(60);
    colorMode(HSB, 360, 100, 100, 100);
    background(0);
    noStroke();
    smooth();
    for (int i = 0; i < num; i++) {
        blobs[i] = new Blob();
    }
}

void draw() {
    fill(0);
    rect(0, 0, width, height);
    fill(0, 0, 100);
    textSize(36);
    text("Jelly Blobs", 12, 36);

    fill(0, 100, 100);
    for(int i = 0; i < num; i++) {
        blobs[i].move();
        blobs[i].stroke();
    }
    fill(0, 0, 100);
    for(int i = 0; i < num; i++) {
        blobs[i].fill();
    }
}

class Blob {
    float x = width / 4 + random(width / 2);
    float y = height / 4 + random(height / 2);
    float vx = 0.0;
    float vy = 0.0;
    float mass = random(10);
    float easingX = 0.1 / this.mass + random(0.1);
    float easingY = 0.1 / this.mass + random(0.1);
    float friction = 0.05;
    float strokeDiameter = this.mass * 12 + 60;
    float fillDiameter = this.strokeDiameter - 24;
    
    void stroke() {
        ellipse(this.x, this.y, this.strokeDiameter, this.strokeDiameter);
    }

    void fill() {
        ellipse(this.x, this.y, this.fillDiameter, this.fillDiameter);
    }

    void move() {
        this.vx += (mouseX - this.x) * this.easingX;
        this.vx *= (1 - this.friction);
        this.vy += (mouseY - this.y) * this.easingY;
        this.vy *= (1 - this.friction);
        this.x += this.vx;
        this.y += this.vy;
    }
}
