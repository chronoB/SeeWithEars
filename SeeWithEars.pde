/**
 * See With Ears. A project for InfA - WiSe 2017/2018
 * Program that generates an auditive representation of a given image
 * The image can be varied. The user can choose between three modes:
 * WEBCAM: captures an image from the default webcam of the computer.
 * CHOOSE: The user can choose an image from the filesystem.
 * FIXED: A random image is choosen from a set of fixed test pictures.
 * @author Finn Bayer 15-12-2017
**/
import controlP5.*;
//#######################################
//You can change these variables to change the behaviour of the auditive representation if you want to.


/**
 * This sets the playtime of the tone in ms.
 * It also affects the framerate. The framerate is 1000/DELAYTIME.
 * Default: 2000
**/
private final int DELAYTIME = 2000;

/**
 * This sets the order of the hilbert curve that is used to sort the pixels of an image.
 * The main impact for the user is the number of oscillators that depends heavily on the hilbert order.
 * The higher the order of the hilbert curve, the higher is the resolution of the representation/more oscillators
 * Choose a value of 1 (4 Oscs), 2 (16) or 3 (64).
 * The maximum resolution is 64 oscs (a higher order just adds multiple oscs with the same frequencys).
 * This maximum is set because the calculation costs is rising exponentially and 64 was a tradeoff between an "high" resolution and small calculation costs.
 * Default: 1
**/
private final int HILBERTORDER = 1;
//#######################################


/**
 * The Object that implements the gui buttons
**/
private ControlP5 p5;

/**
 * Webcam Object
*/
private WebcamCapture wc;

/**
 *The Variables for the state Machine
**/
private int state;
/**
 *The Variables for the state Machine
**/
private final int MENU = 0;
/**
 *The Variables for the state Machine
**/
private final int WEBCAM = 1;
/**
 *The Variables for the state Machine
**/
private final int CHOOSE = 2;
/**
 *The Variables for the state Machine
**/
private final int FIXED = 3;

/**
 * Font for the Buttons.
 */
private PFont fontButton;
/**
 * Font for the Menu.
 */
private PFont fontMenu;

/**
 * The button lets the program swap back to the menu
 **/
Button backButton;
/**
 * The webcam button lets the program swap to the webcam view
 **/
Button webcamButton;
/**
 * The choose button lets the program swap to the choosePicture view
 **/
Button chooseButton;
/**
 * The fixed button lets the program swap to the fixedPicture view
 **/
Button fixedButton;

/**
 * The SoundProcessing object is used to initialize the sine oscillators and play them.
*/
private SoundProcessing sp;
/**
 * The Hilbert object is used to sort the pixels in the order of the hilbert curve
*/
private Hilbert hf;
/**
 * The widthHeight is the square root of the resolution of the auditive representation. 
*/
private int widthHeight;

/**
 * The picture that is used to calculate the auditive representation
*/
private PImage picture;
/**
 * The Image that is used to be displayed (same as picture, only resized differently)
**/
private PImage displayImage;
/**
 * The filePath that is used when the user chooses a picture
*/
private String filePath;

/**
 * Starting point of the program.
 * It sets the fonts and initializes the buttons.
 * Additionally the used objects are initialized and the resolution of the auditive representation is calculated.
**/
void setup() {
  size(640, 600);

  //Setup the fonts
  this.fontButton = createFont("Iceland-Regular.ttf", 32);
  this.fontMenu = createFont("Iceland-Regular.ttf", 120);
  textFont(fontMenu);

  //setup the buttons
  this.p5  = new ControlP5(this);
  createButtons();

  //Initialize the variables 
  this.sp = new SoundProcessing();
  this.hf = new Hilbert(HILBERTORDER);
  this.widthHeight = (int) Math.pow(2, this.hf.getHilbertOrder());

  //initializing the Webcam
  this.wc = new WebcamCapture();
  this.wc.initWebcam();
  this.state = MENU;
}
/**
 * Displays the image according to the statemachine that is implemented inside. It is connected to the buttons.
 **/
