// ESP32 — La guida completa alla famiglia · capitolo 20 (I2C, SPI, UART, TWAI)
// Listato 20.4 — Una seconda seriale su pin scelti. Il buffer di ricezione predefinito è di 256 byte; un GPS che manda frasi lunghe a raffica lo riempie.
// Il codice mostrato nel libro è il nucleo dell'esempio: le funzioni richiamate
// e non definite qui sono indicate nella didascalia o nel capitolo.

HardwareSerial gps(1);

void setup() {
  gps.setRxBufferSize(1024);           // prima di begin
  gps.begin(9600, SERIAL_8N1, 16, 17); // RX, TX
}

void loop() {
  while (gps.available()) Serial.write(gps.read());
}
