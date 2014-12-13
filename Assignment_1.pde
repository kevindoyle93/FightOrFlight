import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

/*
  Author: Kevin Doyle
  Date: 02/11/2014
  
  In this game, the player controls a ship. The objective is to shoot enemy ships to earn points while dodging them to stay alive. By colliding with asteroids, the player
  mines that asteroid for resources which they can then use to repair their ship, upgrade their gun, make ammo, etc. The game has a wave structure, where the player navigates
  three waves. The speed of the enemies is determined by what difficulty setting was chosen and increases with each wave. If the player successfully gets to the end of all
  three waves, they win! But if their ship health hits zero before then, they lose.
  
  All music and sounds in the game are original, and URLs for the sprites can be found in a comment next to the declaration of the variable for that sprite.
*/

/*
  Global variables! Here the objects for the player, the enemies, the points, and all of the power-ups are declared and the global variables
  associated with them are listed underneath.
*/

//Dimensions and points
float centX, centY, playWidth, playHeight, playCentX, playCentY, statsHeight;

//Audio
Minim minim;
AudioPlayer backgroundMusic;
AudioPlayer gunSound;
AudioPlayer impactSound;
AudioPlayer resourceSound;

//Images
PImage splashBackground; //found at: http://centurion2.com/XNA/GameProgrammingBasics/GPB100/GPB120/GPB120.php
PImage playerImage; //found at: http://millionthvector.blogspot.ie/p/free-sprites.html
PImage enemyImage; //found at: http://millionthvector.blogspot.ie/2013/12/new-free-spaceship-sprites.html
PImage pointsImage; //found at: http://th04.deviantart.net/fs70/PRE/i/2013/130/f/0/asteroid_stock_3_by_fimar-d64qqfu.png
PImage healthImage; //I drew
PImage ammoImage; //I drew
PImage repairsImage; //I drew
PImage upgradeImage; //I drew

//Player variables
Player player;
int playerSpeed;
float playerSize;

//Enemy variables
Enemy[] enemies;
int maxNumberOfEnemies;
int numberOfEnemies;
int enemySpeed;
float enemySize;
boolean upDownSwitch;
boolean losePower;
boolean brokenGun;


//Points variables
Points[] points;
int maxNumberOfPoints;
int numberOfPoints;
int pointsSpeed;
float pointsSize;

//Bullets
Bullets[] bullets;
int maxNumberOfBullets;
int ammo;
int bulletsSpeed;
float bulletsSize;
boolean gunMod = false;

//General gameplay variables
int shipCondition, score, resources;

/*
  These boolean variables are used in draw() to decide which part of the game should be getting displayed.
*/
boolean splashBool = true;
boolean instructionsBool = false;
boolean difficultyBool = false;
boolean gamePlayBool = false;
boolean waveScreenBool = false;
boolean gameOverBool = false;

