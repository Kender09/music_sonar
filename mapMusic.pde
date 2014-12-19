
class MapMusic {
    final int userPosX = width / 4;
    final int userPosY = height;
    final int maxDistance = (int)dist(userPosX, userPosY, 0, 0);

    int countFrame;
    int objectCount;

    SCScore nearSound;
    SCScore[] baseSounds;
    int resetFlag = 0;

    TestObject[] objects;

    float[] mapObjects;

    ChordSet chordSet;

    MapMusic(SCScore nearSound, SCScore[] baseSounds,TestObject[] objects, int objectCount, int maxObject) {
        this.objectCount = objectCount;
        this.nearSound = nearSound;
        this.nearSound.tempo(224);
        this.nearSound.repeat(0);

        // this.baseSound = baseSound;
        // this.baseSound.tempo(60);
        // this.baseSound.repeat(-1);
        this.baseSounds = baseSounds;
        for (int i = 0; i < 3; ++i) {
            this.baseSounds[i].tempo(56);
            this.baseSounds[i].repeat(0);
        }

        this.objects = new TestObject[maxObject];
        for (int c = 0; c < this.objectCount; ++c) {
            this.objects[c] = new TestObject(objects[c].x, objects[c].y);
        }
        mapObjects = new float[6];
        for(int i = 0; i < 6; ++i){
            mapObjects[i] = -1;
        }
        chordSet = new ChordSet();
    }

    void update(TestObject[] objects, int objectCount, int moveObNum) {
        countFrame = countFrame % ((int)frameRate * 4);

         // if(countFrame < 10 && resetFlag == 0){
        if(!nearSound.isPlaying() && !baseSounds[0].isPlaying()){
            setMap();
            soundMusic();
        }
        // if(countFrame > (int)frameRate * 4 -10 && resetFlag == 1){
        //     resetFlag = 0;
        // }
        for(;;){
            if (this.objectCount == objectCount) {
                break;
            }
            if (this.objectCount > objectCount) {
                this.objects[this.objectCount-1] = null;
                this.objectCount--;
            }
            if (this.objectCount < objectCount) {
                this.objects[this.objectCount] = new TestObject(objects[this.objectCount].x, objects[this.objectCount].y);
                this.objectCount++;
            }
        }
        for (int c = 0; c < this.objectCount; ++c) {
            this.objects[c].x = objects[c].x;
            this.objects[c].y = objects[c].y;
        }
        drawLine();
        drawObject(moveObNum);
        drawMap();
        countFrame++;
    }

    void drawLine(){
        stroke(0, 90);
        strokeWeight(0.5);
        line(width/2,  height/5, 0, height/5);
        line(width/2,  3*height/5, 0, 3*height/5);

        line(width/12,  0, width/12, height);
        line(2*width/12,  0, 2*width/12, height);
        line(3*width/12,  0, 3*width/12, height);
        line(4*width/12,  0, 4*width/12, height);
        line(5*width/12,  0, 5*width/12, height);
    }

    void drawObject(int moveObNum){
        for (int c = 0; c < objectCount; ++c) {
            fill(0, 100, 0, 120);
            if (moveObNum == c) {
                fill(250, 200, 220, 200);
            }
            ellipse(objects[c].x, objects[c].y, 10, 10);
        }
    }

    void drawMap(){
        for (int c = 0; c < 6; ++c) {
            if(mapObjects[c] <= 0){
                continue;
            }
            stroke(50, 100,120, 120);
            strokeWeight(5);
            line(c*width/12, mapObjects[c], (c+1)*width/12, mapObjects[c]);
        }
    }

    void setMap(){
        for(int i = 0; i < 6; ++i){
            mapObjects[i] = -1;
        }
         for(int c = 0; c<this.objectCount; ++c){
                if(0 <= objects[c].x  && objects[c].x < width/12){
                    if(mapObjects[0]  < objects[c].y){
                        mapObjects[0] = objects[c].y;
                    }
                }
                if(width/12 <= objects[c].x && objects[c].x < 2*width/12){
                    if(mapObjects[1]  < objects[c].y){
                        mapObjects[1] = objects[c].y;
                    }
                }
                if(2*width/12 <= objects[c].x && objects[c].x < 3*width/12){
                    if(mapObjects[2]  < objects[c].y){
                        mapObjects[2] = objects[c].y;
                    }
                }
                if(3*width/12 <= objects[c].x && objects[c].x < 4*width/12){
                    if(mapObjects[3]  < objects[c].y){
                        mapObjects[3] = objects[c].y;
                    }
                }
                if(4*width/12 <= objects[c].x && objects[c].x < 5*width/12){
                    if(mapObjects[4]  < objects[c].y){
                        mapObjects[4] = objects[c].y;
                    }
                }
                if(5*width/12 <= objects[c].x && objects[c].x <= 6*width/12){
                    if(mapObjects[5]  < objects[c].y){
                        mapObjects[5] = objects[c].y;
                    }
                }
         }
    }

