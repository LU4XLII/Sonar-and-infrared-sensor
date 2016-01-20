import processing.serial.*;   
Serial arduinoport; 

int pressionado = 1;
float x, y; //coordenadas dos vértices
int raio =  350;
int graus = 0;
int w = 300;
int valor = 0;
int vaiVolta = 0;
int[] novosValores = new int[181];
int[] velhosValores = new int[181];
int[] luz = new int[181];
PFont minhaFonte;
int radarDist = 0;
int firstRun = 0;
int red = 0;

void setup(){
  size(930, 450);
  background (0);
  minhaFonte = createFont("verdana", 12);
  textFont(minhaFonte);
  arduinoport = new Serial(this, Serial.list()[1], 9600);
}

void draw(){
  fill(0);
  noStroke();
  ellipse(raio, raio, 750, 750);
  rectMode(CENTER);
  rect(350,402,800,100);
  if (graus >= 179) {    //faz a animação seguir o caminho inverso          
    vaiVolta = 1;                         
  }
  if (graus <= 1) {                  
    vaiVolta = 0;                         
  }
  strokeWeight(7);
  if(vaiVolta == 0){
    for(int i = 0; i<=20; i++){ //cria o efeito de radar
      stroke(0, (10*i), 0);
      line(raio, raio, raio + cos(radians(graus+(180+i)))*w, raio + sin(radians(graus+(180+i)))*w);
    }
  }else{
    for(int i = 20; i>=0; i--){ //cria o efeito de radar
      stroke(0, 200-(10*i), 0);
      line(raio, raio, raio + cos(radians(graus+(180+i)))*w, raio + sin(radians(graus+(180+i)))*w);
    }
  }
endShape();
noStroke();
fill(0,50,0);
//primeira varredura
beginShape(); //inicia o desenho do semicírculo
for(int i = 0; i<180; i++){
  x = raio + cos(radians((180+i)))*((velhosValores[i]));
  y = raio + sin(radians((180+i)))*((velhosValores[i]));
  vertex(x, y);
}
endShape(); //termina o desenho do semicírculo
//segunda varredura
fill(0,110,0);
beginShape();
for(int i = 0; i<180; i++){
  x = raio + cos(radians((180+i)))*((novosValores[i]));
  y = raio + sin(radians((180+i)))*((novosValores[i]));
  vertex(x, y);
}
endShape();
//media
fill(0,170,0);
beginShape();
for (int i = 0; i < 180; i++) {
  x = raio + cos(radians((180+i)))*((novosValores[i]+velhosValores[i])/2);
  y = raio + sin(radians((180+i)))*((novosValores[i]+velhosValores[i])/2);
  vertex(x, y);
}
endShape();
//anel vermelho após duas voltas
if (firstRun >= 360) {
  stroke(150,0,0);
  strokeWeight(1);
  noFill();
  for (int i = 0; i < 180; i++) {
    if (velhosValores[i] - novosValores[i] > 35 || novosValores[i] - velhosValores[i] > 35) {
      x = raio + cos(radians((180+i)))*(novosValores[i]);
      y = raio + sin(radians((180+i)))*(novosValores[i]);
      ellipse(x, y, 10, 10); 
    }
  }
}
// distância entre os anéis do radar
for(int i = 0; i<=6; i++){
  noFill();
  strokeWeight(1);
  stroke(0, 255-(30*i), 0);
  ellipse(raio, raio, (100*i), (100*i));
  fill(0, 100, 0);
  noStroke();
  text(Integer.toString(radarDist+50), 380, (305-radarDist), 50, 50);
  radarDist+=50;
}
radarDist = 0;
//desenha as linhas da grade a cada 30 graus
for(int i =  0; i <= 6; i++){
  strokeWeight(1);
  stroke(0,55,0);
  line(raio, raio, raio + cos(radians(180+(30*i)))*w, raio + sin(radians(180+(30*i)))*w);
  fill(0, 55, 0);
  noStroke();
  if (180+(30*i) >= 300) {
    text(Integer.toString(180+(30*i)), (raio+10) + cos(radians(180+(30*i)))*(w+10), (raio+10) + sin(radians(180+(30*i)))*(w+10), 25,50);
  } else {
    text(Integer.toString(180+(30*i)), raio + cos(radians(180+(30*i)))*w, raio + sin(radians(180+(30*i)))*w, 60,40);
  }
}
//escreve as informações na tela
noStroke();
fill(0);
rect(350,402,800,100);
fill(0, 100, 0);
text("Graus: "+Integer.toString(graus), 100, 380, 100, 50);         
text("Distância: "+Integer.toString(valor), 100, 400, 100, 50);
text("InfraRed: "+Integer.toString(red), 100, 420, 100, 50);
text("Radar screen code ", 540, 380, 250, 50);
fill(0);
rect(70,60,150,100);
fill(0, 100, 0); 
text("Legenda:", 100, 50, 150, 50);
fill(0,50,0);
rect(30,53,10,10);
text("1º varredura:", 115, 70, 150, 50);
fill(0,110,0);
rect(30,73,10,10);
text("2º varredura:", 115, 90, 150, 50);
fill(0,170,0);
rect(30,93,10,10);
text("Média", 115, 110, 150, 50);
noFill();
stroke(150,0,0);
strokeWeight(1);
ellipse(29, 113, 10, 10); 
fill(150,0,0);
text("Movido", 115, 130, 150, 50);
//quadrado do sinal infravermelho
stroke(255, 255, 255);
fill(0, 0, 0);
rect(820, 210, 182, 400);
for(int i = 10; i<=400; i++){
  if((i%10)==0){
    point(728, i);
    point(727, i);
    point(726, i);
  }
}
beginShape();
for(int i = 1; i<181; i++){
  fill(255, 255, 255);
  stroke(255,255,255);
  point((730+i), (410-luz[i]));
}
endShape();
//linha 
beginShape();
fill(255, 255, 255);
stroke(255,255,255);
line((730+graus), 410, (730+graus),10);
endShape();
// botão
fill(0, 0, 110);
stroke(0, 0, 110);
rect(670, 53, 10, 10);
text("start", 755, 70, 150, 50);
fill(pressionado);
}

void mouseClicked(){
  arduinoport.write(pressionado);
}

//recolhe dados do radar
void serialEvent (Serial arduinoport) {
  String xString = arduinoport.readStringUntil('\n');  // lê uma linha por vez
  if (xString != null) { 
    xString = trim(xString); //retira os espaços em branco
    String getX = xString.substring(1, xString.indexOf("V")); // pega a posição do servo
    String getV = xString.substring(xString.indexOf("V")+1, xString.indexOf("R")); // pega a distância
    String getR = xString.substring(xString.indexOf("R")+1, xString.length()); //pega o infravermelho
    graus = Integer.parseInt(getX); 
    valor = Integer.parseInt(getV);
    red = Integer.parseInt(getR);
    velhosValores[graus] = novosValores[graus];
    novosValores[graus] = valor;
    luz[graus] = red/3;  
    //valor para duas voltas
    firstRun++;
    if (firstRun > 360) {
      firstRun = 360; 
    }
  }
}