void setup()
{
  size(800, 600);
  centX = width / 2;
  centY = height / 2;
  statsHeight = height / 4;
  playWidth = width;
  playHeight = height - statsHeight;
  playCentX = playWidth / 2;
  playCentY = playHeight / 2;
  
  textAlign(CENTER);
  
  //Load music/sounds
  minim = new Minim(this);
  backgroundMusic = minim.loadFile("bgm.mp3");
  backgroundMusic.loop();
  gunSound = minim.loadFile("laser.mp3");
  impactSound = minim.loadFile("boom.mp3");
  resourceSound = minim.loadFile("resource.mp3");
  
  //Load all images
  splashBackground = loadImage("splashBackground.png");
  playerImage = loadImage("player.png");
  enemyImage = loadImage("enemyShip.png");
  pointsImage = loadImage("points.png");
  healthImage = loadImage("health.png");
  ammoImage = loadImage("ammo.png");
  repairsImage = loadImage("repair.png");
  upgradeImage = loadImage("upgrade.png");
  
  playerSize = playHeight / 10;
  
  //Resize all images
  splashBackground.resize(width, height);
  playerImage.resize((int)playerSize, (int)playerSize);
  enemyImage.resize((int)playerSize, (int)playerSize);
  pointsImage.resize((int)playerSize / 3 * 2, (int)playerSize / 3 * 2);
  
  
  player = new Player(0, 0, 0);
  
  //The maximum number of enemies is on wave 3 of level 3 and gives 100 enemies
  maxNumberOfEnemies = 100;
  enemies = new Enemy[maxNumberOfEnemies];
  
  //The maximum number of points is dependant on the amount of enemies
  maxNumberOfPoints = maxNumberOfEnemies / 5;
  points = new Points[maxNumberOfPoints];
  
  //The max amount of bullets is arbitrarily 20. This is just to limit how easy the game could be
  maxNumberOfBullets = 20;
  bullets = new Bullets[maxNumberOfBullets];
  
  //Populate the enemies and points arrays
  for(int i = 0; i < maxNumberOfEnemies; i++)
  {
    enemies[i] = new Enemy(0, 0, 0);
    
    if(i < maxNumberOfPoints)
    {
      points[i] = new Points(0, 0, 0);
    }
    
    if(i < maxNumberOfBullets)
    {
      bullets[i] = new Bullets(0, 0, 0);
    }
  }
}


void draw()
{
  if(splashBool)
  {
    splash();
  }
  if(instructionsBool)
  {
    instructions();
  }
  if(difficultyBool)
  {
    difficulty();
  }
  if(gamePlayBool)
  {
    gamePlay();
  }
  if(waveScreenBool)
  {
    waveScreen();
  }
  if(gameOverBool)
  {
    gameOver();
  }
}

color textColor;
int textHeight;

void splash()
{
   background(splashBackground);
   
   textAlign(CENTER);
   textColor = color(255);
   fill(textColor);
   textHeight = height / 20;
   textSize(textHeight);
   
   text("Fight or Flight", centX, height / 5);
   
   text("Instructions", width / 3, centY);
   
   text("Difficulty", width / 3 * 2, centY);
   
   text("Begin", centX, centY + textHeight * 4);
}

void instructions()
{
  background(splashBackground);
  
  textAlign(LEFT);
  fill(255);
  textSize(playHeight / 25);
  String inStr1 = "Soldier! You are, unthinkably, the last hope we have. Follow these instructions and fly us past our enemies to safety...";
  String inStr2 = "Use the Up/Down arrows to move and the Right arrow to shoot. Watch out for these:";
  String inStr3 = "Your control centre is at the bottom of the screen. When the tiles light up, you have enough resources to perform that task. Press the corresponding number to execute it:";
  String inStr4 = "1. Repair ship, 2. Add ammo, 3. Repair the controls, engine or, gun should they malfuntion, 4. Upgrade your gun";
  String enemyText = "The enemy! Shoot them, and don't get hit. May cause malfuntions";
  String resourceText = "Be sure to collect these as your ship can mine them for materials";
  
  text(inStr1, width / 6, playHeight / 6, width / 3 * 2, playHeight / 5);
  text(inStr2, width / 6, playHeight / 3, width / 3 * 2, playHeight / 2);
  
  image(enemyImage, width / 6, centY - 60);
  text(enemyText, width / 6 + 60, centY - 25);
  image(pointsImage, width / 6, centY);
  text(resourceText, width / 6 + 60, centY + 25);
  
  text(inStr3, width / 6, playHeight - playHeight / 5, width / 3 * 2, playHeight / 4);
  text(inStr4, width / 6, height - statsHeight, width / 3 * 2, playHeight / 2);
  
  textAlign(CENTER);
  text("Click down here to return", centX, height - 15);
  
}


//Difficulty variable, easy is level 1, medium is level 2, hard is level 3
int level = 1;
//Level option box coordinates
float levelX1, levelY1, levelX2, levelY2;

