void keyPressed()
{
  if(gamePlayBool)
  {
    if(key == CODED)
    {
      if(keyCode == RIGHT && brokenGun == false)
      {
        if(currentBullets < maxNumberOfBullets && ammo > 0)
        {
          bullets[currentBullets].x = player.x + playerSize;
          bullets[currentBullets].y = (player.y + playerSize / 2);
          bullets[currentBullets].size = bulletsSize;
          
          gunSound.play(0);
          
          currentBullets++;
          ammo--;
        }
        if(currentBullets >= maxNumberOfBullets)
        {
          currentBullets = 0;
        }
      }
    }
    
    //Pause game
    if(key == 'p' || key == 'P')
    {
      paused = !paused;
    }
    
    //Here, if the player presses certain numbers, something is done with the resources collected by the player
    //Recover ship condition
    if(key == '1' && resources > 2 && shipCondition < 100)
    {
      if(shipCondition < 80)
      {
        shipCondition += 20;
      }
      else
      {
        shipCondition = 100;
      }
      resources -= 3;
    }
    //Add ammo
    if(key == '2' && resources >= 1)
    {
      if(ammo < maxNumberOfBullets - 3)
      {
        ammo += 3;
        resources--;
      }
      else if(ammo < maxNumberOfBullets)
      {
        ammo = maxNumberOfBullets;
        resources--;
      }
    }
    //Repair upDownSwitch/losePower/brokenGun
    if(key == '3'&& resources > 0)
    {
      if(upDownSwitch)
      {
        upDownSwitch = false;
        resources--;
      }
      if(losePower)
      {
        losePower = false;
        playerSpeed += 2;
        resources--;
      }
      if(brokenGun)
      {
        brokenGun = false;
        resources--;
      }
    }
    //Modify the gun to make it a more powerful so the bullets go right through enemies and can destroy more than one
    if(key == '4' && resources > 9 && gunMod == false)
    {
      gunMod = true;
      resources -= 10;
    }
  }
  
  if(waveScreenBool)
  {
    if(key == ' ')
    {
      waveScreenBool = false;
      waveSetup();
      gamePlayBool = true;
    }
    
    //Here, if the player presses certain numbers, something is done with the resources collected by the player
    //Recover ship condition
    if(key == '1' && resources > 2)
    {
      if(shipCondition < 80 && shipCondition < 100)
      {
        shipCondition += 20;
      }
      else
      {
        shipCondition = 100;
      }
      resources -= 3;
    }
    //Add ammo
    if(key == '2' && resources >= 1)
    {
      if(ammo < maxNumberOfBullets - 3)
      {
        ammo += 3;
        resources--;
      }
      else if(ammo < maxNumberOfBullets)
      {
        ammo = maxNumberOfBullets;
        resources--;
      }
    }
    //Repair upDownSwitch/losePower/brokenGun
    if(key == '3'&& resources > 0)
    {
      if(upDownSwitch)
      {
        upDownSwitch = false;
        resources--;
      }
      if(losePower)
      {
        losePower = false;
        playerSpeed += 2;
        resources--;
      }
      if(brokenGun)
      {
        brokenGun = false;
        resources--;
      }
    }
    //Modify the gun to make it a more powerful so the bullets go right through enemies and can destroy more than one
    if(key == '4' && resources > 9 && gunMod == false)
    {
      gunMod = true;
      resources -= 10;
    }
  }
}
