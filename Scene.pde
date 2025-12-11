class Scene {

  private float x;
  private float y;
  private float radius = 75;
  private boolean mouseIn = false;
  
  private String dateLabel = "";
  private Category[] topCategories = new Category[5];

  Scene(float x, float y) {
    this.x = x;
    this.y = y;
    for (int i=0; i<5; i++) topCategories[i] = new Category("", 0);
  }
  
  public void setData(String date, String[] headers, float[] values) {
    this.dateLabel = date;
    
    Category[] allData = new Category[headers.length];
    
    for(int i = 0; i < headers.length; i++) {
       if (i < values.length) {
         allData[i] = new Category(headers[i], values[i]); 
       } else {
         allData[i] = new Category(headers[i], 0);
       }
    }
    
    Arrays.sort(allData, new Comparator<Category>() {
      public int compare(Category c1, Category c2) {
        return Float.compare(c2.value, c1.value);
      }
    });
    
    for (int i = 0; i < 5; i++) {
      if (i < allData.length) {
        topCategories[i] = allData[i];
      }
    }
  }

  public Category[] getTopCategories() {
    return topCategories;
  }
  
  public String getDate() {
    return dateLabel;
  }

  void draw() {
    isMouseIn();
    
    pushMatrix();
    translate(x, y);
    drawScene(1);
    popMatrix();
  }

  private void drawScene(float s) {
    scale(s);
    float cx = 0;
    float cy = 0;
    
    float maxH = 220; 
    float maxValRoot = sqrt(800);
    
    float h1 = (topCategories[0].value > 0) ? map(sqrt(topCategories[0].value), 0, maxValRoot, 20, maxH) : 0;
    float h2 = (topCategories[1].value > 0) ? map(sqrt(topCategories[1].value), 0, maxValRoot, 20, maxH * 0.9) : 0;
    float h3 = (topCategories[2].value > 0) ? map(sqrt(topCategories[2].value), 0, maxValRoot, 20, maxH * 0.9) : 0;
    float h4 = (topCategories[3].value > 0) ? map(sqrt(topCategories[3].value), 0, maxValRoot, 20, maxH * 0.7) : 0;
    float h5 = (topCategories[4].value > 0) ? map(sqrt(topCategories[4].value), 0, maxValRoot, 20, maxH * 0.7) : 0;

    float peakY = cy + 100 - h1;
    float sunY = peakY - 30; 

    float hoverOffset = mouseIn ? -15 : 0;

    if (!mouseIn) {
      fill(10, 90, 120, 80);
      
      triangle(cx, cy + 100 - h1, cx-50, cy+100, cx+50, cy+100);
      triangle(cx-35, cy + 100 - h2, cx-50, cy+100, cx-25, cy+100);
      triangle(cx+35, cy + 100 - h3, cx+50, cy+100, cx+25, cy+100);
      triangle(cx-50, cy + 100 - h4, cx-75, cy+100, cx-25, cy+100);
      triangle(cx+50, cy + 100 - h5, cx+25, cy+100, cx+75, cy+100);

      fill(0, 0, 0, 25);
      circle(cx, sunY + hoverOffset, radius);
      circle(cx, sunY + hoverOffset, radius * 0.75);
      
    } else {
      fill(245, 167, 90);
      circle(cx, sunY + hoverOffset, radius);
      fill(0, 0, 0, 40);
      circle(cx, sunY + hoverOffset, radius * 0.75);
      
      fill(10, 90, 120); 
      triangle(cx, cy + 100 - h1, cx-50, cy+100, cx+50, cy+100);
      
      fill(30, 100, 180); 
      triangle(cx-50, cy + 100 - h4, cx-75, cy+100, cx-25, cy+100); 
      triangle(cx+50, cy + 100 - h5, cx+25, cy+100, cx+75, cy+100); 
      
      fill(60, 100, 180); 
      triangle(cx-35, cy + 100 - h2, cx-50, cy+100, cx-25, cy+100);
      triangle(cx+35, cy + 100 - h3, cx+50, cy+100, cx+25, cy+100);
    }
  }

  private void isMouseIn() {
    float d = dist(mouseX, mouseY, x, y + 50);
    if (d < 85) {
      mouseIn = true;
    } else {
      mouseIn = false;
    }
  }
  
  public boolean mouseIn(){
    return mouseIn;
  }
  
  class Category {
    String name;
    float value;
    
    Category(String n, float v) {
      name = n;
      value = v;
    }
  }
}
