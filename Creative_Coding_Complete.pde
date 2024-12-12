// Настройки
int totalWeeks = 12; // 3 месяца
String[] activities = {"Instagram", "Moodle", "YouTube", "TikTok", "WhatsApp", "Movie"};
float[][] weeklyData = new float[totalWeeks][activities.length];
float[] monthlyTotals = new float[3];
float[] totalPerActivity = new float[activities.length];
String[] months = {"September", "October", "November"};
int[] weeksInMonths = {4, 4, 4};

int animationSpeed = 5; // Скорость анимации (FPS)

// Инициализация
void setup() {
  size(1200, 700);
  frameRate(animationSpeed);

  // Загрузка реальных данных
  float[][] realWeeklyData = {
  // Сентябрь (4 недели)
  {12, 15, 8, 10, 7, 16}, // Неделя 1
  {10, 13, 9, 8, 6, 12},  // Неделя 2
  {14, 14, 10, 9, 8, 14}, // Неделя 3
  {13, 16, 12, 11, 9, 18},// Неделя 4

  // Октябрь (4 недели)
  {10, 12, 8, 6, 5, 14},  // Неделя 5
  {12, 14, 11, 7, 6, 13}, // Неделя 6
  {11, 13, 12, 8, 7, 16}, // Неделя 7
  {14, 15, 13, 9, 9, 18}, // Неделя 8

  // Ноябрь (4 недели)
  {12, 14, 9, 7, 6, 14},  // Неделя 9
  {13, 16, 10, 8, 7, 15}, // Неделя 10
  {11, 14, 12, 9, 8, 13}, // Неделя 11
  {15, 17, 13, 10, 9, 18} // Неделя 12
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
    // Анимация гистограммы
    int weekIndex = frameCount - 1;
    drawHistogram(weekIndex);
  } else {
    // Сводная информация
    drawSummary();
  }
}

// Генерация данных


// Индекс месяца по индексу недели
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

// Рисование гистограммы
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
  float maxHours = 20; // Максимум часов в неделю на одну активность

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

// Рисование сводной информации
void drawSummary() {
  background(255);

  // Линейная диаграмма
  textSize(20);
  fill(0);
  textAlign(CENTER);
  text("Monthly Digital Time Usage", width / 2 - 250, 40);

  float maxHours = max(monthlyTotals);
  float graphHeight = 300;
  float graphWidth = 400; // Компактная диаграмма
  float xStart = 100;
  float yStart = height - 250;

  // Оси
  stroke(0);
  line(xStart, yStart, xStart, yStart - graphHeight); // Вертикальная ось
  line(xStart, yStart, xStart + graphWidth, yStart); // Горизонтальная ось

  // Линии и точки
  stroke(50, 150, 250);
  for (int i = 0; i < months.length; i++) {
    float x = map(i, 0, months.length - 1, xStart, xStart + graphWidth);
    float y = map(monthlyTotals[i], 0, maxHours, yStart, yStart - graphHeight);

    // Точки
    fill(50, 150, 250);
    ellipse(x, y+30, 8, 8);

    // Значения
    fill(0);
    textAlign(CENTER);
    text(months[i], x, yStart + 20);
    text(nf(monthlyTotals[i], 1, 1) + "h", x, y - 10);

    // Соединяющие линии
    if (i > 0) {
      float prevX = map(i - 1, 0, months.length - 1, xStart, xStart + graphWidth);
      float prevY = map(monthlyTotals[i - 1], 0, maxHours, yStart, yStart - graphHeight);
      line(prevX, prevY +30, x, y+30);
    }
  }

  // Список активностей с увеличением шрифта и межстрочным расстоянием
  fill(0);
  textAlign(LEFT);
  textSize(25); // Увеличиваем размер шрифта для списка
  float textHeight = textAscent() + textDescent(); // Определяем высоту строки
  float lineSpacing = textHeight * 1.5; // Устанавливаем расстояние между строками

  text("Total Time by Activity:", width - 450, height - 500);

  for (int i = 0; i < activities.length; i++) {
    float yPosition = height - 480 + i * lineSpacing; // Используем custom spacing
    text("\n" +activities[i] + ": " + nf(totalPerActivity[i], 1, 1) + "h", width - 450, yPosition);
  }
}

  // Список активностей



  

// Суммирование
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
