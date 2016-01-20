#include <Servo.h>

const int trig = A5;
const int echo = A4;
const int red = A0;
int RED = 0;
int luzR = 0;
Servo Servo1;
long valor;

long mede(){
  long duracao;
  long distancia;
  digitalWrite(trig, LOW);
  delayMicroseconds(2); 
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);
  duracao = pulseIn(echo, HIGH);
  distancia = duracao/58;  
  return distancia;
}

void avanca(int posicao){
  Servo1.write(posicao);
}

int luz(){
  RED =  analogRead(red);
  return RED;
}

void tela(int lugar, long valor, int intensidade){
  Serial.print("X");
  Serial.print(lugar);
  Serial.print("V");
  Serial.print(valor);
  Serial.print("R");
  Serial.println(intensidade);  
}

void setup(){
  Serial.begin(9600);
  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);
  Servo1.attach(3);
}

void loop(){
  if(Serial.available() > 0){
      for(int i = 1;  i < 181; i++){
        avanca(i);
        delay(125);
        valor = mede();
        luzR = luz();
        tela(i, valor, luzR);  
        delay(125);
      }
      for(int i = 180;  i > 0; i--){
        avanca(i);
        delay(125);
        valor = mede();
        luzR = luz();
        tela(i, valor, luzR);  
        delay(125);
      }
    }
}
