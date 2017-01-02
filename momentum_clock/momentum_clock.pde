int initialHours = 2;    //time to start at, in hours, 0-12
int initialMinutes = 50; // time to start at, in minutes, 0-60

float x = 0;
float y = 0;
float segLength = 100;
float hourSegLength = 75;
int dotSize = 20;

float omega = 2*PI;
float zeta = 0.05;
float alpha = omega * zeta;
float gamma = omega * (sqrt(1-(pow(zeta,2))));
float theta = 0.0;
float time = 0.0;
float timeDelta = 0.01;

float lastTheta = 0.0;
float lerp = 0.95;
float reverseThreshold = 0.001;
float runningAverage = 0.0;
boolean increasing = false;
boolean firstLoop = true;
float thetaDelta = -2*PI/60;
float increment = -PI - (initialMinutes/60.0*2*PI); // time to start at, in minutes, 0-60;
float position = 0.0;
float hoursPosition = 0.0;

float xHour = 0.0;
float yHour = 0.0;

void setup() {
  size(320, 320);
  frameRate(80);
  strokeCap(ROUND);
  strokeWeight(5); 
}

void draw() {
  //background(255);
  background(3,63,160);  

  // draw the clock face
  //stroke(0);
  //fill(0);
  stroke(255);
  fill(255);
  ellipse(width/2,height/2,width*0.8,height*0.8);
  
  // draw the hour dashes
  stroke(50);
  strokeWeight(3);
  fill(50);
  float r_inner = width/2 * 0.70;
  float r_outer = width/2 * 0.75; 
  for (int i = 0; i < 12; i = i+1) {
    float tempTheta = i * 30.0; 
    tempTheta = radians(tempTheta);
    float temp_x_inner = r_inner * cos(tempTheta) + width/2;
    float temp_y_inner = r_inner * sin(tempTheta) + height/2;
    float temp_x_outer = r_outer * cos(tempTheta) + width/2;
    float temp_y_outer = r_outer * sin(tempTheta) + height/2;
    line(temp_x_inner, temp_y_inner, temp_x_outer, temp_y_outer);
  } 
  strokeWeight(5); 
  
  // basic underdamped pendulum with friction force formula
  theta = (exp(-alpha * time) * ((alpha/gamma)*sin(gamma * time) + cos(gamma * time))) + increment;
  
  // track the running average of theta to see if the pendulum has "settled" into one place
  runningAverage = lerp * runningAverage + (1.0 - lerp) * abs(lastTheta - theta);
  
  // if the pendulum has essentially stopped moving, flip the time and falsely inflate the running 
  // average so that it doesn't trigger a reversal immediately
  if (runningAverage <= reverseThreshold)  {
    timeDelta = -timeDelta;
    runningAverage = 99.0;
  }
  
  // if this isn't the first time through and the time has regressed to zero, flip the movement
  if (firstLoop == false)  {
    if (time <= 0.0)  {
      timeDelta = -timeDelta;
      increment = increment + thetaDelta;
    }
  }
  
  if (firstLoop == true)  {
    firstLoop = false;
  }
  
  // change from cylindrical to rectangular coordinates for minute hand dot
  y = width/2 + cos(theta) * segLength;
  x = height/2 + sin(theta) * segLength; 
  
  if (initialHours >= 6)  {
    xHour = (width/2 + hourSegLength * cos((initialHours-3)/12.0*2*PI));
    yHour = (height/2 + hourSegLength * sin((initialHours-3)/12.0*2*PI));
  }
  else  {
    xHour = (width/2 + hourSegLength * cos((initialHours-3)/12.0*2*PI));
    yHour = (height/2 + hourSegLength * sin((initialHours-3)/12.0*2*PI));
  }
  
  // have not done anything with making the hour-hand actually move, this is the first step
  //hoursPosition = initialHours + position/360.0 * 12.0;
   
  // draw the connector segments
  stroke(25);
  fill(25);  
  strokeCap(ROUND);
  strokeWeight(3);
  line(width/2,height/2,x,y);
  line(width/2,height/2,xHour,yHour);
  
  // draw the center dot
  ellipse(width/2,height/2,5,5);
  
  // draw the minute hand dot and hour hand dot
  ellipse(x, y, dotSize, dotSize);
  ellipse(xHour,yHour,dotSize*0.667,dotSize*0.667);
   
  // update the various loop variables  
  time = time + timeDelta;
  lastTheta = theta;
  position = (-(degrees(increment)+180)) % 360;
  
 // print out some debug tracking stats
  String stime = nf(time,3,2);
  String stheta = nf(theta,3,2);
  String sx = nf(x,3,2);  
  String sy = nf(y,3,2); 
  String sRunningAverage = nf(runningAverage,2,4);
  String sIncrement = nf(position,3,1); 
  print(stime);
  print("\t");
  print(stheta);
  print("\t");
  print(sx);
  print("\t");
  print(sy);
  print("\t");
  print(sRunningAverage);
  print("\t");
  print(sIncrement);
  println();
  
  // Saves each frame as line-000001.png, line-000002.png, etc.
  //saveFrame("line-######.png");
}

//void keyPressed() {
//  time = 0.0;
//}