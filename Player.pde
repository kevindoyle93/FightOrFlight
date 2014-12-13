class Player
{
  float x, y, size;
  
  Player(float x, float y, float size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void display()
  {
    image(playerImage, x, y);
  }
}
  