void difficulty()
{
  background(splashBackground);
  textColor = color(255);
  
  text("Choose your preferred difficulty", centX, centY - textHeight * 2);
  
  levelX1 = centX - centX / 2;
  levelY1 = centY;
  levelX2 = centX + centX / 2;
  levelY2 = centY + textHeight + 5;
  
  //Create "transparent boxes" for level selection
  stroke(textColor);
  for(int i = 0; i < 3; i++)
  {
    line(levelX1, levelY1 + (textHeight * 2 * i), levelX2, levelY1 + (textHeight * 2 * i));
    line(levelX1, levelY1 + (textHeight * 2 * i), levelX1, levelY2 + (textHeight * 2 * i));
    line(levelX1, levelY2 + (textHeight * 2 * i), levelX2, levelY2 + (textHeight * 2 * i));
    line(levelX2, levelY1 + (textHeight * 2 * i), levelX2, levelY2 + (textHeight * 2 * i));
  }
  
  text("Easy", centX, centY + textHeight);
  text("Medium", centX, centY + textHeight * 3);
  text("Hard", centX, centY + textHeight * 5);
}

int pointsChance;

void levelSetup()
{
  shipCondition = 100;
  score = 0;
  resources = 5;
  ammo = 10;
  wave = 1;
  
  //Set the sizes of the sprites
  enemySize = playerSize;
  pointsSize = playerSize / 3 * 2;
  bulletsSize = playerSize / 2;
  
  //In order to keep the game interesting, the number and location of points/health/power-ups will be randomised each time.
  //Percentage chance of points spawning:
  pointsChance = 20;
  
  //Set the enemy powers to false
  upDownSwitch = false;
  losePower = false;
  brokenGun = false;
  gunMod = false;
  
  //playerSpeed can change during the game, and shouldn't be reset at each wave, so it can go here
  playerSpeed = 5;
  
  winner = false;
  
  waveSetup();
}

int wave;

void waveSetup()
{
  numberOfEnemies = (level * 10) + (wave * 20);
  numberOfPoints = numberOfEnemies / 5;
  createEnemy = true;
  
  //This is used in pointsUpdate() to display the correct number of points
  currentEnemies = 0;
  currentPoints = 0;
  createPoints = true;
  
  //Same for bullets
  currentBullets = 0;
  
  
  //Initial setup of objects
  //player:
  player.x = playerSize / 2;
  player.y = centY;
  player.size = playerSize;
  
  //enemies:
  for(int i = 0; i < numberOfEnemies; i++)
  {
    enemies[i].x = width + enemySize;
    enemies[i].size = enemySize;
  }
  
  //points:
  for(int i = 0; i < numberOfPoints; i++)
  {
    points[i].x = width + pointsSize;
    points[i].size = pointsSize;
  }
  
  //Set the speeds of the various objects
  enemySpeed = 1 + wave + level;
  pointsSpeed = enemySpeed;
  bulletsSpeed = 5;
}


boolean paused = false;
boolean winner;

void gamePlay()
{
  if(!paused)
  {
    background(splashBackground);
    
    playerUpdate();
    enemiesUpdate();
    pointsUpdate();
    checkCollisions();
    shoot();
    displayStats();
    
    //Check if the player is still alive
    if(shipCondition <= 0)
    {
      gamePlayBool = false;
      gameOverBool = true;
    }
    
    //Check if the current wave has been cleared
    if(enemies[numberOfEnemies - 1].x < 0)
    {
      if(wave < 3)
      {
        wave++;
        gamePlayBool = false;
        waveScreenBool = true;
      }
      else
      {
        winner = true;
        gamePlayBool = false;
        gameOverBool = true;
      }
    }
  }
}

void playerUpdate()
{
  player.display();
  
  if(keyPressed == true)
  {
    if(key == CODED)
    {
      if(!upDownSwitch)
      {
        if(keyCode == UP && player.y > 0)
        {
          player.y -= playerSpeed;
        }
        if(keyCode == DOWN && player.y < playHeight - playerSize)
        {
          player.y += playerSpeed;
        }
      }
      else
      {
        if(keyCode == UP && player.y < playHeight - playerSize)
        {
          player.y += playerSpeed;
        }
        if(keyCode == DOWN && player.y > 0)
        {
          player.y -= playerSpeed;
        }
      }
    }
  }
}