    void soundMusic(){
        int chordCount = 0;
        int pitchCount = 0;
        float[][] oneBases = new float[3][12];
        float[] oneBasesPan = new float[12];
        float[] base_dynamics = new float[12];
        float[] base_longtails = new float[12];
        float[] base_articulations = new float[12];
        float pan;
        float[] phrase = new float[24];
        float[] dynamics = new float[24];
        float[] phrasePans = new float[24];
        float[] longtails = new float[24];
        float[] articulations = new float[24];
        float disPitch  = 0.0;

        float[] savePharse = new float[3];
        // for (int i = 0; i < 3; ++i) {
        //     savePharse[i] = (int)random(-4, 4) * 2;
        // }
        // this.baseSound.stop();
        this.nearSound.stop();
        // this.baseSound.empty();
        this.nearSound.empty();
        for (int i = 0; i < 3; ++i) {
            this.baseSounds[i].stop();
            this.baseSounds[i].empty();
        }
        for(int c = 0; c < 6; ++c){
            if(mapObjects[c] <= 0){
                continue;
            }
            pan = 25*c + 1;
            if(pan>127){
                pan = 127;
            }
            if(height/5<= mapObjects[c] && mapObjects[c] < 3*height/5){
                // float[] chord = chordSet.getRandomNormalChord(0);
                float[] chord = chordSet.getCadenceChord(0);
                disPitch = map(mapObjects[c], height/5, 3*height/5, 0, 40);
                // this.baseSound.addChord(chordCount, 1, 0, chord, 100, 3, 0.8, pan);
                oneBases[0][chordCount] = chord[0];
                oneBases[1][chordCount] = chord[1];
                oneBases[2][chordCount] = chord[2];
                oneBasesPan[chordCount] = pan;
                base_dynamics[chordCount] = 30 + disPitch;
                chordCount++;
            }
            if( 3*height/5 <= mapObjects[c]){
                float f = chordSet.getPitch(2, mapObjects[c] - 3*height/5, 2*height/5);
               for (int i = 0; i < 3; ++i) {
                    savePharse[i] = (int)random(-4, 4) * 2;
                }
                phrase[pitchCount] = f;
                phrasePans[pitchCount] = pan;
                dynamics[pitchCount] = 80;
                pitchCount++;
                f = f - savePharse[0];
                phrase[pitchCount] = f;
                phrasePans[pitchCount] = pan;
                dynamics[pitchCount] = 80 - random(-10, 30);
                pitchCount++;
                f = f - savePharse[1];
                phrase[pitchCount] = f;
                phrasePans[pitchCount] = pan;
                dynamics[pitchCount] = 80 - random(-20, 10);
                pitchCount++;
                f = f - savePharse[2];
                phrase[pitchCount] = f;
                phrasePans[pitchCount] = pan;
                dynamics[pitchCount] = 80 - random(-10, 30);
                pitchCount++;
            }
        }
        // float longtail = 2- pitchCount * 0.5;
        // if(longtail < 0.5){
        //     longtail = 0.5;
        // }
        if(pitchCount !=0){
            for(int c= 0 ;  c < 24; ++c){
                longtails[c] = 1;
                articulations[c] = 0.8;
                // dynamics[c] = 80;
                // if(c%2 ==1){
                //     dynamics[c] = 50;
                // }
            }
            int pitchCountGap = 24 - pitchCount;
            for (int i = 0; i < pitchCountGap; ++i) {
                phrase[pitchCount + i] = phrase[i % pitchCount];
                phrasePans[pitchCount + i] = phrasePans[i % pitchCount];
                dynamics[pitchCount+ i] = dynamics[i%pitchCount];
            }
            this.nearSound.addPhrase(0, 0, 0, phrase, dynamics, longtails, articulations, phrasePans);
        }

        if(chordCount==0){
                float[] chord2 = chordSet.getRandomMinChord(0);
                oneBases[0][0] = chord2[0] ;
                oneBases[1][0] = chord2[1] ;
                oneBases[2][0] = chord2[2] ;
                // oneBases[0][1] = chord2[0];
                // oneBases[1][1] = chord2[1];
                // oneBases[2][1] = chord2[2];
                base_dynamics[0] = 30;
                // base_dynamics[1] = 50;
                oneBasesPan[0] = 64;
                // oneBasesPan[1] = 64;
                for(int c= 0 ;  c < 6; ++c){
                    base_longtails[c] = 1;
                    base_articulations[c] = 0.8;
                }
                chordCount = 1;
        }else {
                for(int c= 0 ;  c < 6; ++c){
                    base_longtails[c] = 1;
                    base_articulations[c] = 0.8;
                    // base_dynamics[c] = 70;
                }
        }
        int chordCountGap = 6 - chordCount;
        for (int i = 0; i < chordCountGap; ++i) {
            oneBases[0][chordCount + i] = oneBases[0][i % chordCount];
            oneBases[1][chordCount + i] = oneBases[1][i % chordCount];
            oneBases[2][chordCount + i] = oneBases[2][i % chordCount];
            oneBasesPan[chordCount + i] = oneBasesPan[i % chordCount];
            base_dynamics[chordCount + i] = base_dynamics[i % chordCount];
        }
        // float instrument = this.baseSounds[0].ABASS;
        float instrument = this.baseSounds[0].EPIANO;
        for (int i = 0; i < 3; ++i) {
            this.baseSounds[i].addPhrase(0, 0, instrument, oneBases[i], base_dynamics, base_longtails, base_articulations, oneBasesPan);
        }
        for (int i = 0; i < 3; ++i) {
            this.baseSounds[i].play();
        }

        if(pitchCount != 0){
            this.nearSound.play();
        }
         resetFlag = 1;
    }

};
