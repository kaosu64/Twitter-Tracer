void displayTimelineUI()
{
  cp7.addBang("main_menu")
     .setCaptionLabel("main menu")
     .setPosition(260, 10)
     .setSize(300, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp7.getTooltip().register("main_menu","Return to the main menu.");

  cp7.addBang("display_map")
     .setCaptionLabel("display map")
     .setPosition(580, 10)
     .setSize(300, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp7.getTooltip().register("display_map","Display tweets on a map.");
  
  /*
  cp7.addBang("save")
     .setPosition(480, 10)
     .setSize(150, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp7.getTooltip().register("save","Save tweet data to a text file.");
  
  cp7.addBang("load")
     .setPosition(640, 10)
     .setSize(150, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp7.getTooltip().register("load","Loads last saved tweet data.");*/
}

public void display_map()
{
  if (!mapLoaded)
    displaymap();
  mode = 1;
}
