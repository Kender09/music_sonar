class ChordSet {

//1オクターブ12
float[] keysNoteMap;

float[][] chordMap;

//Cメジャー
int[] tMap = { 0, 13, 14, 16};
int[] dMap = { 7, 15};
int[] sMap = { 5, 12};

//カデンツで次の, ;
char next_K = 'T';

int save_i = -1;

    ChordSet() {
        keysNoteMap = new float[32];
        chordMap = new float[32][5];

        for(int i=0; i < 24; ++i){
            keysNoteMap[i] = 35 + i;
        }
        // C T
        chordMap[0][0] = keysNoteMap[0];
        chordMap[0][1] = keysNoteMap[4];
        chordMap[0][2] = keysNoteMap[7];
        // C#
        chordMap[1][0] = keysNoteMap[1];
        chordMap[1][1] = keysNoteMap[5];
        chordMap[1][2] = keysNoteMap[8];
        // D
        chordMap[2][0] = keysNoteMap[2];
        chordMap[2][1] = keysNoteMap[6];
        chordMap[2][2] = keysNoteMap[9];
        // D#
        chordMap[3][0] = keysNoteMap[3];
        chordMap[3][1] = keysNoteMap[7];
        chordMap[3][2] = keysNoteMap[10];
        // E
        chordMap[4][0] = keysNoteMap[4];
        chordMap[4][1] = keysNoteMap[8];
        chordMap[4][2] = keysNoteMap[11];
        // F S
        chordMap[5][0] = keysNoteMap[2];
        chordMap[5][1] = keysNoteMap[6];
        chordMap[5][2] = keysNoteMap[9];
        // F#
        chordMap[6][0] = keysNoteMap[6];
        chordMap[6][1] = keysNoteMap[10];
        chordMap[6][2] = keysNoteMap[13];
        // G D
        chordMap[7][0] = keysNoteMap[7];
        chordMap[7][1] = keysNoteMap[11];
        chordMap[7][2] = keysNoteMap[14];
        // G#
        chordMap[8][0] = keysNoteMap[8];
        chordMap[8][1] = keysNoteMap[12];
        chordMap[8][2] = keysNoteMap[15];
        // A
        chordMap[9][0] = keysNoteMap[9];
        chordMap[9][1] = keysNoteMap[13];
        chordMap[9][2] = keysNoteMap[16];
        // A#
        chordMap[10][0] = keysNoteMap[10];
        chordMap[10][1] = keysNoteMap[14];
        chordMap[10][2] = keysNoteMap[17];
        // B
        chordMap[11][0] = keysNoteMap[11];
        chordMap[11][1] = keysNoteMap[15];
        chordMap[11][2] = keysNoteMap[18];
        // Dm S
        chordMap[12][0] = keysNoteMap[2];
        chordMap[12][1] = keysNoteMap[5];
        chordMap[12][2] = keysNoteMap[9];
        // Em T
        chordMap[13][0] = keysNoteMap[4];
        chordMap[13][1] = keysNoteMap[7];
        chordMap[13][2] = keysNoteMap[11];
        // Am T
        chordMap[14][0] = keysNoteMap[9];
        chordMap[14][1] = keysNoteMap[12];
        chordMap[14][2] = keysNoteMap[16];
        // Bm -5 D
        chordMap[15][0] = keysNoteMap[11];
        chordMap[15][1] = keysNoteMap[14];
        chordMap[15][2] = keysNoteMap[17];
        // C oc+1 T
        chordMap[16][0] = keysNoteMap[0];
        chordMap[16][1] = keysNoteMap[4];
        chordMap[16][2] = keysNoteMap[7];
    }

    float[] getMin(float[] cho){
        cho[2] = cho[2] - 1;
        return cho;
    }

    float[] getDim(float[] cho){
        cho = getMin(cho);
        cho[3] = cho[3] - 1;
        return cho;
    }

    float[] getAug(float[] cho){
        cho[3] = cho[3] + 1;
        return cho;
    }

    float[] getRandomChord(float oc){
        int i;
        while (true) {
            i = (int)random(11);
            if(i != save_i){
                break;
            }
        }
        float[] setchord = chordMap[i];
        for(int c=0; c<3 ;++c){
            setchord[c] = setchord[c] + 12*oc;
        }
        int chenge = (int)random(12);
        if(chenge == 0 || chenge == 1 || chenge == 2){
            setchord = getMin(setchord);
        }
        if(chenge == 3){
            setchord = getDim(setchord);
        }
        if(chenge == 4){
            setchord = getAug(setchord);
        }
        save_i = i;
        return setchord;
    }

    float[] getRandomMinChord(float oc){
        int i;
        while (true) {
            i = (int)random(11);
            if(i != save_i){
                break;
            }
        }
        float[] setchord = chordMap[i];
        for(int c=0; c<3 ;++c){
            setchord[c] = setchord[c] + 12*oc;
        }
        setchord = getMin(setchord);
        save_i = i;
        return setchord;
    }

    float[] getRandomNormalChord(float oc){
        int i;
        while (true) {
            i = (int)random(11);
            if(i != save_i){
                break;
            }
        }
        float[] setchord = chordMap[i];
        for(int c=0; c<3 ;++c){
            setchord[c] = setchord[c] + 12*oc;
        }
        save_i = i;
        return setchord;
    }

        float[] getCadenceChord(float oc){
        int i = 0;
        if(next_K == 'T'){
            i = (int)random(tMap.length);
            i = tMap[i];
            int r = (int)random(3);
            next_K = 'S';
            if(r == 2){
                next_K='D';
            }
        }
        if(next_K == 'S'){
            i = (int)random(sMap.length);
            i = sMap[i];
            int r = (int)random(2);
            next_K = 'S';
            if(r == 1){
                next_K='D';
            }
        }
        if(next_K == 'D'){
            i = (int)random(dMap.length);
            i = dMap[i];
            next_K = 'T';
        }
        float[] setchord = chordMap[i];
        for(int c=0; c<3 ;++c){
            setchord[c] = setchord[c] + 12*oc;
        }
        return setchord;
    }


    float getPitch(float oc, float f, float max_f){
        float pitch = keysNoteMap[0] + oc*12;
        f = f*24/max_f;
        return pitch + f;
    }

};