
int totalWeeks = 12; 
String[] activities = {"Instagram", "Moodle", "YouTube", "TikTok", "WhatsApp", "Movie"};
float[][] weeklyData = new float[totalWeeks][activities.length];
float[] monthlyTotals = new float[3];
float[] totalPerActivity = new float[activities.length];
String[] months = {"September", "October", "November"};
int[] weeksInMonths = {4, 4, 4};

int animationSpeed = 5; 


void setup() {
  size(1200, 800);
  frameRate(animationSpeed);


  float[][] realWeeklyData = {
  // September
  {24, 18, 10, 5, 8, 23}, // Week 1
  {24, 19, 10, 4.5, 7.5, 24},  // Week 2
  {18, 17, 10, 4, 8, 20}, // Week 3
  {20, 19, 10, 5.5, 9, 20},// Week 4

  // October
  {18, 17, 11, 5.5, 9, 25},  // Week 5
  {21, 20, 9, 6, 12, 25}, // Week 6
  {17, 19, 8, 4.5, 11, 28}, // Week 7
  {21, 15, 9, 5, 10, 23}, // Week 8

  // November
  {20, 17, 11, 5, 10, 22},  // Week 9
  {22, 16, 8, 5, 11, 24}, // Week 10
  {23, 20, 10, 5.5, 9, 23}, // Week 11
  {19, 18, 12, 5.5, 11, 23} // Week 12
};

  for (int i = 0; i < realWeeklyData.length; i++) {
    for (int j = 0; j < realWeeklyData[i].length; j++) {
      weeklyData[i][j] = realWeeklyData[i][j];
      totalPerActivity[j] += realWeeklyData[i][j];
    }
    int monthIndex = getMonthIndex(i);
    monthlyTotals[monthIndex] += sum(realWeeklyData[i]);
  }
}


void draw() {
  background(255);

  if (frameCount <= totalWeeks) {
    
    int weekIndex = frameCount - 1;
    drawHistogram(weekIndex);
  } else {
    
    drawSummary();
  }
}



int getMonthIndex(int weekIndex) {
  int weekCounter = 0;
  for (int i = 0; i < months.length; i++) {
    weekCounter += weeksInMonths[i];
    if (weekIndex < weekCounter) {
      return i;
    }
  }
  return 0;
}


void drawHistogram(int weekIndex) {
  int weekNumber = weekIndex + 1;
  int monthIndex = getMonthIndex(weekIndex);
  String date = months[monthIndex] + ", Week " + (weekNumber - sum(weeksInMonths, monthIndex));

  fill(0);
  textSize(20);
  textAlign(CENTER);
  text("Weekly Digital Time Usage", width / 2, 40);
  text(date, width / 2, 70);

  float barWidth = width / (activities.length + 3);
  float maxHours = 30; 

  for (int i = 0; i < activities.length; i++) {
    float barHeight = map(weeklyData[weekIndex][i], 0, maxHours, 0, height - 200);
    fill(50, 150, 250);
    rect((i + 1) * barWidth, height - barHeight - 150, barWidth - 10, barHeight);

    fill(0);
    textSize(12);
    textAlign(CENTER);
    text(activities[i], (i + 1) * barWidth + barWidth / 2, height - 100);
    text(nf(weeklyData[weekIndex][i], 1, 1) + "h", (i + 1) * barWidth + barWidth / 2, height - barHeight - 170);
  }
}


void drawSummary() {
  background(255);


  textSize(20);
  fill(0);
  textAlign(CENTER);
  text("Monthly Digital Time Usage", width / 2 - 250, 40);

  float maxHours = max(monthlyTotals);
  float graphHeight = 300;
  float graphWidth = 400; 
  float xStart = 100;
  float yStart = height - 250;


  stroke(0);
  line(xStart, yStart, xStart, yStart - graphHeight); 
  line(xStart, yStart, xStart + graphWidth, yStart); 


  stroke(50, 150, 250);
  for (int i = 0; i < months.length; i++) {
    float x = map(i, 0, months.length - 1, xStart, xStart + graphWidth);
    float y = map(monthlyTotals[i], 0, maxHours, yStart, yStart - graphHeight);


    fill(50, 150, 250);
    ellipse(x, y+30, 8, 8);

    fill(0);
    textAlign(CENTER);
    text(months[i], x, yStart + 20);
    text(nf(monthlyTotals[i], 1, 1) + "h", x, y - 10);

 
    if (i > 0) {
      float prevX = map(i - 1, 0, months.length - 1, xStart, xStart + graphWidth);
      float prevY = map(monthlyTotals[i - 1], 0, maxHours, yStart, yStart - graphHeight);
      line(prevX, prevY +30, x, y+30);
    }
  }

  
  fill(0);
  textAlign(LEFT);
  textSize(25); 
  float textHeight = textAscent() + textDescent(); 
  float lineSpacing = textHeight * 1.5; 

  text("Total Time by Activity:", width - 450, height - 500);

  for (int i = 0; i < activities.length; i++) {
    float yPosition = height - 480 + i * lineSpacing; 
    text("\n" +activities[i] + ": " + nf(totalPerActivity[i], 1, 1) + "h", width - 450, yPosition);
  }
}



float sum(float[] arr) {
  float total = 0;
  for (float val : arr) {
    total += val;
  }
  return total;
}

int sum(int[] arr, int endIndex) {
  int total = 0;
  for (int i = 0; i < endIndex; i++) {
    total += arr[i];
  }
  return total;
}
