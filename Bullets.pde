class Bullets
{
  float x, y, size;
  
  Bullets(float x, float y, float size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void display()
  {
    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(x, y, size, 1);
  }
}
