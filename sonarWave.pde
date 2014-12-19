
class SonarWave {
    final int userPosX = width / 4;
    final int userPosY = height;
    final int maxDistance = (int)dist(userPosX, userPosY, 0, 0);

    int countSonar;
    int objectCount;

    SoundCipher[] hitSounds;
    SCScore baseSound;
    int[] baseSoundFlag;

    SensedObject[] objects;

    ChordSet chordSet;

    SonarWave(SoundCipher[] hitSounds, SCScore  baseSound,TestObject[] objects, int objectCount, int maxObject) {
        countSonar = 0;
        this.objectCount = objectCount;
        this.hitSounds = hitSounds;
        this.baseSound = baseSound;
        this.baseSound.tempo(60);
        this.baseSound.repeat(0);
        this.baseSound.pan(64);
        // baseSound();
        this.objects = new SensedObject[maxObject];
        for (int c = 0; c < this.objectCount; ++c) {
            this.objects[c] = new SensedObject(objects[c].x, objects[c].y);
        }
         this.baseSoundFlag = new int[maxObject];
        for (int c = 0; c < this.objectCount; ++c) {
            this.baseSoundFlag[c] = 0;
        }
        chordSet = new ChordSet();
    }

    void update(TestObject[] objects, int objectCount) {
        for(;;){
            if (this.objectCount == objectCount) {
                break;
            }
            if (this.objectCount > objectCount) {
                this.baseSoundFlag[this.objectCount-1] = 0;
                this.objects[this.objectCount-1] = null;
                this.objectCount--;
            }
            if (this.objectCount < objectCount) {
                this.baseSoundFlag[this.objectCount] = 0;
                this.objects[this.objectCount] = new SensedObject(objects[this.objectCount].x, objects[this.objectCount].y);
                this.objectCount++;
            }
        }
        for (int c = 0; c < this.objectCount; ++c) {
            this.objects[c].posX = objects[c].x;
            this.objects[c].posY = objects[c].y;
        }
        sonarWrite();
        drawObjects();
        emissionObject();
        baseSound();
    }

    void sonarWrite() {
        float sonarRadius;

        countSonar = countSonar % ((int)frameRate * 9);
        if(countSonar < 10){
            for (int c = 0; c < objectCount; ++c) {
                objects[c].flag = 0;
                this.baseSoundFlag[c] = 0;
            }
        }
        sonarRadius = countSonar * 5;
        stroke(50, 100, 100);
        strokeWeight(0.8);
        fill(255, 200);
        ellipse(userPosX, userPosY, sonarRadius, sonarRadius);

        noStroke();
        fill(255);
        rectMode(CORNER);
        rect(width/2, 0, width, height);

        countSonar = countSonar + 1;
    }

    void drawObjects() {
        noStroke();
        float col = 0.0;
        float transparency = 0.0;

        for (int c = 0; c < objectCount; ++c) {
            fill(0, 100, 0, 100);
            ellipse(objects[c].posX, objects[c].posY, 10, 10);
            if(objects[c].flag == 1){
                objects[c].objectTime++;
                col = calculationDgrees(objects[c].prePosX, objects[c].prePosY);
                col = 255 * col / 360;
                transparency = centerDistance(objects[c].prePosX, objects[c].prePosY);
                transparency = 255 - 150 * transparency / maxDistance;
                transparency = transparency - objects[c].objectTime;
                fill(col, 200, 200, transparency);
                ellipse(objects[c].prePosX, objects[c].prePosY, 10, 10);
            }
        }
    }

    void emissionObject() {
        color col;
        for (int c = 0; c < objectCount; ++c) {
            col = get((int)objects[c].posX, (int)objects[c].posY);
            if(col == -6776680 && objects[c].flag == 0){
                objects[c].flag = 1;
                objects[c].prePosX = objects[c].posX;
                objects[c].prePosY = objects[c].posY;
                objects[c].objectTime = 0;
                collisionSound(objects[c].prePosX, objects[c].prePosY,c);
            }
        }
    }

    float centerDistance(float x, float y) {
        return dist(userPosX, userPosY, x, y);
    }

    float calculationDgrees(float x, float y) {
        return abs(degrees(atan2(y - userPosY, x - userPosX)));
    }

    void collisionSound(float x, float y, int c) {
        float range = centerDistance(x, y);
        float angle = calculationDgrees(x, y);
        // float pitch = 90 - 100*angle/360;
        float pitch = chordSet.getPitch(2, maxDistance-range, maxDistance);
        float dynamic = 110 - (range/maxDistance)*20;
        float pan = 127 - (angle/360)*127;
        float longtail = 2-this.objectCount*0.5;
        if(longtail < 0.5){
            longtail = 0.5;
        }
        hitSounds[c].stop();
        hitSounds[c].playNote(
            0,
            0,
            0,
            pitch,
            dynamic,
            longtail,
            0.8,
            pan
        );
    }

    void baseSound(){
        int melodic_phrase = (int)frameRate * 9 / (this.objectCount + 1);
        for(int c = 0; c<this.objectCount; ++c){
            if(melodic_phrase * (c+1) < countSonar  && this.baseSoundFlag[c] == 0){
                    float longtail = 4-this.objectCount*0.2;
                    if(longtail < 1){
                        longtail = 1;
                    }
                    this.baseSound.stop();
                    this.baseSound.empty();
                    float[] chord = chordSet.getRandomChord(0);
                    float instrument = this.baseSound.PIANO;
                    this.baseSound.addChord(0, 0, 0, chord, 100, longtail, 0.8, 64);
                    this.baseSoundFlag[c] = 1;
                    this.baseSound.play();
            }
        }
    }

};

class SensedObject {
  float posX, posY, prePosX, prePosY;
  int flag, objectTime;

    SensedObject (float x, float y) {
    posX = x;
    posY = y;
    prePosX = x;
    prePosY = y;
    flag = 0;
    objectTime = 0;
  }
};
