
/**
 * Class that sorts the pixels in the order of the hilbert curve.
 * The functionality and the comments of the sortFunction and revSortFunction are based on the algorithm of princeton university:  https://introcs.cs.princeton.edu/java/32class/Hilbert.java.html
 * @author Finn Bayer 23-11-2017
**/
public class Hilbert {
  /**
   * The order of the hilbert curve. Is set by the final HILBERTORDER variable in the SeeWithEars class.
  **/
  private int hilbertOrder;
  /**
   * The state is used to determine which pixels is added next.
  **/
  private int state = 0;
  /**
   * The number of different states (left, right, up, down) 
  **/
  private final int NUM_STATES = 4;
  /**
   * XValue.
   **/
  private int x;
  /**
   * YValue.
  **/
  private int y;
  /**
   * Used to copy the pixel to the right spot in the array
  **/
  private int counter;
  /**
   * The widht of the given image.
  **/
  private int picWidth;

  /**
   * Standard constructor.
   * Sets the Hilbert Order.
   * @param hilbertOrder The designated hilbert order
  **/
  public Hilbert(int hilbertOrder){
    this.hilbertOrder = hilbertOrder;
  }
  /**
   * Overhead of the recursive functions that are sorting the pixels according to the hilbert curve.
   * @param pix The pixels of the image
   * @param sortedPixels The array that stores the sorted Pixels of the image (has to be the same size like pix)
   * @param x The x variable of the starting point of the hilbert curve
   * @param y The y variable of the starting point of the hilbert curve 
   * @param picWidth The width of the given picture
   * @return float[] The array of the sorted Pixels.
  **/
  public float[] hilbertSort(int[] pix, float[] sortedPixels, int x, int y, int picWidth) {
    this.x = x;
    this.y = y;
    this.counter = 0;
    this.picWidth = picWidth;
    sortedPixels[0] = brightness(pix[y*picWidth+x]);
    sortedPixels = sortPixels(pix,sortedPixels, hilbertOrder);
    //switch the quadrants of the hilbert curve to match the criteria that higher spatial position is associated with higher pitch.
    float[] backupArray = sortedPixels.clone();
    int lowerRight = 3* sortedPixels.length/4;
    int upperRight = 2*sortedPixels.length/4;
    for (int upperLeft = sortedPixels.length/4; upperLeft <= sortedPixels.length/2 - 1; upperLeft++){
      sortedPixels[upperRight] = backupArray[upperLeft];
      sortedPixels[upperLeft] = backupArray[lowerRight];
      sortedPixels[lowerRight] = backupArray[upperRight];
      
      lowerRight++;
      upperRight++;
    }
    return sortedPixels;
  }


  /**
   * Recursive function that sorts the pixels.
   * @param pix The pixels of the image
   * @param sortedPixels The array that stores the sorted Pixels of the image (has to be the same size like pix)
   * @param recDeep The depth of the recursion. Break condition.
   * @return float[] The sorted pixel array
  **/
  private float[] sortPixels(int[] pix, float[] sortedPixels, int recDeep) {
    // break condition
    if (recDeep == 0) return sortedPixels;
    //turnleft(+)
    this.state  = (this.state+1) % NUM_STATES;

    //call revSortPixels 
    sortedPixels = revSortPixels(pix, sortedPixels, recDeep-1);

    //goForward (add Element)
    this.refreshXY();
    this.counter += 1;
    sortedPixels[this.counter] = brightness(pix[this.y*this.picWidth+this.x]);

    //turnleft(-)
    this.state  = (this.state-1) % NUM_STATES;
    if (this.state<0) this.state+=NUM_STATES;

    //call sortPixels 
    sortedPixels = sortPixels(pix, sortedPixels, recDeep-1);

    //goForward (add Element)
    this.refreshXY();
    this.counter += 1;
    sortedPixels[this.counter] = brightness(pix[this.y*this.picWidth+this.x]);

    //call sortPixels 
    sortedPixels = sortPixels(pix, sortedPixels, recDeep-1);

    //turnleft(-)
    this.state  = (this.state-1) % NUM_STATES;
    if (this.state<0) this.state+=NUM_STATES;

    //goForward (add Element)
    this.refreshXY();
    this.counter += 1;
    sortedPixels[this.counter] = brightness(pix[this.y*this.picWidth+this.x]);

    //call revSortPixels 
    sortedPixels = revSortPixels(pix, sortedPixels, recDeep-1);
    //turnleft(+)
    this.state  = (this.state+1) % NUM_STATES;

    return sortedPixels;
  }

  /**
   * The reverse sorting pixels algorithm.
   * @param pix The pixels of the image
   * @param sortedPixels The array that stores the sorted Pixels of the image (has to be the same size like pix)
   * @param recDeep The depth of the recursion. Break condition.
   * @return float[] The sorted pixel array
  **/
  private float[] revSortPixels(int[]pix, float[] sortedPixels, int recDeep) {
    if (recDeep == 0) return sortedPixels;

    //turnleft(-)
    this.state  = (this.state-1) % NUM_STATES;
    if (this.state<0) this.state+=NUM_STATES;

    //call sortPixels 
    sortedPixels = sortPixels(pix, sortedPixels, recDeep-1);

    //goForward (add Element)
    this.refreshXY();
    this.counter += 1;
    sortedPixels[this.counter] = brightness(pix[this.y*this.picWidth+this.x]);

    //turnleft(+)
    this.state  = (this.state+1) % NUM_STATES;

    //call revSortPixels 
    sortedPixels = revSortPixels(pix, sortedPixels, recDeep-1);

    //goForward (add Element)
    this.refreshXY();
    this.counter += 1;
    sortedPixels[this.counter] = brightness(pix[this.y*this.picWidth+this.x]);

    //call revSortPixels 
    sortedPixels = revSortPixels(pix, sortedPixels, recDeep-1);

    //turnleft(+)
    this.state  = (this.state+1) % NUM_STATES;

    //goForward (add Element)
    this.refreshXY();
    this.counter += 1;
    sortedPixels[this.counter] = brightness(pix[this.y*this.picWidth+this.x]);

    //call sortPixels 
    sortedPixels = sortPixels(pix, sortedPixels, recDeep-1);

    //turnleft(-)
    this.state  = (this.state-1) % NUM_STATES;
    if (this.state<0) this.state+=NUM_STATES;

    return sortedPixels;
  }

  /**
   * Update the x and y coordinate depending of the state set by the sorting function.
  **/
  private void refreshXY() {

    switch (this.state) {
    case 0:
      this.x += 1;
      break;    
    case 1:
      this.y -= 1;
      break;
    case 2:
      this.x -= 1;
      break;
    case 3:
      this.y += 1;
      break;
    }
  }
  /**
   * Return the Hilbert Order that is used.
   * @return int The hilbert order that is used.
  **/
  public int getHilbertOrder() {
    return this.hilbertOrder;
  }
}