String[] myData;
int xPOS = 100;
int yPos = 50;
SoundFile sound;

Scene[] mountain; 
int cols = 5;   
int spacingX = 200;
int spacingY = 200;

void setup() {
  size(1300, 900);
  myData = loadStrings("Dear Data - In Mins.csv");
  sound = new SoundFile(this, "noti.mp3");

  int numDays = myData.length - 1;
  mountain = new Scene[numDays];
  
  String[] headers = split(myData[0], ",");
  String[] categoryNames = subset(headers, 1);

  noStroke();
  
  for (int i = 0; i < numDays; i++) {
    int dataIndex = i + 1; 
    String[] rowStrings = split(myData[dataIndex], ",");
    
    float[] values = new float[categoryNames.length];
    for (int j = 0; j < categoryNames.length; j++) {
      if (j + 1 < rowStrings.length) {
         values[j] = float(rowStrings[j+1]); 
      } else {
         values[j] = 0;
      }
    }

    int col = i % cols;
    int row = i / cols;

    float x = 120 + col * spacingX;
    float y = 100 + row * spacingY;

    mountain[i] = new Scene(x, y);
    mountain[i].setData(rowStrings[0], categoryNames, values);
  }
}

void draw() {
  background(255);
  
  Scene hoveredScene = null;

  for (int i = 0; i < mountain.length; i++) {
    if (mountain[i].mouseIn()){
       hoveredScene = mountain[i];
       if (!sound.isPlaying()) sound.play();
    }
    mountain[i].draw();
  }
  
  if (hoveredScene != null) {
    drawSidebar(hoveredScene);
  }
}

void drawSidebar(Scene s) {
  noStroke();
  fill(248);
  rect(width - 250, 0, 250, height);
  
  fill(0);
  textAlign(LEFT);
  textSize(24);
  text("Details", width - 230, 40);
  
  textSize(16);
  fill(80);
  text("Date: " + formatDatePretty(s.getDate()), width - 230, 75);
  
  textSize(14);
  fill(0);
  text("Top Categories:", width - 230, 115);
  
  Scene.Category[] cats = s.getTopCategories();
  
  int yOff = 150;
  
  for (int i = 0; i < cats.length; i++) {
    
    color c = getCategoryColor(cats[i].name);
    String timeString = formatTime(cats[i].value);
    
    fill(50);
    textSize(12);
    text(cats[i].name, width - 230, yOff);
    
    fill(c); 
    float barWidth = map(cats[i].value, 0, 800, 0, 200);
    if(cats[i].value > 0 && barWidth < 4) barWidth = 4; 
    
    rect(width - 230, yOff + 5, barWidth, 10, 4); 
    
    fill(0);
    textAlign(RIGHT);
    text(timeString, width - 20, yOff);
    textAlign(LEFT);
    
    yOff += 50;
  }
  
  fill(150);
  textSize(12);
  textAlign(CENTER);
  text("Made by Tanzeal Ahmad", width - 125, height - 20);
  textAlign(LEFT);
}

String formatTime(float totalMins) {
  int h = int(totalMins / 60);
  int m = int(totalMins % 60);
  
  if (h > 0) {
    return h + "h " + m + "m";
  } else {
    return m + "m";
  }
}

String formatDatePretty(String rawDate) {
  String[] parts = split(rawDate, "/");
  if (parts.length < 3) {
  return rawDate;
  }
  
  String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
  int mIndex = int(parts[0]) - 1;
  
  if (mIndex < 0 || mIndex > 11) {
  return rawDate;
  }
  
  return parts[1] + " " + months[mIndex] + " " + parts[2];
}

color getCategoryColor(String catName) {
  if (catName.contains("Social")) 
  {return color(235, 87, 87); 
  }
  if (catName.contains("Communication")) {
    return color(242, 153, 74);
  }
  if (catName.contains("Movies")) {
    return color(45, 156, 219);
  }
  if (catName.contains("Music")){
    return color(155, 81, 224); 
  }
  if (catName.contains("Games")) {
    return color(39, 174, 96);     
  }
  if (catName.contains("Creativity")) {
    return color(242, 201, 76);  
  }
  if (catName.contains("Productivity")) {
    return color(52, 73, 94);  }
  if (catName.contains("Others")) {
    return color(149, 165, 166); 
  }
  
  return color(0); 
}
