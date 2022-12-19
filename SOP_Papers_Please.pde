import java.text.SimpleDateFormat;
import java.util.Date;

// Card variables
int cardPosX, cardPosY; // Variables to store the position of the card
int cardOffsetX, cardOffsetY; // Variables to store the difference between the mouse position and the card position when dragging starts

int cardHeight = 300;
int cardWidth = 400;
int cardSpeed = 10;
color cardStampColor = 220;
boolean cardPresented = false;
boolean showStampHereText = true;
color[] colors = {color(255,0,0), color(0,255,0)}; 

boolean isDragging; // Variable to store whether the card is being dragged or not

String passportTitle = "Passport";
String cardStampText = "< STAMP HERE! >";
String currentDate;


// Stamp variables
PImage stampImg;

float stampPosX, stampPosY; // Variables to store the position of the card
int stampPaddingX = 33;
int stampPaddingY = 10;
int stampHeight;

// Person variables
PImage personImg;

int personPosX;
int personTextPosX;
int personMoveSpeed = 10;

boolean personRejected = false;

String[] dialogues = {"I can't wait to see my family!", "It's really cold out here.", "Hi, how are you doing? Are you having a nice day?", "Be quick, I am running late."};
int randomIndex = int(random(0, dialogues.length));
String randomDialogue = dialogues[randomIndex];

void drawCard() {
  // Draw the card
  fill(242, 238, 203);
  rect(cardPosX, cardPosY, cardWidth, cardHeight, 10); // Draw a rounded rectangle for the card body
  
  // Title
  fill(0);
  textAlign(LEFT, TOP); // Align the text to the top left corner
  textSize(40);
  text(passportTitle, cardPosX + 20, cardPosY + 10); // Draw the title
  
  // Date
  textSize(36);
  text(currentDate, cardPosX + 20, cardPosY +80, 180, 110);
  
  // Stamp area on card
  fill(cardStampColor);
  stroke(200);
  rect(cardPosX + 20, cardPosY + cardHeight * 0.5, cardWidth - 40, cardHeight / 2.5, 20); // Draw the stamp area
  
  if (showStampHereText) {
    // Stamp here text
    fill(160);
    textSize(25);
    text(cardStampText, cardPosX + 110, cardPosY + cardHeight * 0.65); // Draw the title 
  }
}

void setup() {
  fullScreen();
  
  // To get the current date in string format
  SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
  Date date = new Date();
  currentDate = dateFormat.format(date);
  
  // Set the initial card position
  cardPosX = width / 2 - cardWidth / 2; // Initialize the x position to the center of the window
  cardPosY = 0; // Initialize the y position to the center of the window
  
  // Set the initial stamp position
  stampPosX = width / 1.5;
  stampPosY =  height * 0.6;
  
  stampImg = loadImage("stamp.png"); // Load stamp image
  stampImg.resize(cardWidth - 40, 0);
  
  stampHeight = stampImg.height - 50;
  
  personImg = loadImage("character.jpg"); // Load person image
  personImg.resize(300, 0);
  
  personPosX = width / 2 - 150;
  personTextPosX = width / 2;
}

void draw() {
  background(50); // Clear the screen 
  
  if (cardPosY < height * 0.3 && !cardPresented) {
    cardPosY += cardSpeed;
  } else {
    cardPresented = true;
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
  drawCard();
  image(stampImg, stampPosX, stampPosY); // Show stamp
  
  // If the card is being dragged, update its position based on the mouse position
  if (isDragging) {
    cardPosX = mouseX + cardOffsetX;
    cardPosY = mouseY + cardOffsetY;
    
    // If the card is in stamp area
    if (cardPosX > stampPosX - stampPaddingX && cardPosX < stampPosX + stampPaddingX 
      && cardPosY > stampPosY - stampHeight - stampPaddingY && cardPosY < stampPosY - stampHeight + stampPaddingY && isDragging) {
        if (showStampHereText) {
          int randomInt = int(random(2));
          if (randomInt == 0) {
            personRejected = true;
          }
          cardStampColor = colors[randomInt]; // Set stamp color to either red or green
          showStampHereText = false;
        }
    }
  }
}

void mousePressed() {
  // If the mouse is pressed inside the card, and the card is already presented, start dragging
  if (mouseX > cardPosX && mouseX < cardPosX + cardHeight && mouseY > cardPosY && mouseY < cardPosY + cardWidth && cardPresented) {
    cardOffsetX = cardPosX - mouseX;
    cardOffsetY = cardPosY - mouseY;
    isDragging = true;
  }
}

void mouseReleased() {
  // When the mouse is released, stop dragging
  isDragging = false;
}