int currentBullets;
int currentEnemies;
boolean createEnemy = true; //Decide whether or not a new enemy has to spawn

void enemiesUpdate()
{
  if(createEnemy)
  {
    enemies[currentEnemies].y = (int)random(0, playHeight - enemySize);
    currentEnemies++;
    createEnemy = false;
  }
  
  //Display current enemies
  for(int i = 0; i < currentEnemies; i++)
  {  
    enemies[i].x -= enemySpeed;
    enemies[i].display();
  }
  
  if(enemies[currentEnemies - 1].x < width - enemySize * 2 && currentEnemies < numberOfEnemies)
  {
    createEnemy = true;
    chance = (int)random(1, 101);
  }
}

int currentPoints;
boolean createPoints = true;
int chance;

void pointsUpdate()
{
  if(createPoints)
  {
    points[currentPoints].y = (int)random(0, playHeight - pointsSize);
    currentPoints++;
    createPoints = false;
  }
  
  //Display current points
  for(int i = 0; i < currentPoints; i++)
  {
    points[i].x -= pointsSpeed;
    points[i].display();
  }
  
  if(points[currentPoints - 1].x < width - pointsSize * 4 &&  currentPoints < numberOfPoints)
  {
    //Check the chance of getting more points
    if(pointsChance >= chance)
    {
      createPoints = true;
    }
    //reset chance so no more points are spawned before they're needed 
    chance = 100;
  }
}


void checkCollisions()
{
  //Player sides:
  int playerLeftSide = (int)player.x;
  int playerRightSide = (int)player.x + (int)enemySize;
  int playerTop = (int)player.y;
  int playerBottom = (int)player.y + (int)enemySize;
  
  //Collisions with enemies:
  for(int i = 0; i < currentEnemies; i++)
  {
    int enemyLeftSide = (int)enemies[i].x;
    int enemyRightSide = (int)enemies[i].x + (int)enemySize;
    int enemyTop = (int)enemies[i].y;
    int enemyBottom = (int)enemies[i].y + (int)enemySize;
    
    if((enemyLeftSide <= playerRightSide && enemyRightSide >= playerRightSide) || (enemyLeftSide <= playerLeftSide && enemyRightSide >= playerLeftSide))
    {
      if(enemyBottom >= playerTop && enemyTop <= playerTop || enemyBottom >= playerBottom && enemyTop <= playerBottom)
      {
        shipCondition -= 20;
        enemies[i].x = 0 - enemySize;
        impactSound.play(0);
        
        //Check to see if a ship problem occurs
        if(enemies[i].type == 1 && upDownSwitch == false)
        {
          upDownSwitch = true;
        }
        if(enemies[i].type == 2 && losePower == false)
        {
          losePower = true;
          playerSpeed -= 2;
        }
        if(enemies[i].type == 3 && brokenGun == false)
        {
          brokenGun = true;
        }
      }
    }
    
    //Collisions between bullets and enemies
    for(int j = 0; j < currentBullets; j++)
    {
      int bulletsRightSide = (int)bullets[j].x + (int)bullets[j].size;
      
      if(bulletsRightSide >= enemyLeftSide && bulletsRightSide < enemyRightSide && bullets[j].y >= enemyTop && bullets[j].y <= enemyBottom)
      {
        if(!gunMod)
        {
          bullets[j].y = height + bulletsSize;
        }
        enemies[i].x = 0 - enemySize;
        score++;
        
        impactSound.play(0);
      } 
    }
    
  }
  
  //Collisions with points:
  for(int i = 0; i < currentPoints; i++)
  {
    int pointsLeftSide = (int)points[i].x;
    int pointsRightSide = (int)points[i].x + (int)pointsSize;
    int pointsTop = (int)points[i].y;
    int pointsBottom = (int)points[i].y + (int)pointsSize;
    
    if((pointsLeftSide <= playerRightSide && pointsRightSide >= playerRightSide) || (pointsLeftSide <= playerLeftSide && pointsRightSide >= playerLeftSide))
    {
      if(pointsBottom >= playerTop && pointsTop <= playerTop || pointsBottom >= playerBottom && pointsTop <= playerBottom || (pointsTop >= playerTop && pointsBottom <= playerBottom))
      {
        //add the asteroid to the resources to make it available for making ammo, etc.
        if(resources < 30)
        {
          resources++;
        }
        points[i].x = 0 - pointsSize;
        resourceSound.play(0);
      }
    }
  }
}


