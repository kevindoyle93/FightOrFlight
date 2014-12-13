class Points
{
  float x, y, size;
  
  Points(float x, float y, float size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void display()
  {
    image(pointsImage, x, y);
  }
}
