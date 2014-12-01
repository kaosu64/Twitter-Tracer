void displayMapUI()
{
  cp6.addBang("main_menu")
     .setPosition(10, 10)
     .setSize(150, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp6.getTooltip().register("main","Return to the main menu.");

  cp6.addBang("display_timeline")
     .setPosition(170, 10)
     .setSize(150, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp6.getTooltip().register("timeline","Display tweets in a timeline.");
  
  cp6.addBang("save")
     .setPosition(480, 10)
     .setSize(150, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp6.getTooltip().register("save","Save map data to a text file.");
  
  cp6.addBang("load")
     .setPosition(640, 10)
     .setSize(150, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp6.getTooltip().register("load","Loads last saved map data.");
}

public void main_menu()
{
  mode = 0;
}

public void display_timeline()
{
  
}