void shoot()
{ 
  for(int i = 0; i < currentBullets; i++)
  {
    bullets[i].x += bulletsSpeed;
    bullets[i].display();
  }
}


void displayStats()
{
  stroke(140, 0, 0);
  fill(140, 0, 0);
  rect(0, playHeight, width, height - playHeight);
  
  fill(255);
  textSize(20);
  
  if(resources > 2)
  {
    noTint();
  }
  else
  {
    tint(128);
  }
  image(healthImage, 10, playHeight + 50);
  text("1", 30, playHeight + 30);
  
  if(resources >= 1)
  {
    noTint();
  }
  else
  {
    tint(128);
  }
  image(ammoImage, 70, playHeight + 50);
  text("2", 90, playHeight + 30);
  
  if(resources > 0 && (upDownSwitch == true || losePower == true || brokenGun == true))
  {
    noTint();
  }
  else
  {
    tint(128);
  }
  image(repairsImage, 130, playHeight + 50);
  text("3", 150, playHeight + 30);
  
  if(resources > 9)
  {
    noTint();
  }
  else
  {
    tint(128);
  }
  image(upgradeImage, 190, playHeight + 50);
  text("4", 210, playHeight + 30);
  noTint();
  
  //Display current ship condition
  if(shipCondition > 40)
  {
    text("Ship health: " + shipCondition, centX, playHeight + statsHeight / 3);
  }
  else if(shipCondition > 20)
  {
    fill(170, 170, 0);
    text("Ship health: " + shipCondition, centX, playHeight + statsHeight / 3);
  }
  else
  {
    fill(255, 0, 0);
    text("Ship health: " + shipCondition, centX, playHeight + statsHeight / 3);
  }
  
  fill(255);
  text("Ammo: " + ammo, centX, playHeight + statsHeight / 2);
  text("Resources: " + resources, centX, playHeight + statsHeight / 3 * 2);
  
  textSize(40);
  text("Score: " + score, width - centX / 2, height - statsHeight / 2);
}


void waveScreen()
{
  background(splashBackground);
  
  fill(255);
  textAlign(CENTER);
  textSize(playHeight / 15);
  text("Get ready for wave " + wave, playCentX, playCentY);
  textSize(playHeight / 20);
  text("You can use available resources here", playCentX, playCentY + playHeight / 15);
  text("Press space to begin the next wave", playCentX, playCentY + playHeight / 8);
  
  displayStats();
}

/*----------------------------------------------------------------------------------
                        END OF GAMEPLAY METHODS
----------------------------------------------------------------------------------*/

void gameOver()
{
  background(splashBackground);
  
  textAlign(CENTER);
  textSize(50);
  
  if(!winner)
  {
    text("Game Over!", centX, centY - 50);
    textSize(30);
    text("Press space to return to the main menu", centX, centY);
    if(keyPressed)
    {
      if(key == ' ')
      {
        gameOverBool = false;
        splashBool = true;
      }
    }
  }
  else
  {
    text("You Win!", centX, centY - 50);
    textSize(40);
    text("Your score was: " + score, centX, centY);
    textSize(30);
    text("Press space to return to the main menu", centX, centY + 40);
    if(keyPressed)
    {
      if(key == ' ')
      {
        gameOverBool = false;
        splashBool = true;
        winner = false;
      }
    }
  }
}
