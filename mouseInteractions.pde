void mousePressed()
{
  //Possible mouse insteractions from the splash screen
  if(splashBool)
  {
    //If the mouse is over "Instructions"
    if(mouseX < width / 3 + 100 && mouseX > width / 3 - 100 && mouseY > centY - textHeight && mouseY < centY + textHeight)
    {
      splashBool = false;
      instructionsBool = true;
    }
    //If the mouse is over "Difficulty"
    if(mouseX < width / 3 * 2 + 100 && mouseX > width / 3 * 2 - 100 && mouseY > centY - textHeight && mouseY < centY + textHeight)
    {
      splashBool = false;
      difficultyBool = true;
    }
    //If the mouse is over "Begin"
    if(mouseX < centX + 50 && mouseX > centX - 50 && mouseY > centY + textHeight && mouseY < centY + textHeight * 5)
    {
      splashBool = false;
      levelSetup();
      gamePlayBool = true;
    }
  }
  
  //When in "Instructions"
  if(instructionsBool)
  {
    if(mouseY > centY + centY / 2)
    {
      instructionsBool = false;
      splashBool = true;
    }
  }
  
  //Choosing difficulty
  if(difficultyBool)
  {
    for(int i = 0; i < 3; i++)
    {
      if(mouseX > levelX1 && mouseX < levelX2 && mouseY > levelY1 + (textHeight * 2 * i) && mouseY < levelY2 + (textHeight * 2 * i))
      {
        level = i + 1;
        
        difficultyBool = false;
        splashBool = true;
      }
    }
  }
}
