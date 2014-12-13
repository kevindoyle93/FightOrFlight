class Enemy
{
  float x, y, size;
  int type;
  
  Enemy(float x, float y, float size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
    
    //Each new enemy has a chance of inflicting special damage on the player. If the type is 0, it's a normal enemy, 1 means the Up/Down arrows switch, 2 slows the player down,
    //and 3 breaks the players gun
    int typeChance = (int)random(0, 101);
    if(typeChance < 70)
    {
      type = 0;
    }
    else if(typeChance < 80)
    {
      type = 1;
    }
    else if(typeChance < 90)
    {
      type = 2;
    }
    else
    {
      type = 3;
    }
  }
  
  void display()
  {
    image(enemyImage, x, y);
  }
}
