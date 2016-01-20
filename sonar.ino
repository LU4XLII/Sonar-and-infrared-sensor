#include <Servo.h>

const int trig = A5;
const int echo = A4;
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

void tela(int lugar, long valor){
  Serial.print("X");
  Serial.print(lugar);
  Serial.print("V");
  Serial.println(valor);  
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
        tela(i, valor);  
        delay(125);
      }
      for(int i = 180;  i > 0; i--){
        avanca(i);
        delay(125);
        valor = mede();
        tela(i, valor);  
        delay(125);
      }
    }
}
