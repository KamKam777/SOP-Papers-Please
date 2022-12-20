import java.text.SimpleDateFormat;
import java.util.Date;

// Passport variables
int passportPosX, passportPosY; // Variables to store the position of the passport
int passportOffsetX, passportOffsetY; // Variables to store the difference between the mouse position and the passport position when dragging starts

int passportHeight = 300;
int passportWidth = 400;
int passportSpeed = 10;
color passportStampColor = 220;
boolean passportGiven = false;
boolean showStampHereText = true;
color[] colors = {color(255, 0, 0), color(0, 255, 0)};

boolean isDragging; // Variable to store whether the passport is being dragged or not

String passportTitle = "Passport";
String passportStampText = "< STAMP HERE! >";
String currentDate;


// Stamp variables
PImage stampImg;

float stampPosX, stampPosY; // Variables to store the position of the passportstamp
int stampPaddingX = 33;
int stampPaddingY = 10;
int stampHeight;

// Person variables
PImage personImg;

int personPosX;
int personTextPosX;
int personMoveSpeed = 10;

boolean personRejected = false;

String[] dialogues = {"I can't wait to see my family!", "It's really cold out here.", "Hi, how are you doing? Are you having a nice day?", "Be quick, I am running late.", "Ugh finally!"};
int randomIndex = int(random(0, dialogues.length));
String randomDialogue = dialogues[randomIndex];

void drawPassport() {
  // Draw the passport
  fill(242, 238, 203);
  rect(passportPosX, passportPosY, passportWidth, passportHeight, 10); // Draws a rounded rectangle for the passport body

  // Title
  fill(0);
  textAlign(LEFT, TOP); // Aligns the text to the top left corner
  textSize(40);
  text(passportTitle, passportPosX + 20, passportPosY + 10); // Draws the title

  // Date
  textSize(36);
  text(currentDate, passportPosX + 20, passportPosY +80, 180, 110);

  // Stamp area on passport
  fill(passportStampColor);
  stroke(200);
  rect(passportPosX + 20, passportPosY + passportHeight * 0.5, passportWidth - 40, passportHeight / 2.5, 20); // Draws the stamp area

  if (showStampHereText) {
    // Stamp here text
    fill(160);
    textSize(25);
    text(passportStampText, passportPosX + 110, passportPosY + passportHeight * 0.65); // Draws the placeholder text
  }
}

void setup() {
  fullScreen();

  // To get the current date in string format
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  Date date = new Date();
  currentDate = dateFormat.format(date);

  // Set the initial passport position
  passportPosX = width / 2 - passportWidth / 2; // Initialize the x position to the center of the window
  passportPosY = 0; // Initialize the y position to the center of the window

  // Set the initial stamp position
  stampPosX = width / 1.5;
  stampPosY =  height * 0.6;

  stampImg = loadImage("stamp.png"); // Load stamp image
  stampImg.resize(passportWidth - 40, 0);

  stampHeight = stampImg.height - 50;

  personImg = loadImage("character.jpg"); // Load person image
  personImg.resize(300, 0);

  personPosX = width / 2 - 150;
  personTextPosX = width / 2;
}

void draw() {
  background(50);

  if (passportPosY < height * 0.3 && !passportGiven) {
    passportPosY += passportSpeed;
  } else {
    passportGiven = true;
  }

  if (personPosX < width + width * 0.5 && personTextPosX < width + width * 0.5 && !showStampHereText) {
    if (personRejected) {
      personPosX -= personMoveSpeed;
      personTextPosX -= personMoveSpeed;
    } else {
      personPosX += personMoveSpeed;
      personTextPosX += personMoveSpeed;
    }
  }

  fill(255);
  textAlign(CENTER, CENTER); // set text alignment to center
  textSize(48); // set text size to 24 pixels
  text(randomDialogue, personTextPosX, 50);

  image(personImg, personPosX, 110); // Show person
  drawPassport();
  image(stampImg, stampPosX, stampPosY); // Show stamp

  if (isDragging) {
    passportPosX = mouseX + passportOffsetX;
    passportPosY = mouseY + passportOffsetY;

    if (passportPosX > stampPosX - stampPaddingX && passportPosX < stampPosX + stampPaddingX
      && passportPosY > stampPosY - stampHeight - stampPaddingY && passportPosY < stampPosY - stampHeight + stampPaddingY && isDragging) {
      if (showStampHereText) {
        int randomInt = int(random(2));
        if (randomInt == 0) {
          personRejected = true;
        }
        passportStampColor = colors[randomInt]; // Set stamp color to either red or green
        showStampHereText = false;
      }
    }
  }
}

void mousePressed() {
  if (mouseX > passportPosX && mouseX < passportPosX + passportHeight && mouseY > passportPosY && mouseY < passportPosY + passportWidth && passportGiven) {
    passportOffsetX = passportPosX - mouseX;
    passportOffsetY = passportPosY - mouseY;
    isDragging = true;
  }
}

void mouseReleased() {
  isDragging = false;
}
