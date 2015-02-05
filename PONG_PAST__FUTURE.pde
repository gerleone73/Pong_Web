
// MultiMedia Programming
// Assignment 3 / GAME
// 2837227 - Gerry Leonard - leonardger@gmail.com

/*********************************************************************************************************
  GLITCH/RETRO/HAUNTOLOGY STYLED & THEMED PONG (MAN VERSUS MACHINE)
  HAUNTOLOGY: NOSTALGIA FOR THE FUTURE OF OUR CHILDHOOD PAST
**********************************************************************************************************
- Greyscale TV bars
_ Use AudioInput in to distort these bars before/after Game Starts. (distortion dependant on sound levels)
- Simulated signal noise/interference at certain points/scores, More franctic after either Man or Machine score is greater than 4
- Classic atari-style fonts
- Pong styled ADM logo
- Cursor from Arrow to Hand over Click to Start Button, from Arrow/Hand to Crosshair over Info Target to display credits.
- One player = Machine v Man / NO two Player Mode as game is themed as MAN VERSUS MACHINE
- Mouse controlled Man, AI Machine
- Match Point warnings when either Man and/or Machine reaches 9 on scoreboard
- Spacebar to reset game when game over (NOTE: this does work but might still be "glitchy")
- 3 peices of complimentary music: Machine Theme, Game Theme, Macine Defeated Theme (see below)
- "Cindy Electronium" (1959), "The Bass-Line Generator" (1966-67) - Raymond Scott
- "No Way to Prepare" (2010) - To Rococo Rot

- NOTE 1: PLEASE PLAY WITH SOUND UP and defeat and be defeated by the Machine.(see above)

- NOTE 2: my focus has been on acheiving this particular STYLE/THEME rather than on adding lots of functionality

- PS: I LOVED this assignment, and plan on further adding to it over coming weeks/and months 
- (and also learning how to make the code more elegant and effecient!)

*/////////////////////////////////////////////////////////////////////////////////////////////////////////

//import mimim sound libraries
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// create 3 audioplayers

Minim minim;
AudioPlayer player1;
AudioPlayer player2;
AudioPlayer player3;

boolean playing = false; // set boolean to false

// AudioInput to use audio input
AudioInput in;


PImage TVimg; // create a PImage variable called TVimg
PImage ADMimg; // create a PImage variable called ADMimg
PImage INFOimg; // create PImage variable called INFOimg
// sets Y ccoordinates for ball
int ballY = height/2;
// sets the X coordinates for the ball
int ballX = width/2;
// sets the speed of the ball
int speed = 10;
// sets the X direction of the ball when moving
int dirX = 10;
// sets the Y direction of the ball when moving
int dirY = 10;
// stops the game from starting until the player starts
boolean started =  false;
// sets player score
int playerScore = 0;
// sets computer score
int computerScore = 0;
// sets the ball in the middle
float ballPos = height/2;
// sets the speed the computer paddles moves at = fast enough to be a challenge but defeatible
float computerSpeed = 8.2;
//stops the game when player wins or loses
boolean gameOver = false;
boolean machineWon = false;
int x; // "static" lines variables
int y;
//noise
float yoff =0.0;

 String text; // 
 
 //fonts
 
 PFont font1;
 
 PFont font2;

 
void setup() {
  // size of the window
  size (1000, 600);

  TVimg = loadImage("TV.jpg");
  ADMimg = loadImage("ADMping.png");
  INFOimg = loadImage("infoPING.png");
  // smooth edges
  smooth();
    // Minim load files from the data directory
  minim = new Minim(this);
  
  in = minim.getLineIn( Minim.STEREO, 512 );
  
  //load 3 music files into separate players     
 player1 = minim.loadFile("The Bass-Line Generator (1966-67).mp3");
 player2 =minim.loadFile("01 Cindy Electronium.mp3");
 player3 = minim.loadFile("05 No Way to Prepare.mp3");
 
// text to appear when mouse over ADM logo
text = "PROGRAMMING/DESIGN:\nGer Leonard 2837227 \nSOUNDTRACK:\nThe Bass-Line Generator & \nCindy Electronium - Raymond Scott \nNo Way to Prepare - To Rococo Rot";

//load fonts
font1 = loadFont("BlippoBT-Black-48.vlw");
font2 = loadFont("AtariClassicExtrasmooth-48.vlw");
 
}

