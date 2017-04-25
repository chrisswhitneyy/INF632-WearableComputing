#include <SPI.h> // SPI library included for SparkFunLSM9DS1
#include <Wire.h> // I2C library included for SparkFunLSM9DS1
#include <SparkFunLSM9DS1.h> // SparkFun LSM9DS1 library
#include <SparkFunDS3234RTC.h> //SparkFun DS3234RTC library

#define DS13074_CS_PIN 10

// Define IMU addresses 
// SDO_XM and SDO_G are both pulled high, so our addresses are:
#define LSM9DS1_M   0x1E // Would be 0x1C if SDO_M is LOW
#define LSM9DS1_AG  0x6B // Would be 0x6A if SDO_AG is LOW

LSM9DS1 imu;
  
int GAS_SENSOR_PIN = 0; 
int gas_value;

void setup() {
  
  // Set serial baud rate
  Serial.begin(9600);
  
  // Set up IMU protocol mode and addresses
  imu.settings.device.commInterface = IMU_MODE_I2C; // Set mode to I2C
  imu.settings.device.mAddress = LSM9DS1_M; // Set mag address to 0x1E
  imu.settings.device.agAddress = LSM9DS1_AG; // Set ag address to 0x6B

  // Check to insure the IMU can be communicated with
  if (!imu.begin()){
    Serial.println("Failed to communicate with LSM9DS1.");
    Serial.println("Looping to infinity.");
    while (1); 
  }
  
  // Initialization of RTC 
  rtc.begin(DS13074_CS_PIN);

  delay(2000);                  // waits two seconds
  
  // Write headers to SD
  Serial.println("Gas Voltage, Accel x, Accel y, Accel z, Gyro x, Gyro y, Gyro z, RTC seconds, RTC minutes, RTC hours");
  
}

void loop() {
  
  /** Read sensor values **/
  // Get voltage reading from gas sensor
  gas_value = analogRead(GAS_SENSOR_PIN);
  Serial.print(gas_value,DEC); 

  // Get IMU values  
  // Accel 
  imu.readAccel(); // Update the accelerometer data
  Serial.print (imu.ax); // Print x-axis data
  Serial.print(", ");
  Serial.print(imu.ay); // print y-axis data
  Serial.print(", ");
  Serial.print(imu.az); // print z-axis data
  Serial.print(",");
  
  // Gyro 
  imu.readGyro(); // Update gyroscope data
  Serial.print(imu.calcGyro(imu.gx)); // Print x-axis rotation in DPS
  Serial.print(", ");
  Serial.print(imu.calcGyro(imu.gy)); // Print y-axis rotation in DPS
  Serial.print(", ");
  Serial.print(imu.calcGyro(imu.gz)); // Print z-axis rotation in DPS
  Serial.print(",");
  
  // Read RTC 
  rtc.update(); // Update RTC data

  // Read the time:
  int s = rtc.second();
  int m = rtc.minute();
  int h = rtc.hour();

  Serial.print(s); 
  Serial.print(","); 
  Serial.print(m); 
  Serial.print(",");
  Serial.print(h);
  Serial.println(" ");

}
