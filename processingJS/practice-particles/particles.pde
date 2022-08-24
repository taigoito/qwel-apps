int num = 1000;
float[] locationX = new float[num];
float[] locationY = new float[num];
float[] velocityX = new float[num];
float[] velocityY = new float[num];
float hue = random(360);

void setup() {
    size(480, 640);
    frameRate(30);
    colorMode(HSB, 360, 100, 100, 100);
    background(0);
    noStroke();
    smooth();
    for(int i = 0; i < num; i++) {
        locationX[i] = width / 2;
        locationY[i] = height / 2;
        velocityX[i] = random(0.1) - 0.05;
        velocityY[i] = random(0.1) - 0.05;
    }
}

void draw() {
    fill(0, 2);
    rect(0, 0, width, height);
    fill(0, 0, 100);
    textSize(36);
    text("Particles", 12, 36);

    hue += 1;
    if (hue >= 360) { hue -= 360; }
    float distance = 0;
    float saturation = 70;
    float brightness = 70;

    for (int i = 0; i < num; i++) {
        locationX[i] += velocityX[i];
        locationY[i] += velocityY[i];
        velocityX[i] += random(0.1) - 0.05;
        velocityX[i] *= 0.995;
        velocityY[i] += random(0.1) - 0.05;
        velocityY[i] *= 0.995;

        distance = abs(locationX[i] - width / 2) + abs(locationY[i] - height / 2);
        saturation = map(distance, 0, width / 2 + height / 2, 0, 100);
        brightness = 70;
        fill(hue, saturation, brightness);
        ellipse(locationX[i], locationY[i], 8, 8);
    }

    if(frameCount % 1200 == 0) {setup();}

}