void draw() {
  
  
  // OPENING SCREEN


  // if the player hasn't started the game
  if (started == false) {
    
    // create TV interference using AudioInput - a unorthodox means to acheive this affect but brings a great dynamic
    
    float r =   0; 
  for ( int i = 0; i < in.bufferSize(); i++) {
    r += abs( in.mix.get( i ) ) * 5;           // distortion dependant on sound levels!!
  }

  tint (55,250);
  image( TVimg, 0, r);     // TV moves according to r float on Y axis
  
    
    
         //create noise
        yoff = yoff + .02;
       float n = noise(yoff) * height;
       stroke(225);
       strokeWeight(random (3));
       line(0, n, width, n);
  
 // ensure audioplayers 1 & 3 are paused and rewound   
player1.pause();
player1.rewind();
player3.pause();
player3.rewind();

//play audioplayer 2

 player2.play();
// player2.loop();   DONT KNOW WHY THIS WOULD NOT WORK, wanted to loop this track so that would not stop but could not.
 playing = true;
 

    tint(255,200); // tint and transparency
    image(ADMimg, 350, 125); 
 
    fill(255);
    // makes the font 110 pixels
    textFont (font1, 110);
    // sets the text to align in CENTER mode
    textAlign(CENTER, CENTER);
  
    text("PONG", width/2, 300);
     // sets rectangle to be drawn from centre
    rectMode(CENTER);
    // draws the button
    // makes the font white
    noStroke();
    fill(255, 200);
 
    rect(width/2, height/2 +100, 300, 100, 15);
  
    fill(0);
    // set font size to 12
    textFont(font2, 12);
    // write "click to start game" on the button
    text("CLICK TO START GAME", width/2, height/2 +100);
    
   image(INFOimg, width/2 -80, 460); // info logo positoned
  
 
//create static ie a line that moves horizontally down the screen

       stroke(225);
       strokeWeight(random (2));

      line(0,y,width,y);
     y = y + 5;
    if(y > height){
    y = 0;
    // add slight blur filter to this line
    filter(BLUR,1);
} 
   // turn arrow to cursor when over button 
    if(mouseX >340 && mouseX <640 && mouseY > 330 && mouseY <450){
     cursor(HAND);
    }else if ( mouseX >width/2 -85 && mouseX<width/2 +75 && mouseY >460 && mouseY< 510){
     // turn arrow to cross when over ADM logo (and display credits)
     cursor(CROSS);
      image(INFOimg, width/2 -80, 460);
    }else{
      cursor(ARROW);
    }
 // display String text when over Info    
 
  if (mouseX >width/2 -85 && mouseX<width/2 +75 && mouseY >460 && mouseY< 510) {
textFont(font2, 8);
 fill(125);
 textAlign(CENTER);
 text(text, width/2,570,590,100);
 }  

 
    // START GAME BUTTON
 
    // sets the hit box of the button
    if (mousePressed && mouseY < height/2 + 150 && mouseY > height/2 +50 && mouseX < width/2 +150 && mouseX > width/2 - 150) {
      // sets the scores to zero
      playerScore = 0;
      computerScore = 0;
      // when button hit, the games begin
      started = true;
      gameOver = false;

//pause and rewind player2
    player2.pause();
    player2.rewind();
 
 //play player1     
  player1.play();
  player1.loop();
  playing =true;
    }
  }

 
  // GAME
 
 
  // to prevent the game running in the background
  else {
    if (gameOver == false) {
      
            
      image(TVimg,0,0); //draw the image to the screen
     tint(35, 200);  // Tint and set transparency
      // removes the mouse cursor
      noCursor();
      

  


      
 // MATCH POINT WARNINGS 
 
 
   if (computerScore == 9){
       
        textFont (font2, 20);
         text("match point!", 200, height/2);
         
 
      } 
      
    if (playerScore == 9){
 
        textFont (font2, 20);
         text("match point!", width - 200, height/2);
      }   
      if ((playerScore == 9) && (computerScore == 9)){
       
        textFont (font2, 20);
         text("match point!", width - 200, height/2);   
         text("match point!", 200, height/2);
      }
      
      
      //create static line and noise interference line when scoreboard between these scores
      
  if ( playerScore < 4  && computerScore < 4){ 

 
        yoff = yoff + .02;
       float n = noise(yoff) * height;
        stroke(115);
       strokeWeight(random (3));
        line(0, n, width, n);
  
 
  
      strokeWeight (random(3));
      line(0,y,width,y);
       y = y + 5;
      if(y > height){
      y = 0;
    
    // add slight BLUR
    filter(BLUR,0.5);   
 }
 
}else{
  
// increase the tension in the game by increasing randomess and pace of "interference" as scores get above 4
  
  yoff = yoff + .05;
 float n = noise(yoff) * height;
  stroke(115);
  strokeWeight(random (5));
  line(0, n, width, n);
  
  
 
  
  strokeWeight (random (5));
      line(0,y,width,y);
 y = y + 4;
  if(y > height){
    y = 0;
    
    // add slight BLUR
    filter(BLUR,0.5);   
}
}

      // SCOREBOARD
 

      // sets font size
      textFont (font2, 30);
      // display the scores either side of the divide
      text("MACHINE", 200,30);
      text(computerScore, width/2 - 50, 30);
      text("MAN",width - 200,30);
      text(playerScore, width/2 + 50, 30);
      

      // DIVIDING LINE
      
      rectMode(CENTER);
      // fill it white
      fill(255);
      noStroke();
      // draws a thin rectangle  down the middle of the window
      rect(width/2, height/2, 10, height);
  

      // PLAYER PADDLE
      
      // set the rectangle drawing mode to Center
      rectMode(CENTER);
      // Fill it white
      fill(255);
      // draws a 20x120 rectangle which follows the mouse Y position
      rect(width -20, mouseY, 20, 120);
      // removes stroke from paddle
      noStroke();
 
 
      // COMPUTER PADDLE
 
      // set the rectangle drawing mode to Centre
      rectMode(CENTER);
      // fill it white
      fill(255);
      // draws paddle which will follow the balls position
      rect(20, ballPos, 20, 120);
      // removes stroke from paddle
      noStroke();
      
       
    
      //moves the computer paddle up or down depending on where the ball is
      
      if (ballPos < ballY) {
        ballPos = ballPos + computerSpeed ;
      }
      if (ballPos > ballY) {
        ballPos = ballPos - computerSpeed ;
      }
 
 
      // BALL

      // set the ellipse mode to Centre
      ellipseMode(CENTER);
      fill(255);
      // draw the ball and position it
      ellipse(ballX, ballY, 20, 20);
      // remove the stroke
      noStroke();
 
 
 }
 
      // COLLISION DETECTION //
 
      // PLAYER PADDLE
      
      // if the ball hits the player paddle (mouseY plus and minus half length of the paddle (+- 5px tolerence to prevent ball passing thru)
      // NOTE: the illusion of ball passing thru may occur when ball passes front face of paddle but after tryin mid-paddle, and back of paddle alts, the front face is best option I could find
      
      if (ballX == width -40 && ballY <= mouseY+65 && ballY >= mouseY-65) {
 
        // if ball hits bottom half make ball bounce up
        if (ballY < mouseY) {
          dirX =  -10;
          dirY =  -10;
        }
        // if ball hits top half make ball bounce down
        if (ballY > mouseY) {
          dirX =  -10;
          dirY =  +10;
        }
        // if ball hits centre make ball bounce straight
        if (ballY == mouseY) {
          dirX =  -10;
          dirY = 0;
        }
      }
 
      // COMPUTER PADDLE
 
      // if the ball hits the computer paddle (ballY plus and minus half length of the paddle (+- 5px tolerence to prevent ball passing thru)
      if (ballX == 40 && ballY <= ballPos + 65 && ballY >= ballPos - 65) {
 
        // if ball hits bottom half make ball bounce up
        if (ballY < ballPos) {
          dirX =  10;
          dirY =  - 10;
        }
        // if ball hits top half make ball bounce down
        if (ballY > ballPos) {
          dirX =  10;
          dirY =  + 10;
        }
        // if ball hits centre make ball bounce straight
        if (ballY == ballPos) {
          dirX =  10;
          dirY = 0  ;
        }
      }
      
  //MAKE BALL MOVE

      ballY = ballY + dirY;
      ballX = ballX + dirX;
 
 
      // WALLS
 
      // if ball hits top, bounce back (-10px tolerance for width of ball)
      if ( ballY == 10) {
        dirY =   10;
      }
      // if ball hits bottom, bounce back (-10px tolerance for width of ball)
      if ( ballY == height -10) {
        dirY =  - 10;
      }
 
 
      //SCORING
 
 // ball goes off screen left + time delay NOTE: used this method instead to delay as delay paused the noise and static lines. (SEE UNUSED CODE)
      if (ballX < -400) { 
        
        // if the ball doesn't hit the computer paddle add one to player score
        playerScore ++;
        
  //UNUSED CODE //////////////////////////////////////////////////////////
        // add 1 second delay after a score so the game doesn't resume immediately
       // delay(1000);
  //////////////////////////////////////////////////////////////////////////
       
        //resets the ball to centre
         
        ballX = width/2;
        ballY = height/2;
      }
      if (ballX > width+400) { // ball goes off screen right + time dealy
        // if the ball doesn't hit the player paddle add one to player score
        computerScore ++;
   //UNUSED CODE //////////////////////////////////////////////////////////
        // add 1 second delay after a score so the game doesn't resume immediately
       // delay(1000);
  //////////////////////////////////////////////////////////////////////////       
 
  
        //resets the ball to centre
        ballX = width/2;
        ballY = height/2;
      }
    }
  
    // IF MAN OR MACHINE REACHES 10 END THE GAME
    
    if (playerScore == 10) {
      
      
          //sets the game to over 
      machineWon = false;
      gameOver = true;
      // pause and rewind player1, play player3
      player1.pause();
      player1.rewind();
      player3.play();
      playing = true;
      
    //NOISE  NOTE: the noise/distortions get stuck (uniquely and beautifully every time!) when either Man or Machine Wins. "Mistakism" maybe but I love the mistakism aesthetic
      
  float r =   0; 
  for ( int i = 0; i < in.bufferSize(); i++) {
    r += abs( in.mix.get( i ) ) * 5; //  I appreciate I possibly have a lot of reptition that could/should be made lot more lean..
  }

  tint (55,250);
  image( TVimg, 0, r);
      
      
      //add noise
      
       yoff = yoff + .02;
 float n = noise(yoff) * height;
  stroke(225);
       strokeWeight(random (3));
  line(0, n, width, n);  

      // sets font
      textFont (font2, 30);
      // writes
      text("MACHINE IS DEFEATED!", width/2, height/2);
      textFont (font2, 15);
      // writes reset option
      text("HIT SPACEBAR TO RESET", width/2, height - 200);
      
      // add "static" line
   stroke(125);   
 strokeWeight (random(2));
      line(0,y,width,y);
 y = y + 5;
  if(y > height){
    y = 0;
       // add slight BLUR to this line
    filter(BLUR,0.5); 
}       
 
  }
       
    
    // IF MACHINE SCORES  END THE GAME
    
    if (computerScore == 10) {
      
           //sets the game to over 
            
       machineWon = true;
      gameOver = true;
      //pause and rewind player1, play player2
      player1.pause();
      player1.rewind();
      player2.play();
      playing = true;
      
      //noise
      
          float r =   0; 
  for ( int i = 0; i < in.bufferSize(); i++) {
    r += abs( in.mix.get( i ) ) * 5;
  }

  tint (55,250);
  image( TVimg, 0, r);
      
      
     //noise
      
          yoff = yoff + .02;
         float n = noise(yoff) * height;
        stroke(225);
       strokeWeight(random (3));
        line(0, n, width, n); 
  
   
     
      // sets font
      textFont (font2, 30);
      // writes 
      text("MAN IS DEFEATED!", width/2, height/2);
      textFont (font2, 15);
      // writes reset option
      text("HIT SPACEBAR TO RESET", width/2, height - 200);
      
      //noise

     stroke(125);       
    strokeWeight (random(2));
      line(0,y,width,y);
     y = y + 5;
    if(y > height){
    y = 0;
       // add slight BLUR to this line
    filter(BLUR,0.5);
    }
    }
} 


    void keyPressed(){
    
     if  ((machineWon = false)&& (key==32)){ //reset game when hit space
    
       //pause and rewind player3
        player3.pause();
        player3.rewind();
           
        started = false;
     }
    else if  ((machineWon = true) && (key==32) ){ // reset game when hit spacebar
     
         //pause and rewind player2
        player2.pause();
        player2.rewind();
           
 
        started = false;
     }
    }
    
   
  // close all players and stop
  void stop()
{
  player1.close();
  player2.close();
  player3.close();
  minim.stop();
  super.stop();
}

//GAME OVER


