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
  cp7.getTooltip().register("load","Loads last saved tweet data.");
  */
  
  cp7.addBang("months")
     .setCaptionLabel("show last 12 months")
     .setPosition(130,height-70)
     .setSize(300,30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  
  cp7.addBang("days")
     .setCaptionLabel("show range of 30 days")
     .setPosition(450,height-70)
     .setSize(300,30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  
  Calendar cal = Calendar.getInstance();
  cal.add(Calendar.DATE,-29);
  
  cp7.addTextlabel("labelA")
     .setText("Range starts from:")
     .setPosition(765,height-80)
     .setColorValue(#ffffff)
     .setFont(fontButton);
  
  cp7.addSlider("tlYear")
     .setCaptionLabel("year")
     .setPosition(920,height-80)
     .setSize(100,20)
     .setRange(cal.get(Calendar.YEAR)-1,cal.get(Calendar.YEAR))
     .setValue(cal.get(Calendar.YEAR))
     .setNumberOfTickMarks(2);
  cp7.get(Slider.class, "tlYear").getCaptionLabel().setFont(fontSlider);
  cp7.get(Slider.class, "tlYear").getValueLabel().setFont(fontSlider);
  
  cp7.addSlider("tlMonth")
     .setCaptionLabel("month")
     .setPosition(770,height-50)
     .setSize(100,20)
     .setRange(1,12)
     .setValue(cal.get(Calendar.MONTH)+1)
     .setNumberOfTickMarks(12);
  cp7.get(Slider.class, "tlMonth").getCaptionLabel().setFont(fontSlider);
  cp7.get(Slider.class, "tlMonth").getValueLabel().setFont(fontSlider);
  
  cp7.addSlider("tlDay")
     .setCaptionLabel("day")
     .setPosition(920,height-50)
     .setSize(100,20)
     .setRange(1,31)
     .setValue(cal.get(Calendar.DATE))
     .setNumberOfTickMarks(31);
  cp7.get(Slider.class, "tlDay").getCaptionLabel().setFont(fontSlider);
  cp7.get(Slider.class, "tlDay").getValueLabel().setFont(fontSlider);
}

public void display_map()
{
  if (!mapLoaded)
    displaymap();
  mode = 1;
}

public void months()
{
  graph.setPoints(rtwMonths);
  graph.setLabels(rtwMonthsLabel);
  graph.monthsMode();
}

public void days()
{
  FloatList fl = new FloatList();
  StringList sl = new StringList();
  Calendar c = Calendar.getInstance(),  // search paramter
           cn = Calendar.getInstance();  // counter
  
  // Get start date from slider
  c.set(tlYear, tlMonth-1, tlDay);
  c.add(Calendar.DATE,30);
  cn.set(tlYear, tlMonth-1, tlDay);
  
  // Add first day with year
  fl.append(rtwDates[cn.get(Calendar.MONTH)][cn.get(Calendar.DATE)]);
  sl.append((cn.get(Calendar.MONTH)+1)+"/\n"+(cn.get(Calendar.DATE))
                +"\n"+cn.get(Calendar.YEAR));
  cn.add(Calendar.DATE,1);
  
  // Add the rest of the days
  while (cn.before(c))
  {
    fl.append(rtwDates[cn.get(Calendar.MONTH)][cn.get(Calendar.DATE)]);
    if (cn.get(Calendar.DATE) == 1)  // Add year if first day of month
      sl.append((cn.get(Calendar.MONTH)+1)+"/\n"+(cn.get(Calendar.DATE))
                +"\n"+c.get(Calendar.YEAR));
    else
      sl.append((cn.get(Calendar.MONTH)+1)+"/\n"+(cn.get(Calendar.DATE)));
    cn.add(Calendar.DATE,1);
  }
  
  // Add to graph
  graph.setPoints(fl);
  graph.setLabels(sl);
  graph.daysMode();
}
