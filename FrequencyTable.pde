/**
 * Class that calculates the used frequencys.
 * @author Finn Bayer 24-11-2017
**/
public class FrequencyTable {
  private float[] frequencys = new float[64];
  /**
   * Initialize the Frequencys based on the calculation of the piano key frequencys. 
   * Because the programm only uses a maximum of 64 different frequencys, a start and and end tone was set (key 13: A 55 Hz and key 76: c'''' 2093Hz)
  **/
  public void initFrequencys() {
    int startNo = 13;
    int endNo = 76;
    int counter = 0;
    for (int i = startNo; i<=endNo; i++) {
      this.frequencys[counter] = (float)Math.pow(2, ((float)i-49)/12)*440;
      counter++;
    }
  }

  /**
   * Returns the frequency at the location i.
   * @param i The location in the array of frequencys
   * @return float The frequency at the location i 
  **/
  public float getFrequency(int i) {
    return this.frequencys[i];
  }
}