/**
 * Follow 1  
 * based on code from Keith Peters. 
 * 
 * A line segment is pushed and pulled by the cursor.
 */

float x = 0;
float y = 0;
float segLength = 200;
int dotSize = 40;

float omega = 2*PI;
float zeta = 0.05;
float alpha = omega * zeta;
float gamma = omega * (sqrt(1-(pow(zeta,2))));
float theta = 0.0;
float time = 0.0;
float timeDelta = 0.01;

float lastTheta = 0.0;
float lerp = 0.95;
float reversreThreshold = 0.0005;
float runningAverage = 0.0;
boolean increasing = false;
boolean firstLoop = true;
float thetaDelta = -2*PI/60;
float increment = -PI;
float position = 0.0;

void setup() {
  size(640, 640);
  frameRate(80);
  strokeCap(ROUND);
  strokeWeight(5);  
}

void draw() {
  background(255);
  stroke(0);
  fill(0);
  ellipse(width/2,height/2,width*0.8,height*0.8);
  stroke(255);
  fill(255);
  ellipse(width/2,height/2,15,15);
  
  theta = (exp(-alpha * time) * ((alpha/gamma)*sin(gamma * time) + cos(gamma * time))) + increment;
  //theta = (exp(-alpha * time) * ((alpha/gamma)*sin(gamma * time) + cos(gamma * time)));
  
  runningAverage = lerp * runningAverage + (1.0 - lerp) * abs(lastTheta - theta);
  
  if (runningAverage <= reversreThreshold)  {
    timeDelta = -timeDelta;
    runningAverage = 99.0;
  }
  
  if (firstLoop == false)  {
    if (time <= 0.0)  {
      timeDelta = -timeDelta;
      increment = increment + thetaDelta;
    }
  }
  if (firstLoop == true)  {
    firstLoop = false;
  }
  
  y = width/2 + cos(theta) * segLength;
  x = height/2 + sin(theta) * segLength; 
  ellipse(x, y, dotSize, dotSize);
  ellipse(width/2,height/2+120,dotSize*0.667,dotSize*0.667);
  stroke(100);
  line(width/2,height/2,x,y);
  line(width/2,height/2,width/2,height/2+120);
  time = time + timeDelta;
  lastTheta = theta;
  position = (-(degrees(increment)+180)) % 360;
  
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
  
  //delay(2);
}

void keyPressed() {
  time = 0.0;
}