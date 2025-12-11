import processing.sound.*;
import java.util.Arrays;
import java.util.Comparator;

String[] myData;
SoundFile sound;
Scene[] mountain; 

int cols;
float spacingX;
float spacingY;
float startX;
float startY;

void setup() {
  fullScreen(); 
  
  myData = loadStrings("Dear Data - In Mins.csv");
  sound = new SoundFile(this, "noti.mp3");

  int numDays = myData.length - 1;
  mountain = new Scene[numDays];
  
  String[] headers = split(myData[0], ",");
  String[] categoryNames = subset(headers, 1);

 
  cols = 7; 
  int rows = ceil((float)numDays / cols);
  
  float availableWidth = width - 250; 
  
  spacingX = availableWidth / (cols + 0.5); 
  spacingY = height / (rows + 0.8); 
  
  startX = spacingX * 0.8; 
  startY = spacingY * 0.8;

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

    float x = startX + col * spacingX;
    float y = startY + row * spacingY;

    mountain[i] = new Scene(x, y);
    mountain[i].setData(rowStrings[0], categoryNames, values);
  }
}

void draw() {
  background(255);
  
  Scene hoveredScene = null;

  for (int i = 0; i < mountain.length; i++) {
    mountain[i].draw();
    
    if (mountain[i].mouseIn()){
       hoveredScene = mountain[i];
       if (!sound.isPlaying()) sound.play();
    }
  }
  
  if (hoveredScene != null) {
    drawSidebar(hoveredScene);
  } else {
    drawDefaultSidebar();
  }
}

void drawSidebar(Scene s) {
  drawSidebarBase();
  
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
  
  drawLegendAndCredits();
}

void drawDefaultSidebar() {
  drawSidebarBase();
  
  fill(150);
  textSize(16);
  textAlign(LEFT);
  text("Hover over a\nmountain to\nsee details.", width - 230, 80);
  
  drawLegendAndCredits();
}

void drawSidebarBase() {
  noStroke();
  fill(248);
  rect(width - 250, 0, 250, height);
}

void drawLegendAndCredits() {
  int legendY = height - 320; 
  
  fill(0);
  textSize(14);
  textAlign(LEFT);
  text("Legend (All Categories):", width - 230, legendY);
  
  String[] allCats = {"Productivity + Work", "Social", "Movies & Videos", "Music", "Communication", "Games", "Creativity + Designing", "Others"};
  
  legendY += 30;
  textSize(11);
  
  for (int i = 0; i < allCats.length; i++) {
    color c = getCategoryColor(allCats[i]);
    
    fill(c);
    rect(width - 230, legendY, 12, 12, 3); 
    
    fill(80);
    text(allCats[i], width - 210, legendY + 10);
    
    legendY += 22;
  }
  
  fill(120);
  textSize(10);
  textAlign(CENTER);
  text("* Center Peak = Highest Time Spent", width - 125, height - 60);

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
  if (parts.length < 3) return rawDate;
  
  String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
  int mIndex = int(parts[0]) - 1;
  
  if (mIndex < 0 || mIndex > 11) return rawDate;
  
  return parts[1] + " " + months[mIndex] + " " + parts[2];
}

color getCategoryColor(String catName) {
  if (catName.contains("Social")) return color(235, 87, 87);       
  if (catName.contains("Communication")) return color(242, 153, 74); 
  if (catName.contains("Movies")) return color(45, 156, 219);      
  if (catName.contains("Music")) return color(155, 81, 224);       
  if (catName.contains("Games")) return color(39, 174, 96);        
  if (catName.contains("Creativity")) return color(242, 201, 76);  
  if (catName.contains("Productivity")) return color(52, 73, 94);  
  if (catName.contains("Others")) return color(149, 165, 166);     
  
  return color(0); 
}
