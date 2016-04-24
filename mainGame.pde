/*
load your gun and shoot;)
put your mouse in the circle to load
when the gun is ready
you can move it around with your mouse, click left mouse to shoot
if the enemy go beyond the screen, you lose;)
*/

import ddf.minim.*;

Minim minim;
AudioSample shoot;
AudioPlayer bgm;

int gunFrames = 24; //gun animation frames
int eneFrames = 4;  //enemy animation frames
int[] bulletY = {}; //bullet y coordinates
int[] bulletX = {}; //bullet x coordinates
float[] enemyY = new float[20];  //enemy y coordinates
float[] enemyX = new float[20];  //enemy x coordinates
float[] bodyX = {};//deadbody x coordinates
float[] bodyY = {};//deadbody y coordinates
int[] enemyF = new int[20]; //enemy pose array
int esX = 8; //enemy speed x
int esY; //enemy speed y
color[] c = {}; //bullet color
int d = 10, s = 40; //bullet size
float bsX; //bullet speed X
float bsY; //bullet speed Y
boolean ready = false; //gun status
boolean left = true; // fire status
boolean lose = false; //game status
int frame1,frame2 = 0; //two frame for gun and enemy animation 
PFont f;
PImage start;
PImage gun;
PImage shootleft;
PImage shootright;
PImage enemydead;
PImage[] enemyactions = new PImage[eneFrames];
PImage[] guns = new PImage[gunFrames];
    
void setup() {
  size(1280,720);
  start = loadImage("start.jpg"); //start img
  gun = loadImage("gun.png");//gun img
  shootleft = loadImage("shootleft.png");
  shootright = loadImage("shootright.png");
  enemydead = loadImage("enemydead.png"); //deadbody
  f = createFont("Georgia", 24);
  textFont(f);
  textAlign(CENTER);
  fill(0, 255, 0);
  minim = new Minim(this);
  bgm = minim.loadFile("Pacific Rim.mp3", 2048); 
  shoot = minim.loadSample("cannon.wav");
  bgm.loop();
  for (int i=0; i<gunFrames; i++) {
    String filename = nf(i,2)+".jpg";
    guns[i]  = loadImage(filename);
  }
  for (int i=0; i<eneFrames; i++) {
    String filename = "enemy"+nf(i,1)+".png";
    enemyactions[i]  = loadImage(filename);
  }
  newEnemy();
  frameRate(10);
} 
 
void draw() {
  background(255);
  if(lose == false){
      startGame(); 
  }else {
      endGame();
  }
      drawGun();

  //println( mouseX, mouseY);
}



void mousePressed() {
  if(ready ==true && lose == false){
  if(left == true){
    imageMode(CENTER);
    image(shootleft, mouseX+230, mouseY+3, 640, 360);//shoot img
    bulletY = append(bulletY, mouseY-5); //add bullet
    bulletX = append(bulletX, mouseX+190);
    c = append(c, color(random(200), random(200), random(200,255), random(100,255)));
    left = false;
    shoot.trigger();
  }else{ 
    imageMode(CENTER);
    image(shootright, mouseX+230, mouseY+3, 640, 360);
    bulletY = append(bulletY, mouseY+14);
    bulletX = append(bulletX, mouseX+190);
    c = append(c, color(random(200), random(200), random(200,255), random(100,255)));
    left = true;
    shoot.trigger();
  }
  }
}

void startGame() {
    if(ready == false){ 
    imageMode(CENTER);  
    image(start, 640, 360, 640, 360);
  }else{ 
    frameRate(30);
    drawBody();
    drawBullet();
    drawEnemy();
    gun();
    checkEscape();
  }
}

void endGame(){
    text("YOU LOSE", mouseX, mouseY);
}

void drawGun() {
    if(618 < mouseX && mouseX < 626 && 347 < mouseY && mouseY < 362 && ready == false) {
    imageMode(CENTER);
    image(guns[frame1], 640, 360, 640, 360);
    frame1++;
    if (frame1>=gunFrames)
    ready = true;
   }
}

void newEnemy() {
    for(int i=0; i < enemyY.length; i++){
    float drawX = random(1280) + 1280;
    float drawY = random(620) + 50;
    enemyX[i] = drawX;
    enemyY[i] = drawY;
    enemyF[i] = 0;
    }
 }

void drawEnemy() {
  for (int i = 0; i < enemyY.length; i++) {
  enemyX[i] -= esX;
  image(enemyactions[enemyF[i]], enemyX[i], enemyY[i], 200, 200);
  enemyF[i] += 1;
  if(enemyF[i]>=eneFrames) {
      enemyF[i] = 0;
    }
  }
  }

void checkEscape() {
  for (int i = 0; i < enemyY.length; i++){
    if(enemyX[i] <= 0){
        recycleEnemy(i);
        lose = true;
    }
    }
}

void recycleEnemy(int i) {
    enemyX[i] = random(1280) + 1280;
    enemyY[i] = random(620) + 50;
}

void deadBody(float p, float q) {
    bodyX = append(bodyX, p);
    bodyY = append(bodyY, q);
}
 
void drawBody() {
  for (int i = 0; i < bodyY.length; i++) {
    imageMode(CENTER);
    image(enemydead, bodyX[i], bodyY[i], 200, 200);
    }
}
                 
void drawBullet() {
    for (int i = 0; i < bulletY.length; i++) {
    bulletX[i] += s;
    noStroke();
    fill(c[i]);
    ellipse(bulletX[i], bulletY[i], d, d);
    checkHit(i);
    bulletEscape(i);
    }
}

void bulletEscape(int i) {
      if(bulletX[i] > 1280){
      bulletY[i] = -100;
    }
}

void gun() {
    imageMode(CENTER);
    image(gun, mouseX+230, mouseY+3, 640, 360);
}

void checkHit(int i) {
    for (int a = 0; a <  enemyX.length; a++) {
        if (bulletX[i] >= enemyX[a]-50 &&
            bulletX[i] <= enemyX[a]-30 &&
            bulletY[i] >= enemyY[a]-33&&
            bulletY[i] <= enemyY[a]+33) {
                bulletY[i] = -100;
                deadBody(enemyX[a], enemyY[a]);
                recycleEnemy(a);
        }
    }
}
