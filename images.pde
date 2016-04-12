// Be sure to put locations.tsv and names.tsv
// from b_getting_locations into your current data folder!


//introduce variables and objects
PImage[] arrayOfImages;
PImage mapImage;
PImage mapSubImage;
Table locationTable; //this is using the Table object
Table amountsTable; //this is using the Table object
Table namesTable;
Table imagesTable;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

//global variables assigned values in drawData()
float closestDist;
String closestText;
String loadImages;
String id;
float closestTextX;
float closestTextY;


void setup() {
  size(640, 400);
    for (int row = 0; row<rowCount; row++) {
    //assign id values to variable called id
    String id = namesTable.getRowName(row);
    //get the 2nd and 3rd fields and assign them to
    float x = locationTable.getFloat(id, 1);
    float y = locationTable.getFloat(id, 2);
    //use the drawData function (written below) to position and visualize
    drawData(x, y, id);
    println(id);
  }
  mapImage = loadImage("oakland_map.png");
  arrayOfImages = new PImage[6];
 for(int i=0;i<arrayOfImages.length;i++){
  arrayOfImages[i] = loadImage(i+".png"); 
  }
  



  //assign tables to object
  locationTable = new Table("locations.tsv");  
  amountsTable = new Table("amounts.tsv");
  namesTable = new Table("names.tsv");
  imagesTable = new Table("images.tsv");

  // get number of rows and store in a variable called rowCount
  rowCount = locationTable.getRowCount();
  //count through rows to find max and min values in random.tsv and store values in variables
  for (int row = 0; row< rowCount; row++) {
    //get the value of the second field in each row (1)
    float value = amountsTable.getFloat(row, 1);
    //if the highest # in the table is higher than what is stored in the 
    //dataMax variable, set value = dataMax
    if (value>dataMax) {
      dataMax = value;
    }
    //same for dataMin
    if (value<dataMin) {
      dataMin = value;
    }
  }
}

void draw() {
  background(255);
  image(mapImage, 0, 0);

  closestDist = MAX_FLOAT;

//count through rows of location table, 
  for (int row = 0; row<rowCount; row++) {
    //assign id values to variable called id
    String id = namesTable.getRowName(row);
    //get the 2nd and 3rd fields and assign them to
    float x = locationTable.getFloat(id, 1);
    float y = locationTable.getFloat(id, 2);
    //use the drawData function (written below) to position and visualize
    drawData(x, y, id);
    println(id);
  }

//if the closestDist variable does not equal the maximum float variable....
  if (closestDist != MAX_FLOAT) {



    fill(#FF4C33);
    textAlign(CENTER);
    textSize(20);
    text(closestText, closestTextX, closestTextY);
  }
}

//we write this function to visualize our data 
// it takes 3 arguments: x, y and id
void drawData(float x, float y, String id) {
//value variable equals second field in row
  float value = amountsTable.getFloat(id, 1);
  float radius = 20;
//if the value variable holds a float greater than or equal to 0
  if (value>=0) {
    //remap the value to a range between 1.5 and 15
    radius = map(value, 0, dataMax, 1.5, 15); 
    //and make it this color
    fill(#00E0FF);
  } else {
    //otherwise, if the number is negative, make it this color.
    radius = map(value, 0, dataMin, 1.5, 15);
    fill(75);
  }
  //make a circle at the x and y locations using the radius values assigned above
  ellipseMode(RADIUS);
  ellipse(x, y, radius,radius);

  float d = dist(x, y, mouseX, mouseY);

//if the mouse is hovering over circle, show information as text
  if ((d<radius+2) && (d<closestDist)) {
    closestDist = d;
    String name = namesTable.getString(id, 1);
    String image = imagesTable.getString(id,1);
    closestText = name;
    loadImages = image;
    closestTextX = x;
    closestTextY = y-radius-4;
    int newId = int(id);
    mapSubImage = loadImage(newId + ".png");
    image(mapSubImage,50,50,300,200);
  }
}