void draw() {
  //don't do anything while the sound is playing but keep the button responsive
  if (this.sp.isPlaying()) return;

  background(0);

  //Statemachine to switch between the different modes
  switch (this.state) {
  case MENU:
    menuSetup();
    return;
  case WEBCAM:
    loadWebcamImage();
    break;
  case CHOOSE:
    loadChoosePicture();
    break;
  case FIXED:
    loadFixedPicture();
    break;
  default:
    break;
  }
  //Setup the line
  stroke(255);
  line(0, height-120, width, height-120);
  //run the calculation
  run();
  //play the sound and start the thread that is stopping the sound later on.
  if (this.picture != null && this.state != MENU) {
    this.sp.play();
    thread("pause");
  }
}
/**
 * Function to stop the oscillators from playing after a set period of time
 **/
public void pause() {
  delay(DELAYTIME);
  this.sp.pause();
}
/**
 * Sorting the pictures according to the hilbert curve and calculating the auditive representation.
 **/
private void run() {
  //Use new PImage object for the image display. use the clone method because otherwise some sort of pointer to the picture object remains and messes up the audiitive representation when resizing the displayImage.
  this.displayImage = new PImage();
  try {
    this.displayImage = (PImage)this.picture.clone();
  }
  catch(Exception e) {
  }
  this.displayImage.resize(width, height-120);
  image(this.displayImage, 0, 0);
  //resize/downscale the image for the auditive representation
  this.picture.resize(widthHeight, widthHeight);

  //Arrange the pixels of the image according to the hilbert curve
  float[] sortedPixels = new float[this.picture.pixels.length];
  sortedPixels = this.hf.hilbertSort(this.picture.pixels, sortedPixels, 0, this.picture.height-1, this.picture.width);

  //process the pixels to sound
  this.sp.processPixels(sortedPixels);
}

/**
 * Function that displays the Menuscreen
 **/
private void menuSetup() {
  textAlign(CENTER, BOTTOM);
  text("MENU", (width/2), height/2);
}
/**
 * fetches the image from the webcam
 **/
private void loadWebcamImage() {
  //fetch the new image
  this.picture = this.wc.getImage();
}

/**
 * Implements the user dialog that is used to choose an image from the filesystem.
 **/
private void loadChoosePicture() {
  if (this.picture==null) {
    selectInput("Select a file to process:", "fileSelected");
    while (this.picture ==null) {
      if (this.filePath != null) this.picture = loadImage(this.filePath);
      delay(100);
    }
  } 
  this.picture = loadImage(this.filePath);
}

/** 
 * Loads an image from a set of preset images
 **/
private void loadFixedPicture() {
  this.picture = loadImage("data/bild"+str(floor(random(1, 5)))+".jpg");
}

/**
 * Function to load the selected image into the variables for the ChoosePictureApp.
 * @param selection The File that was selected by the user.
 +*/
public void fileSelected(File selection) {
  if (selection == null) {
    throw new NullPointerException();
  } else {
    this.filePath = selection.getPath();
  }
}

/**
 * Resets the critical variable after a statechange
 **/
public void cleanUp() {
  this.picture = null;
  this.filePath = null;
  this.wc.closeWebcam();
}

/**
 * Initializes the different Buttons in the gui
 **/
private void createButtons() {
  int buttonWidth = 130;
  int buttonHeight = 30;

  backButton = p5.addButton("back")
    .setPosition(width-120, height-75)
    .setSize(buttonWidth-30, buttonHeight)
    .setFont(fontButton);
  webcamButton = p5.addButton("webcam")
    .setPosition(20, height-75)
    .setSize(buttonWidth, buttonHeight)
    .setFont(fontButton);
  chooseButton = p5.addButton("choose")
    .setPosition(170, height-75)
    .setSize(buttonWidth, buttonHeight)
    .setFont(fontButton);
  fixedButton = p5.addButton("fixed")
    .setPosition(320, height-75)
    .setSize(buttonWidth, buttonHeight)
    .setFont(fontButton);
}

/**
* The handler for the webcam button.
*/
public void webcam() {
  this.state = WEBCAM;
  this.cleanUp();
  this.wc.openWebcam();
}

/**
* The handler for the back button.
*/
public void back() {
  this.state = MENU;
  this.cleanUp();
}

/**
* The handler for the fixed button.
*/
public void fixed() {
  this.state = FIXED;
  this.cleanUp();
}

/**
* The handler for the choose button.
*/
public void choose() {
  this.state = CHOOSE;
  this.cleanUp();
}