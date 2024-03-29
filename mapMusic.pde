
class MapMusic {
    final int userPosX = width / 4;
    final int userPosY = height;
    final int maxDistance = (int)dist(userPosX, userPosY, 0, 0);

    int countFrame;
    int objectCount;

    SCScore nearSound;
    SCScore baseSound;
    SCScore drumSound;
    int resetFlag = 0;

    TestObject[] objects;

    float[] mapObjects;

    ChordSet chordSet;

//現在の小節
    int measureCount;

    MapMusic(SCScore nearSound, SCScore baseSound,SCScore drumSound,TestObject[] objects, int objectCount, int maxObject) {
        this.objectCount = objectCount;
        this.nearSound = nearSound;
        this.drumSound = drumSound;
        this.nearSound.tempo(180);
        this.nearSound.repeat(0);

        this.drumSound.tempo(60);
        this.drumSound.repeat(0);

        this.baseSound = baseSound;
        this.baseSound.tempo(60);
        this.baseSound.repeat(0);

        this.objects = new TestObject[maxObject];
        for (int c = 0; c < this.objectCount; ++c) {
            this.objects[c] = new TestObject(objects[c].x, objects[c].y);
        }
        mapObjects = new float[6];
        for(int i = 0; i < 6; ++i){
            mapObjects[i] = -1;
        }
        chordSet = new ChordSet();
        measureCount = 1;
    }

    void update(TestObject[] objects, int objectCount, int moveObNum) {
        countFrame = countFrame % ((int)frameRate * 4);

         if(!nearSound.isPlaying() && !baseSound.isPlaying()){
            println("Start [" + measureCount + "] measure!");
            measureCount++;
            setMap();
            soundMusic();
        }
        updateObject(objects, objectCount);
        drawLine();
        drawObject(moveObNum);
        drawMap();
        countFrame++;
    }

    void updateObject(TestObject[] objects, int objectCount){
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
    }

    void initMusic(int flag){
        println("!!Stop music!!");
        this.nearSound.stop();
        this.nearSound.empty();
        this.drumSound.stop();
        this.drumSound.empty();
        this.baseSound.stop();
        this.baseSound.empty();
        countFrame =0;
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
        for (int c = 0; c < this.objectCount; ++c) {
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
        this.nearSound.stop();
        this.nearSound.empty();
        this.baseSound.stop();
        this.baseSound.empty();

        for(int c = 0; c < 6; ++c){
            if(mapObjects[c] <= 0){
                continue;
            }
            pan = 25*c + 1;
            if(pan>127){
                pan = 127;
            }
            if(height/5<= mapObjects[c] && mapObjects[c] < 3*height/5){
                float[] chord = chordSet.getCadenceChord(0);
                disPitch = map(mapObjects[c], height/5, 3*height/5, 0, 20);
                oneBases[0][chordCount] = chord[0];
                oneBases[1][chordCount] = chord[1];
                oneBases[2][chordCount] = chord[2];
                oneBasesPan[chordCount] = pan;
                base_dynamics[chordCount] = 45 + disPitch;
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
                longtails[pitchCount] = 1;
                pitchCount++;
                f = f - savePharse[0];
                phrase[pitchCount] = f;
                phrasePans[pitchCount] = pan;
                dynamics[pitchCount] = 80 - random(-10, 30);
                longtails[pitchCount] = 2;
                pitchCount++;
                // f = f - savePharse[1];
                // phrase[pitchCount] = f;
                // phrasePans[pitchCount] = pan;
                // dynamics[pitchCount] = 80 - random(60, 40);
                // pitchCount++;
            }
        }

        if(pitchCount !=0){
            for(int c= 0 ;  c < 12; ++c){
                // longtails[c] = 1;
                articulations[c] = 0.8;
            }
            int pitchCountGap = 12 - pitchCount;
            for (int i = 0; i < pitchCountGap; ++i) {
                phrase[pitchCount + i] = phrase[i % pitchCount];
                phrasePans[pitchCount + i] = phrasePans[i % pitchCount];
                dynamics[pitchCount+ i] = dynamics[i%pitchCount];
                longtails[pitchCount + i] = longtails[i%pitchCount];
            }
            this.nearSound.addPhrase(0, 0, 0, phrase, dynamics, longtails, articulations, phrasePans);
        }

        if(chordCount==0){
                float[] chord2 = chordSet.getRandomMinChord(0);
                oneBases[0][0] = chord2[0] ;
                oneBases[1][0] = chord2[1] ;
                oneBases[2][0] = chord2[2] ;
                base_dynamics[0] = 30;
                oneBasesPan[0] = 64;
                for(int c= 0 ;  c < 6; ++c){
                    base_longtails[c] = 1;
                    base_articulations[c] = 0.8;
                }
                chordCount = 1;
        }else {
                for(int c= 0 ;  c < 6; ++c){
                    base_longtails[c] = 1;
                    base_articulations[c] = 0.8;
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

        float instrument = this.baseSound.EPIANO;
        for(int i=0; i<6; ++i) {
        float[] setChord = {oneBases[0][i], oneBases[1][i], oneBases[2][i]};
            this.baseSound.addChord(i, 0, instrument, setChord, base_dynamics[i], 1, 0.8, oneBasesPan[i]);
        }
        this.baseSound.play();

        if(pitchCount != 0){
            this.nearSound.play();
        }
        backMusic();
         resetFlag = 1;
    }

    void backMusic()
    {
        this.drumSound.stop();
        this.drumSound.empty();
        float[] phrase = new float[18];
        float[] dynamics = new float[18];
        float[] phrasePans = new float[18];
        float[] longtails = new float[18];
        float[] articulations = new float[18];
        for(int i=0; i<6; ++i){
            phrase[i] = 36;
            dynamics[i] = 100;
            phrasePans[i] = 64;
            longtails[i] = 1;
            articulations[i] = 0.8;
        }
        this.drumSound.addPhrase(0, 9, 0, phrase, dynamics, longtails, articulations, phrasePans);
            phrase = new float[18];
            dynamics = new float[18];
            phrasePans = new float[18];
            longtails = new float[18];
            articulations = new float[18];
         for(int i=0; i<18; ++i){
            phrase[i] = 42;
            dynamics[i] = 60;
            phrasePans[i] = 64;
            longtails[i] = 1/3.0;
            articulations[i] = 0.8;
        }
        this.drumSound.addPhrase(0, 9, 0, phrase, dynamics, longtails, articulations, phrasePans);
            phrase = new float[18];
            dynamics = new float[18];
            phrasePans = new float[18];
            longtails = new float[18];
            articulations = new float[18];
         for(int i=0; i<1; ++i){
            phrase[i] = 49;
            dynamics[i] = 70;
            phrasePans[i] = 64;
            longtails[i] = 1;
            articulations[i] = 0.8;
        }
        this.drumSound.addPhrase(0, 9, 0, phrase, dynamics, longtails, articulations, phrasePans);
        this.drumSound.play();
    }

};
