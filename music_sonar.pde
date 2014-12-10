import arb.soundcipher.*;
import SimpleOpenNI.*;

final int canvasWidth = 640;
final int canvasHeight = 480;
final int setFrameRate = 30;
final int maxObject = 6;

// SensedObject[] objects;
TestObject[] objects;
int objectCount = 1;

SoundCipher[] sounds;
// SoundCipher baseSound;
SCScore baseSound;
SCScore nearSound;
SCScore[] onebaseSounds;
// SoundCipher backMusic1;

LineWave lineWave;
SonarWave sonarWave;
MapMusic mapMusic;

SimpleOpenNI simpleOpenNI;
//kinectの取得できるピクセル(640,480)
//depthMap

int modeNum = 0;

int moveObNum = 0;

class TestObject {
    float x, y;

    TestObject (float x, float y) {
        this.x = x;
        this.y = y;
    }
};

void setup() {
    size(canvasWidth*2, canvasHeight);

    colorMode(HSB, 255);
    background(255);

   sounds = new SoundCipher[maxObject];
    for(int c = 0; c < maxObject; ++c){
        sounds[c] = new SoundCipher(this);
    }
    // baseSound = new SoundCipher(this);
    onebaseSounds = new SCScore[3];
    for (int i = 0; i < 3; ++i) {
        onebaseSounds[i] = new SCScore();
    }
    baseSound = new SCScore();
    nearSound = new SCScore();

    // simpleOpenNI = new SimpleOpenNI(this);
    // simpleOpenNI.enableDepth();
    // lineWave = new LineWave(simpleOpenNI, sounds);

    objects = new TestObject[maxObject];
    objects[0] = new TestObject(100, height/2);
    // objects[1] = new TestObject(width/4, 350);
    // objects[2] = new TestObject(width/4, height/2);

    sonarWave = new SonarWave(sounds, baseSound, objects, objectCount, maxObject);
    mapMusic =new MapMusic(nearSound, onebaseSounds, objects, objectCount, maxObject);

    frameRate(setFrameRate);
}

void draw() {
    update();
}

void update() {
    fadeToWhite();
    if(modeNum == 1){
        // lineWave.update();
        sonarWave.update(objects, objectCount);
        drawsetting();
        return;
    }
    // moveObject();
    mapMusic.update(objects, objectCount, moveObNum);
    drawsetting();
}

void fadeToWhite() {
    noStroke();
    fill(255, 200);
    rectMode(CORNER);
    rect(0, 0, width/2, height);

    noStroke();
    fill(255);
    rectMode(CORNER);
    rect(width/2, 0, width, height);
}

void keyPressed() {
    if(key == 'c' || key == 'C'){
        modeNum = (modeNum + 1 ) % 2;
        return;
    }
    if(key == 'z' || key == 'Z'){
        moveObNum = (moveObNum + 1) % objectCount;
    }
    if(key == 'e' || key == 'E'){
        noLoop();
        exit();
        return;
    }
    if(key == '+'){
        createObject();
        return;
    }
    if(key == '-'){
        deleteObject();
        return;
    }
    // textSize(12);
    // fill(0);
    // text("key: " + key, width/2 + 100, 200);
}

void mousePressed() {
    int ch_x = mouseX;
    if(ch_x >= width/2){
        ch_x = width/2;
    }
    objects[moveObNum].x = ch_x;
    objects[moveObNum].y = mouseY;
}

void createObject() {
    if(objectCount >= maxObject){
        return;
    }
    objects[objectCount] = new TestObject(width/4, height/2);
    objectCount++;
}

void deleteObject() {
    if(objectCount <= 1){
        return;
    }
    objects[objectCount - 1] = null;
    objectCount--;
    moveObNum = moveObNum % objectCount;
}

void drawsetting() {
    textSize(12);
    fill(0);
    text("moveObjectNum: " + moveObNum, width/2 + 100, 50);
    for(int i = 0; i < objectCount; ++i){
        text("objectNum:" + i + "  x:" + objects[i].x + " y:" + objects[i].y, width/2 + 100, 100 + 20*i);
    }
    stroke(0);
    strokeWeight(1);
    line(width/2, 0, width/2, height);
}

void exit() {
    for(int c = 0; c < maxObject; ++c){
        sounds[c].stop();
    }
    println("EXIT");
    super.exit();
}


//test用
float amount0 = 1;
float amount1 = 0.5;
float amount2X = 0.5;
float amount2Y = 0.5;
void moveObject() {
    for (int c = 0; c < 3; ++c) {
        switch (c%maxObject) {
            case 0:
                if(objects[c].x > width || objects[c].x < 0){
                    amount0 = amount0*(-1);
                }
                objects[c].x = objects[c].x + amount0;
            break;
            case 1:
                if(objects[c].y > height*4/5 || objects[c].y < 0){
                    amount1 = amount1*(-1);
                }
                objects[c].y = objects[c].y + amount1;
            break;
            case 2:
                if(objects[c].x > width || objects[c].x < 0){
                    amount2X = amount2X*(-1);
                }
                objects[c].x = objects[c].x + amount2X;
                if(objects[c].y > height*4/5 || objects[c].y < 0){
                    amount2Y = amount2Y*(-1);
                }
                objects[c].y = objects[c].y + amount2Y;
            break;
        }
    }
}


