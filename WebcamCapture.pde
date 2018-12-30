import com.github.sarxos.webcam.Webcam;
import com.github.sarxos.webcam.WebcamPanel;
import com.github.sarxos.webcam.WebcamResolution;
import java.awt.image.BufferedImage;
import java.awt.Dimension;
/**
 * Class that is used to initialize the Webcam and to fetch the images for the application.
 * It uses the java library from sarxos because the processing webcam library wouldn't work with my webcam.
 * @author Finn Bayer 29-11-2017
 **/
public class WebcamCapture {

  /**
   * The webcam Object that is used to fetch the images.
  **/
  private Webcam webcam;

  /**
   * Initializing the default webcam.
  **/
  public void initWebcam() {
    webcam = Webcam.getDefault();
    webcam.setViewSize(new Dimension(width,height-120));
  }

  /**
   * Fetches the rgb-image of the webcam and returns it as a PImage Object.
   * @return PImage The current rgb-image from the webcam 
  **/
  public PImage getImage() {
    //get the new image from the webcam
    BufferedImage image = webcam.getImage();
    //convert the Image to a PImage
    PImage picture = new PImage(image.getWidth(), image.getHeight());
    for (int i = 0; i< image.getHeight(); i++) {
      for (int j = 0; j< image.getWidth(); j++) {
        picture.pixels[i*picture.width+j] = image.getRGB(j, i);
      }
    }
    return picture;
  }
  /**
   * Starts the webcam.
  **/
  public void openWebcam(){
    if(!webcam.isOpen()){
      webcam.open();
    }
  }
  /**
   * Closes the Webcam.
  **/
  public void closeWebcam(){
    if(webcam.isOpen()){
      webcam.close();
    }
  }
}