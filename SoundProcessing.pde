import processing.sound.*;

/**
 * Class that handles the sound representation.
 * Initializes the sinus oscillators based on the location of the pixels and the brightness of the pixel. 
 * @author Finn Bayer 30-11-2017
 **/
public class SoundProcessing extends SeeWithEars{

  /**
   * Array that contains the amplitude of the different sine oscillators
  **/
  private float[] amps;

  /**
   * Array containing the sine oscillators
  **/
  private SinOsc[] oscs;
  /**
   * Array containing the sorted pixels
  **/
  private float[] sortedPixels;
  /**
   * Object that is used to calculate the different frequencys for the sine oscillators
  **/
  private FrequencyTable fr;
  
  /**
   * Is true if the object is playing a tone
  **/
  private boolean isPlaying = false;
  
  /**
   * Function to initialize the sine oscillators.
   * @param sortedPixels Float array that contains the pixels that are used to initilize the sine oscillators
   **/
  public void processPixels(float[] sortedPixels) {
    this.sortedPixels = sortedPixels;
    this.calculatingAmps();
    this.initSinOscs();
  }
  /**
   * Function to calculate the amplitudes based on the brightness of the pixels.
   **/
  private void calculatingAmps() {
    //normalizing the brightness of the pixels between 0 and 1 to get the amplitudes 
    this.amps = new float[this.sortedPixels.length];
    for (int i = 0; i<this.amps.length; i++) {
      this.amps[i] = this.sortedPixels[i]/255;
    }
  }


  /**
   * Initialize the sine oscillators for the tone based on the amplitudes and the number of pixels.
   **/
  private void initSinOscs() {
    this.oscs = new SinOsc[this.amps.length];
    float freq;
    float amp;
    int steps = 64;

    //import the used frequencys
    this.fr = new FrequencyTable();
    this.fr.initFrequencys();

    for (int i = 0; i < this.amps.length; i++) {
      this.oscs[i] = new SinOsc(this);
      freq = this.fr.getFrequency((i*steps/this.amps.length)+(steps/(2*this.amps.length)));
      amp = this.amps[i];
      amp = float(floor(100*amp))/100;
      this.oscs[i].set(freq, amp, 0f, 0f);
      println("Oscillator "+i);
      println("Ampltiude: "+amp);
      println("Frequency: "+freq);
      println("");
      println("_______________________");
    }
  }
  /**
   * Function to play the sine oscillators all at a time.
   **/
  public void play() {
    isPlaying = true;
    for (int i =0; i<this.sortedPixels.length; i++) {
      this.oscs[i].play();
    }
  }
  /**
   * Function to stop the sine oscillators all at a time.
   **/
  public void pause(){
    for (int i =0; i<this.sortedPixels.length; i++) {  
      this.oscs[i].stop();
    }
    isPlaying = false;
  }
  /**
   * Returns if the object is playing a tone.
   * @return boolean True if the object is playing a tone.
   **/
  public boolean isPlaying(){
    return this.isPlaying;
  }

}