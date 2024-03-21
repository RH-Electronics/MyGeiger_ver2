/*
MyGeiger SD LOGGER SHIELD ver.1.00
RH Electronics
http://rhelectronics.net
Alex Boguslavsky

SD Logger software based on OpenLog by SparkFun.
https://www.sparkfun.com/products/9530

To keep MyGeiger project compact, SD Logger hardware is presented on LCD Shield PCB.

SD Logger will write to micro SD all data exactly as it comes from MyGeiger DIY Geiger Kit. Depend on MyGeiger UART output settings,
the kit will send CPM each 5 seconds or Bq/cm2 results each 5 seconds. You can modify this software and configure how the final 
log files will look like. Only standard 8.3 file names are supported.
To reduce power consumption the Atmega-328 MCU goes into sleep mode and wake up only if new data comes from the kit. 
When idle, SD logger part consumes only about 1.50mA - 2.00mA
SD logger based on independed MCU, you can power down SD logging shield if not used. We recommend to use only branded SD cards.

*/


#include <avr/sleep.h> //Needed for sleep_mode
#include <avr/power.h> //Needed for powering down perihperals such as the ADC/TWI and Timers
#include <SPI.h>
#include <SD.h>
File myFile;

// Buffer to store incoming data from serial port
String inData;
String cardData;

char fastLog[]        = "LOG00.CSV";                  // name for csv log file
boolean shield_status = true;                         // flag for SD cart error
boolean fileFlag      = false;                        // flag for SD file error


void setup()
{
  //Power down various bits of hardware to lower power usage  
  set_sleep_mode(SLEEP_MODE_IDLE);
  sleep_enable();

  //Shut off TWI, Timer2, Timer1, ADC
  ADCSRA &= ~(1<<ADEN); //Disable ADC
  ACSR = (1<<ACD); //Disable the analog comparator
  DIDR0 = 0x3F; //Disable digital input buffers on all ADC0-ADC5 pins
  DIDR1 = (1<<AIN1D)|(1<<AIN0D); //Disable digital input buffer on AIN1/0

  power_twi_disable();
  power_timer1_disable();
  power_timer2_disable();
  power_adc_disable();
  
  //Set incoming message buffer size
  inData.reserve(100);
  cardData.reserve(100);

  //Set all digital pins as inputs and set internal pull ups
  pinMode(2, INPUT);
  digitalWrite(2, HIGH);
  pinMode(3, INPUT);
  digitalWrite(3, HIGH);
  pinMode(4, INPUT);
  digitalWrite(4, HIGH);
  pinMode(5, INPUT);
  digitalWrite(5, HIGH);
  pinMode(6, INPUT);
  digitalWrite(6, HIGH);
  pinMode(7, INPUT);
  digitalWrite(7, HIGH);
  pinMode(8, INPUT);
  digitalWrite(8, HIGH);
  pinMode(9, INPUT);
  digitalWrite(9, HIGH);

  // making this pin output as SD library say pin#14
  pinMode(10, OUTPUT);          
  delay(100);
  
  //Start UART at 2400 for MyGeiger
  Serial.begin(2400);
  delay(500);
  
  //Start SD Card
    if (!SD.begin(10)) {         // if (!SD.begin(A2))
    shield_status = false;       // do not log to SD until new cart replaced
    }
    delay(100); 
   
    if (shield_status = true) {
      
      for (uint8_t i = 0; i < 100; i++) {
        fastLog[3] = i/10 + '0';              
        fastLog[4] = i%10 + '0';  
        
        if (! SD.exists(fastLog)) {
            // only open a new file if it doesn't exist
            myFile = SD.open(fastLog, FILE_WRITE);
            fileFlag = true;   // new file was created
            // if the file opened okay, write to it:
            if (myFile) {
            myFile.close();
            
             
            shield_status = true;
             }
            else{
            shield_status = false;     // set error status for SD shield, will not perform SD logging if false
 
          }           
          break; // leave the loop!
        }                
       
     }   
    
          if (fileFlag = false){     // file error
        
             while(1){
             sleepNow(); // deep sleep because there is no file name available, no log!
           }
          }     

}

}

//-----------------------------------------MAIN CYCLE IS HERE----------------------------------------------------//
void loop()
{

    ReadSerialWrite();  
    
}  
//---------------------------------------------------------------------------------------------------------------//


//---------------------------------------SUB PROCEDURES ARE HERE-------------------------------------------------//

//----------------------------------RECEIVE AND SAVE FROM PIC18F2550---------------------------------------------//
void ReadSerialWrite(){
    while (Serial.available() > 0)
    {
        char recieved = Serial.read();
        inData += recieved; 

        // Process message when new line character is recieved
        if (recieved == '\r')            //carriage return 0x13
        {
            cardData = inData;
            inData = "";                 // Clear recieved buffer
             if (shield_status = true) {
                myFile = SD.open(fastLog, FILE_WRITE);
              // if the file opened okay, write to it:
              if (myFile) {
              myFile.print(cardData); 
              myFile.close();
              shield_status = true;
              sleepNow();                // go sleep until new transmission will come
              }
              else{
              shield_status = false;     // set error status for SD shield, will not perform SD logging if false
              sleepNow();                // go sleep to reduce power consumtion
              } 
             }              
        }
    }
}
//---------------------------------------------------------------------------------------------------------------//

//---------------------------------GO TO SLEEP PROCEDURE---------------------------------------------------------//
void sleepNow()
{
  // power down all peripherals inside MCU
  power_adc_disable();
  power_spi_disable();
  power_timer0_disable();
  power_timer1_disable();
  power_timer2_disable();
  power_twi_disable();
  
  
  sleep_mode();            // here the device is actually put to sleep!!
  power_spi_enable();      // After wake up, power up peripherals we need
  power_timer0_enable();   // THE PROGRAM CONTINUES FROM HERE AFTER WAKING UP
   
}

//---------------------------------------------------------------------------------------------------------------//
