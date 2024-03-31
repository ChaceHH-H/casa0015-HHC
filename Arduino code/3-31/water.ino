#include <Capacitor.h>
Capacitor cap1(7,A2);
int kondenzator=0;
int w = 0;

void setup() 
{ 
Serial.begin(9600);
}

void loop() 
{
  //kondenzator = (cap1.Measure())*100;
  kondenzator = cap1.Measure();
  //Serial.println(kondenzator);  // Measure the capacitance (in pF), print to Serial Monitor
  int w = map(kondenzator, 95, 643, 0, 320); 
  Serial.println(w);

  delay(1000);
} 