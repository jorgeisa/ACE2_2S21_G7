#include <DHT.h>

///////// VENTILADOR //////////////
int contador;
static int NbTopsFan; // contador de impulsos.
const int fandiv = 2; // dos pulsos por vuelta
const int hallsensor = 2; // pin 2, que está unido a interrupción 0.

///////// HALL //////////////
int sumaVeleta=0;      
const byte pinDireccion = A2;       //pin AnalÃ³gico 
int direccion = 0;
int tiempoEnvio=30;

String cadena;


///////// HUMEDAD //////////////
// pin que se usa para recibir los datos del sensor
#define DHTPIN 8
//Como se usa el sensor DHT11 se importa 
#define DHTTYPE DHT11
 
// Inicializamos el sensor DHT11
DHT dht(DHTPIN, DHTTYPE);

// --- VENTILADOR ---
void rpm ()     // se llamará cada vez que se pruduce la interrupción
{
 NbTopsFan++;
}

// --- HALL ---
int leerDireccion(int suma){
  suma=suma/tiempoEnvio;
  if(suma>=415 && suma< 480) return 0;
  if(suma>=480 && suma< 490) return 0;
  if(suma>=490 && suma< 510) return 90;
  if(suma>=510 && suma< 525) return 90;
  if(suma>=540 && suma< 550) return 180;
  if(suma>=525 && suma< 540) return 180;
  if(suma>=590 && suma< 615) return 270;
  if(suma>=615 && suma< 620) return 270;
}

 unsigned long rpmStart = 0;
void setup() {
  Serial.begin(9600);
 rpmStart = millis();
  // -- HUMEDAD -- se inicia el sensor DHT11
  dht.begin();

  // -- VENTILADOR --
  pinMode(hallsensor, INPUT);
  attachInterrupt(0, rpm, RISING);
  
}

// -- HUMEDAD --
char* FtoChar2(float fVal, char* cF) {

  // Force number of decimal places to full 2
  int iDigs = 2;

  // Separator = 10 ˆ Number of decimal places
  long dSep = pow(10, iDigs);
// DEBUG
// Serial.print(F("FtoChar2 dSep: "));
// Serial.println(dSep);
    
  // Display value = floal value * separator
  signed long slVal = fVal * dSep;

  sprintf(cF, "%d.%d", int(slVal / dSep), int(slVal % int(dSep)));
}

//-- --
void temperatura(){
      //tiempo entre medidas
  delay(500);
 
  // calculo de la humedad
  double h = dht.readHumidity();
  // temperatura en celsius por default
  double t = dht.readTemperature();

  // verifica si no hay errores en el sensor
  if (isnan(h) || isnan(t) ) {
    Serial.println("Error en el sensor DHT11");
    return;
  }
 
  // Calcular grados centigrados
  double hic = dht.computeHeatIndex(t, h, false);
  
  char cMsg[254],cTemp[8], cHum[8];
  
  FtoChar2(t, cTemp);
  FtoChar2(h, cHum);
  
  cadena.concat("{\"temperatura\": ");
  cadena.concat(cTemp);
  cadena.concat(", \"humedad\": ");
  cadena.concat(cHum);
  
}


//--Direccion Viento --
void direccionviento(){
  for(int i=0;i<=tiempoEnvio;i++){
  sumaVeleta+=analogRead(pinDireccion);
  delay(10);
  }
  direccion=leerDireccion(sumaVeleta);
  sumaVeleta=0;
  cadena.concat(", \"direccion\": ");
  cadena.concat(direccion);
  
}

// ==========MILLIS===============
#define INTERVALO_MENSAJE1 1000
#define INTERVALO_MENSAJE2 1300
#define INTERVALO_MENSAJE3 1500
#define INTERVALO_MENSAJE4 1500
unsigned long tiempo_1 = 0;
unsigned long tiempo_2 = 0;
unsigned long tiempo_3 = 0;
unsigned long aux_millis = 0;

void loop() {
  aux_millis = aux_millis + millis();
  if(aux_millis > tiempo_1 + INTERVALO_MENSAJE1){
    tiempo_1 = aux_millis;
    temperatura();
  }
  if(aux_millis > tiempo_3 + INTERVALO_MENSAJE3){
      tiempo_3 = aux_millis;
      direccionviento();
  }
  if(aux_millis > tiempo_2 + INTERVALO_MENSAJE2){  //Velocidad de viento
        tiempo_2 = aux_millis;
        NbTopsFan = 0;
         sei(); 
         delay (1000); 
         interrupts();
         rpmStart = millis();

         
         char calcChar[8];
         double Calc = 0;
         double mh = 0;
         Calc = ((NbTopsFan * 60)/fandiv); //RPM
         mh = (2*3.6*3.1416*0.047* (Calc/60)); // KM/H
      
         FtoChar2(mh, calcChar);
         cadena.concat(", \"velocidad\": ");
         cadena.concat(calcChar);
         cadena.concat("}");
         
  }

    
    Serial.println(cadena);
    cadena = "";
    delay(500);
}
