#include <SPI.h> // SPI library included for SparkFunLSM9DS1
#include <Wire.h> // I2C library included for SparkFunLSM9DS1
#include <SparkFunLSM9DS1.h> // SparkFun LSM9DS1 library
#include <SparkFunDS3234RTC.h> //SparkFun DS3234RTC library
#include <LiquidCrystal_I2C.h>

#define DS13074_CS_PIN 10

// Define IMU addresses
// SDO_XM and SDO_G are both pulled high, so our addresses are:
#define LSM9DS1_M   0x1E // Would be 0x1C if SDO_M is LOW
#define LSM9DS1_AG  0x6B // Would be 0x6A if SDO_AG is LOW

LSM9DS1 imu;

int GAS_SENSOR_PIN = 0;
int gas_value;

LiquidCrystal_I2C lcd(0x27, 16, 2); // set the LCD address to 0x27 for a 16 chars and 2 line display

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

  // Initilize LCD
  lcd.init();  //initialize the lcd
  lcd.backlight();  //open the backlight

  delay(2000);                  // waits two seconds

  // Write headers to SD
  Serial.println("seconds , minutes , hours ,  GasVoltage , Accel x , Accel y , Accel z , Gyro x , Gyro y , Gyro z ");

}

void loop() {

  delay(5000);                  // waits five seconds

  /** Read sensor values **/
  // Get voltage reading from gas sensor
  gas_value = analogRead(GAS_SENSOR_PIN);
  // Map voltage value into range between 0-10
  //int new_gas_value = map(gas_value, 500, 1023, 0, 10);
  //Print values to tx (i.e. save to SD)
  Serial.print(gas_value);
  Serial.print(",");

  // ** RTC
  rtc.update(); // Update RTC data
  // Read the time:
  int s = rtc.second();
  int m = rtc.minute();
  int h = rtc.hour();
  //Print values to tx (i.e. save to SD)
  Serial.print(s);
  Serial.print(" , ");
  Serial.print(m);
  Serial.print(" , ");
  Serial.print(h);

  // ** Accel
  imu.readAccel(); // Update the accelerometer data
  //Print values to tx (i.e. save to SD)
  Serial.print (imu.ax); // Print x-axis data
  Serial.print(" , ");
  Serial.print(imu.ay); // print y-axis data
  Serial.print(" , ");
  Serial.print(imu.az); // print z-axis data
  Serial.print(" , ");

  // ** Gyro
  imu.readGyro(); // Update gyroscope data
  //Print values to tx (i.e. save to SD)
  Serial.print(imu.calcGyro(imu.gx)); // Print x-axis rotation in DPS
  Serial.print(" , ");
  Serial.print(imu.calcGyro(imu.gy)); // Print y-axis rotation in DPS
  Serial.print(" , ");
  Serial.print(imu.calcGyro(imu.gz)); // Print z-axis rotation in DPS
  Serial.println(" ");

  lcd.setCursor(3, 0); // set the cursor to column 2, line 1
  lcd.print(gas_value);  // Print a message to the LCD.


  lcd.setCursor(2, 1); // set the cursor to column 2, line 1
  lcd.print(h + ":" + m + ":" + s);  // Print a message to the LCD.

}
