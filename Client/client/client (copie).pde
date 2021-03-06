import processing.net.*;

float version_client = 0.1;
float version_serveur = 0.1;


//cette variable sera a 1 lorque la cmd link aura ete lance, ca evite d'ouvrir plein de page et de faire crash le pc
int open_nav = 0;

Client c;

//-1 = pas encore init
int id_client = -1;

float angle_arme = 0;

long tmpDepla;

Joueur[] joueur = new Joueur[100];


class Joueur{
  int x = 0;
  int y = 0;  
  
  int angle = 0;
  
  String pseudo = "test";
  
  int arme_en_main = 0;
  
  int vie = 0;
  
  //Cette variable permet de dire au client si le joueur marche ou tir afin d'adapter les animations
  //0=fixe 1=marche 2=tir 3=marche+tir
  int status = 0;
  
  int equipe = 1;

  //cette variable permet de définir la dernière action d'un joueur afin d'augmenter la fluidité du jeu
  int action = 0;
  
  void setX(int Nx){
    x = Nx;      
  }
  
  void setY(int Ny){
    y = Ny;      
  }
  
  int getX(){
    return x;  
  }
  
  int getY(){
    return y;  
  }
  
  void setAngle(int Na){
    angle = Na;  
    
  }
  
  int getAngle(){
    return angle;  
  }
  
  void setStatus(int Ns){
    status = Ns;   
  }
  
  int getStatus(){
    return status;  
  }
  
  void setPseudo(String NewPseudo){
    pseudo = NewPseudo;  
  }
  String getPseudo(){
    return pseudo;  
  }
  
  void setArme(int Na){
    arme_en_main = Na;  
    
  }
  
  int getArme(){
    return arme_en_main;  
  }
  
  void setVie(int Nv){
    vie = Nv;  
    
  }
  
  int getVie(){
    return vie;  
  }
  
  void setEquipe(int Ne){
    equipe = Ne;  
    
  }
  
  int getEquipe(){
    return equipe;  
  }
  
}

int pv_joueur = 100;

Balle[] balle = new Balle[100];

class Balle{
  int x = 0;
  int y = 0;  
  
  void setX(int Nx){
    x = Nx;      
  }
  
  void setY(int Ny){
    y = Ny;      
  }
  
  int getX(){
    return x;  
  }
  
  int getY(){
    return y;  
  }
}

class Base{
  int x = 0;
  int y = 0;  
  
  int vie = 1000;
  
  void setX(int Nx){
    x = Nx;      
  }
  
  void setY(int Ny){
    y = Ny;      
  }
  
  int getX(){
    return x;  
  }
  
  int getY(){
    return y;  
  }
}

Base baseA = new Base();
Base baseB = new Base();

HitMarker[] hitmarker = new HitMarker[10];

class HitMarker{
  int x = 0;
  int y = 0;  
  
  int valeur = 0;
  long tmp_aff = 0;
  
  void setX(int Nx){
    x = Nx;      
  }
  
  void setY(int Ny){
    y = Ny;      
  }
  
  int getX(){
    return x;  
  }
  
  int getY(){
    return y;  
  }
  
  void setValeur(int Nv){
    valeur = Nv;      
  }
  
  int getValeur(){
    return valeur;      
  }
}

Item[] item = new Item[100];

class Item{
  int x = 0;
  int y = 0;  
  
  int idArme = 0;
  
  void setX(int Nx){
    x = Nx;      
  }
  
  void setY(int Ny){
    y = Ny;      
  }
  
  void setIdArme(int id){
    idArme = id;  
  }
  
  int getX(){
    return x;  
  }
  
  int getY(){
    return y;  
  } 
  
  int getIdArme(){
    return idArme;  
  }
}

//tableau pour charger la map
int[][] map = new int[100][100];

long regul_send = 0;

int nb_joueur = 0;

int nb_item = 0;

int angle_personnage = 0;

int nb_balle = 0;

int nb_hit_marker = 0;

String message_info = "";

int key_RIGHT = 0;
int key_LEFT = 0;
int key_UP = 0;
int key_DOWN = 0;
int key_E = 0;

String pseudo = "";

//coordone du personnage client
int xPers = 0;
int yPers = 0;

//variable pour calculer le ping
long ping_millis = 0;
long ping = 0;

PImage herbe;
PImage sable;
PImage eau;
PImage route;
PImage chemin;
PImage beton;
PImage lave;

PImage pers;
PImage tir;

PImage imgBaseA;
PImage imgBaseB;


Arbre[] arbre = new Arbre[300];

class Arbre{
  int x = 0;
  int y = 0;
  
}
int nb_arbre = 0;

PImage arbreimg;


//tchat du serveur
String[] tchat = new String[5];
int nb_msg_tchat = 0;

float angle = 0;


//La variables est a 1 si la personne est entrain de tirer
int tir_en_cours = 0;

int pv = 100;
int equipe = 1;

int pseudo_OK = 0;
int perso_OK = 0;

//cette variable sert à eviter les problème de répétition d'un caractère lors de la saisi du pseudo
int antiRepet = 0;

//Ici est stocké les messages importants à affiché en gros (commencant par #)
String tchatImportant = "";
//cette variable permet de savoir depuis combien de temps est affiché un msg important afin de l'effacer au bout d'un moment. 
long timeTchatImportant = 0;

int personnage_choix = 0;


long tmpSend = 0;


void setup(){
  size(600,600); 
  
  c = new Client(this, "192.168.1.11", 222);

  
  for (int i = 0; i < 100; i++) {
    joueur[i] = new Joueur();
  } 
  
  for (int i = 0; i < 100; i++) {
    balle[i] = new Balle();
  } 
   
  for (int i = 0; i < 100; i++) {
    item[i] = new Item();
  } 
  
  for (int i = 0; i < 10; i++) {
    hitmarker[i] = new HitMarker();
  } 
  
  //on charge les images
  herbe = loadImage("Images/herbe.jpg");
  sable = loadImage("Images/sable.jpg");
  eau = loadImage("Images/eau.jpg");
  route = loadImage("Images/route.jpg");
  chemin = loadImage("Images/chemin.jpg");
  beton = loadImage("Images/beton.jpg");
  lave = loadImage("Images/lave.png");
  
  pers = loadImage("Images/pers.gif");
  tir = loadImage("Images/tir.png");
  
  imgBaseA = loadImage("Images/baseA.png");
  imgBaseB = loadImage("Images/baseB.png");
  
  PImage arbreimgtmp = loadImage("Images/trees.png");
  arbreimg = arbreimgtmp.get(0,0,256,256);
  
  //on charge la map
  String[] txtMap = loadStrings("map");
  
  if(txtMap[0].length() != 10000){
    println("Fichier map corrompu");  
  }
  else{
    for(int i = 0; i < 100;i++){
      for(int j = 0; j < 100;j++){
        if(txtMap[0].charAt(i*100+j) == '0'){
          map[i][j] = 0;  
        }
        if(txtMap[0].charAt(i*100+j) == '1'){
          map[i][j] = 1;  
        }
        if(txtMap[0].charAt(i*100+j) == '2'){
          map[i][j] = 2;  
        }
        if(txtMap[0].charAt(i*100+j) == '3'){
          map[i][j] = 3;  
        }
        if(txtMap[0].charAt(i*100+j) == '4'){
          map[i][j] = 4;  
        }
        if(txtMap[0].charAt(i*100+j) == '5'){
          map[i][j] = 5;  
        }
        if(txtMap[0].charAt(i*100+j) == '6'){
          map[i][j] = 6;  
        }
      }      
    }
  }
  
  for (int i = 0; i < 300; i++){
    arbre[i] = new Arbre();  
  } 
  
  //on charge les objets
  //arbre
  JSONObject jsonArbre = parseJSONObject(txtMap[1]);
  
  JSONArray arbreX = jsonArbre.getJSONArray("arbreX");
  JSONArray arbreY = jsonArbre.getJSONArray("arbreY");
  
  nb_arbre = arbreX.size();
  
  for(int i = 0; i < nb_arbre;i++){
    arbre[i].x = arbreX.getInt(i);
    arbre[i].y = arbreY.getInt(i); 
  }
  
}


void draw(){
  background(255);
  
  //on test déja si la version du client est à jour:
  if(version_client == version_serveur){
  
    connect_serveur();
    //on test si l'id_client est valide pour effectuer les actions suivante
    if(id_client != -1){
      if(pseudo_OK == 1 && perso_OK == 1){
        test_commande();
      }
      setAnglePers();
      affichage_map();
  
      
      afficheBalle();
      
      //on affiche pas le personnage si le pseudo n'est pas affiché, pour éviter qq bug d'affichage
      if(pseudo_OK == 1 && perso_OK == 1){
        affiche_personnage();
      }
      
      affiche_limite();
      afficheObjet();
      afficheBase();
      afficheHitMarker();
      
      infoCarte();
      
      affichePvBase();
      afficheMiniMap();
      
      afficheTchat();
     
      
      //coordone(debug)
      /*textSize(25);
      fill(255,0,0);
      text(xPers+","+yPers,100,100);*/
      
      afficheEcranFin();
     
    } 
    if(pseudo_OK == 0){
      //on règle le pseudo
      demandePseudo();
      
    }
    else if(perso_OK == 0){
      choisPerso();  
      
    }
  }
  else{
    //on envoi la personne télécharger la mise à jour
    fill(0);
    textSize(25);
    textAlign(CENTER);
    text("Il semblerait que tu utilises une vielle version,\ntélécharges la nouvelle et supprime celle ci.",width/2,height/2);
    if(open_nav == 0){
      open_nav = 1;
      link("https://quentin-fr.ddns.net/DualShoot/File/dualshoot"+str(version_serveur)+".zip");
    }
    
  }
}


void connect_serveur(){
  if (c.available()>0){
    delay(2);
    //on calcul le ping
    ping = millis() - ping_millis;
    
    String data = "";
    data = c.readStringUntil('}');  

    if(data != null){
      //println(data);
      //println("############################");
      JSONObject json = parseJSONObject(data);
      if(json != null){ 
        //on récupère d'abord l'ID si on l'a pas encore
        if(id_client == -1){
          id_client = json.getInt("ID");  
        }
        else{
          //On commence par récupérer la position de nous
          if(abs(json.getInt("X") - xPers) > 50 || abs(json.getInt("Y") - yPers) > 50){
            xPers = json.getInt("X");
            yPers = json.getInt("Y");
          }
          
          pv = json.getInt("pv");
          equipe = json.getInt("equipe");
          
          
          
          
          JSONArray posX = json.getJSONArray("pX");
          JSONArray posY = json.getJSONArray("pY");
          JSONArray angleTab = json.getJSONArray("pAngle");
          JSONArray statusTab = json.getJSONArray("pStatus");
          JSONArray pseudoTab = json.getJSONArray("pPseudo");
          JSONArray vieTab = json.getJSONArray("pVie");
          JSONArray equipeTab = json.getJSONArray("pEquipe");
          JSONArray actionTab = json.getJSONArray("pAction");
          
          JSONArray balleX = json.getJSONArray("bX");
          JSONArray balleY = json.getJSONArray("bY");
          
          //on actualise en local
          
          //la taille du tableau correspond au nombre de joueur
          nb_joueur = posX.size();
          for(int i = 0; i < nb_joueur;i++){
            if(joueur[i].action == 0 || abs(posX.getInt(i) - joueur[i].getX()) > 20 || abs(posY.getInt(i) - joueur[i].getY()) > 20){
              joueur[i].setX(posX.getInt(i));
              joueur[i].setY(posY.getInt(i));
            }
            joueur[i].setAngle(angleTab.getInt(i));
            joueur[i].setStatus(statusTab.getInt(i));
            joueur[i].setPseudo(pseudoTab.getString(i));
            joueur[i].setVie(vieTab.getInt(i));
            joueur[i].setEquipe(equipeTab.getInt(i));
            joueur[i].action = actionTab.getInt(i);
          }
          
          //la taille du tableau correspond au nombre de balle
          nb_balle = balleX.size();
          for(int i = 0; i < nb_balle;i++){
            balle[i].setX(balleX.getInt(i));  
            balle[i].setY(balleY.getInt(i)); 
          }
          
          //on récupère les informations sur les différentes bases
          baseA.setX(json.getInt("baseAX"));
          baseA.setY(json.getInt("baseAY"));
          baseA.vie = json.getInt("baseAPv");
          
          baseB.setX(json.getInt("baseBX"));
          baseB.setY(json.getInt("baseBY"));
          baseB.vie = json.getInt("baseBPv");
          
          version_serveur = json.getFloat("version");
                    
          //on recupère aussi le tchat serveur
          String newTchat = json.getString("tchat");
          if(newTchat.charAt(0) == '#'){
            //C'est un message important
            //le substring sert a enlever le #
            tchatImportant = newTchat.substring(1);
            timeTchatImportant = millis();
            
            newTchat = "-";
          }
          
          if(newTchat.indexOf("-") == -1){
            //on decale tous dans le tabelau tchat pour ne garder que les derniers messages.
            
            for(int i = 0; i < 4;i++){
              tchat[i] = tchat[i+1];                 
            }
            
            tchat[4] = newTchat;
            
          }
        }
      } 
    } 
  }  
}

void test_commande(){
  String message_cmd = "move";
  println(millis() - tmpDepla);
  if(millis() - tmpDepla > 60){
    tmpDepla = millis();
    int vitesse = 10;
    
    
    
    if(key_RIGHT == 1){
      xPers += vitesse;   
    }
    if(key_LEFT == 1){
      xPers -= vitesse; 
    }
    if(key_UP == 1){
      yPers -= vitesse;  
    }
    if(key_DOWN == 1){
      yPers += vitesse;  
    }
    
    //on fait bouger les autres joueurs
    deplacementJoueur();
  }
    
    if(millis() - tmpSend > 100){
      tmpSend = millis();
      c.write("{\"ID\": "+id_client+" , \"cmd\": \""+message_cmd+"\", \"x\": "+int(xPers)+", \"y\": "+int(yPers)+", \"ang\": "+int(angle)+", \"pseudo\": \""+pseudo+"\", \"tir\": \""+tir_en_cours+"\"}");    
    }
}

void affiche_personnage(){  
  //on affiche tous les personnages (sauf le notre)
  
  for(int i = 0; i < nb_joueur;i++){
    int x = width/2 - (xPers - joueur[i].getX()); 
    int y = height/2 - (yPers - joueur[i].getY()); 
    
    pushMatrix();
  
    translate(x,y);
    rotate(PI * joueur[i].getAngle() / 180);
    image(pers,-35,-50,70,70);
    
    //Si la personne est entrain de tirer on affiche une petite animation de tir
    if(joueur[i].getStatus() == 2 || joueur[i].getStatus() == 3){
      if(random(0,3) < 1.5){
        image(tir,25,-10);
      }
    }
    
    popMatrix();
    
    
  }  
  
  //On affiche ensuite notre personnage
  //seulement si il est encore en vie
  if(pv > 0){
    //fill(255,0,0);
    //ellipse(width/2, width/2,30,30);
    
    pushMatrix();
    
    translate(width/2,height/2);
    rotate(PI * angle / 180);
    image(pers,-35,-50,70,70);
    
    //Si la personne est entrain de tirer on affiche une petite animation de tir
    if(tir_en_cours == 1){
      if(random(0,3) < 1.5){
        image(tir,25,-10);
      }
    }
    
    popMatrix();
    
  }
}





void keyPressed(){
  if(keyCode == RIGHT){
    key_RIGHT = 1;  
  }
  if(keyCode == LEFT){
    key_LEFT = 1;  
  }
  if(keyCode == UP){
    key_UP = 1;  
  }
  if(keyCode == DOWN){
    key_DOWN = 1;  
  }
  if(key == '0'){
    key_E = 1;  
  }
}

void keyReleased(){
  if(keyCode == RIGHT){
    key_RIGHT = 0;  
  }
  if(keyCode == LEFT){
    key_LEFT = 0;  
  }
  if(keyCode == UP){
    key_UP = 0;  
  }
  if(keyCode == DOWN){
    key_DOWN = 0;  
  }   
  if(key == '0'){
    key_E = 0;  
  }
}

void affichage_map(){
  
  int xDep = int(xPers/60)*60 - xPers;
  int yDep = int(yPers/60)*60 - yPers;
  
  //on calcul ou commencer dans le tableau map
  int xTab = int(xPers/60)-5;
  int yTab = int(yPers/60)-5;
  
  
  stroke(200);
  
  for(int y = 0; y < (height/60)+2;y++){
    for(int x = 0; x < (width/60)+2;x++){
      if((y+yTab) >= 0 && (x+xTab) >= 0 && (x+xTab) < 100 && (y+yTab) < 100){
        if(map[y+yTab][x+xTab] == 0)fill(255);;
        if(map[y+yTab][x+xTab] == 1)image(herbe,x*60+xDep,y*60+yDep,60,60);
        if(map[y+yTab][x+xTab] == 2)image(sable,x*60+xDep,y*60+yDep,60,60);
        if(map[y+yTab][x+xTab] == 3)image(eau,x*60+xDep,y*60+yDep,60,60);
        if(map[y+yTab][x+xTab] == 4)image(route,x*60+xDep,y*60+yDep,60,60);
        if(map[y+yTab][x+xTab] == 5)image(chemin,x*60+xDep,y*60+yDep,60,60);
        if(map[y+yTab][x+xTab] == 6)image(beton,x*60+xDep,y*60+yDep,60,60);  
      }
      else image(lave,x*60+xDep,y*60+yDep,60,60);
    }
  }
  
  stroke(0);
  
  
  
  
}

void affiche_limite(){
   
  strokeWeight(5);
  line(width/2 - (xPers - 0),height/2 - (yPers - 0),width/2 - (xPers - 0),height/2 - (yPers - 6000));
  line(width/2 - (xPers - 0),height/2 - (yPers - 0),width/2 - (xPers - 6000),height/2 - (yPers - 0));
  line(width/2 - (xPers - 0),height/2 - (yPers - 6000),width/2 - (xPers - 6000),height/2 - (yPers - 6000));
  line(width/2 - (xPers - 6000),height/2 - (yPers - 0),width/2 - (xPers - 6000),height/2 - (yPers - 6000));
  strokeWeight(1);
}

void afficheMiniMap(){
  fill(255);
  
  rect(width-111,height-111,101,101);
  
  for(int i = 0; i < 100;i++){
    for(int j = 0; j < 100; j++){
      if(map[i][j] == 0)fill(255);
      if(map[i][j] == 1)image(herbe,j+(width-110),i+(height-110),1,1);
      if(map[i][j] == 2)image(sable,j+(width-110),i+(height-110),1,1);
      if(map[i][j] == 3)image(eau,j+(width-110),i+(height-110),1,1);
      if(map[i][j] == 4)image(route,j+(width-110),i+(height-110),1,1);
      if(map[i][j] == 5)image(chemin,j+(width-110),i+(height-110),1,1);
      if(map[i][j] == 6)image(beton,j+(width-110),i+(height-110),1,1);      
      
    }  
  }
  fill(255,0,0);
  stroke(255,0,0);
  ellipse((xPers/60)+(width-111),(yPers/60)+(height-111),3,3);
  stroke(0);
  
  //on affiche les bases ennemies
  fill(255,0,0);
  ellipse((baseA.getX()/60)+(width-111),(baseA.getY()/60)+(height-111),10,10);
  fill(0,100,255);
  ellipse((baseB.getX()/60)+(width-111),(baseB.getY()/60)+(height-111),10,10);
  
  
}

void afficheObjet(){
  for(int i = 0; i < nb_arbre;i++){
    int x = width/2 - (xPers - arbre[i].x); 
    int y = height/2 - (yPers - arbre[i].y); 
    
    
    image(arbreimg,x,y,70,70);
  }    
  
}

void afficheTchat(){
  textSize(12);
  
  fill(255,255,255,100);
  
  
  
  float tailleMax = 0;
  
  //on remplace toutes ligne null par rien pour éviter de marque null à chaque fois
  for(int i = 0; i < 5;i++){
    if(tchat[i] == null){
      tchat[i] = "";  
    }
    //on calcul aussi la taille du plus grand message afin d'adapter le rectangle
    tailleMax = textWidth(tchat[i]);
  }
  
  rect(10,height-125,tailleMax+30,120);
  
  fill(255); 
  text(tchat[4]+"\n"+tchat[3]+"\n"+tchat[2]+"\n"+tchat[1]+"\n"+tchat[0]+"\n",19,height-110); 
  fill(0); 
  text(tchat[4]+"\n"+tchat[3]+"\n"+tchat[2]+"\n"+tchat[1]+"\n"+tchat[0]+"\n",20,height-110);  
  
  //on regarde pour les messages importants
  if(tchatImportant != null && millis() - timeTchatImportant < 5000){
    //on l'affiche
    
    textSize(25);
    textAlign(CENTER);
    fill(255);
    text(tchatImportant,width/2-1,height-199);
    fill(0);
    text(tchatImportant,width/2,height-200);
    textAlign(LEFT);
    
  }
  
}

void setAnglePers(){
  float x = mouseX-(width/2);
  float y = mouseY-(height/2);
  
  
  if(y == 0)y = 1;
  
  if(mouseY < height/2){
    angle = 90+(atan(x/y) * 180 / PI);
  }
  else{
    angle = 270+(atan(x/y) * 180 / PI);  
  }
  
  angle = 360 - angle;  
  
  
}

void afficheBalle(){
  //Ici on affiche toutes les balles
  for(int i = 0; i < nb_balle;i++){
    int x = width/2 - (xPers - balle[i].getX()); 
    int y = height/2 - (yPers - balle[i].getY()); 
    
    
    fill(0);
    stroke(0);
    ellipse(x,y,2,2);
    
  }
  
}

void mousePressed(){
  tir_en_cours = 1;  
  
}

void mouseReleased(){
  tir_en_cours = 0;  
  
}

void afficheHitMarker(){
  //Les hitsmarkers servent à indiqué au joueur qu'il a touché son adversaire
  for(int i = 0; i < nb_balle;i++){
    for(int j = 0; j < nb_joueur;j++){
      //On calcul la distance entre les balles et les personnages:
      float distance = sqrt(abs(balle[i].getX() - joueur[j].getX())*abs(balle[i].getX() - joueur[j].getX())+abs(balle[i].getY() - joueur[j].getY())*abs(balle[i].getY() - joueur[j].getY()));
      if(distance < 40){
        if(nb_hit_marker < 9){
          hitmarker[nb_hit_marker].setValeur(-10); 
          hitmarker[nb_hit_marker].setX(balle[i].getX()-10);
          hitmarker[nb_hit_marker].setY(balle[i].getY()-10); 
          hitmarker[nb_hit_marker].tmp_aff = millis(); 
          
          nb_hit_marker++;
        }
      }
    }    
  }
  
  //maintenant ont les affiches
  for(int i = 0; i < nb_hit_marker;i++){
    fill(255,0,0);
    
    int x = width/2 - (xPers - hitmarker[i].x);
    int y = height/2 - (yPers - hitmarker[i].y);
    
    textSize(15);
    
    text(hitmarker[i].getValeur(),x,y);
    
    if(millis() - hitmarker[i].tmp_aff > 500){
      nb_hit_marker--;  
    }
  }
  
}


void afficheBase(){
 int x = width/2 - (xPers - baseA.getX());
 int y = height/2 - (yPers - baseA.getY()); 
  
 if(baseA.vie > 0){  
   image(imgBaseA,x,y);
 }
 
 x = width/2 - (xPers - baseB.getX());
 y = height/2 - (yPers - baseB.getY()); 
 
 if(baseB.vie > 0){  
   image(imgBaseB,x,y);;
 }
  
}


void demandePseudo(){
  fill(255);
  textSize(25);
  textAlign(CENTER);
  text("Comment souhaites tu t'appeler?",width/2,250);
  fill(0);
  textSize(25);
  text("Comment souhaites tu t'appeler?",width/2-1,249);
  textAlign(LEFT);
  
  
  if(keyPressed == true && antiRepet == 0){
    antiRepet = 1;
    //on vérifie si l'utilisateur ne veux pas supprimer un caractère
    if(keyCode == LEFT){
      //Cette manipulation permet de supprimer un caractère.
      String newPseudo = "";
      for(int i = 0; i < pseudo.length()-1;i++){
        newPseudo = newPseudo + pseudo.charAt(i);
      }
      pseudo = newPseudo;  
    }
    
    else if(pseudo.length() < 9){
      //On limite à 9 caractères
      pseudo = pseudo + key;
    }
    
  }
  if(keyPressed == false && antiRepet == 1){
    antiRepet = 0;  
  }
  
  fill(200);
  rect((width-250)/2,(height-70)/2,250,70);
  
  fill(0);
  textSize(45);
  text(pseudo+"|",(width-250)/2+5,(height-70)/2+50);
  
  //on affiche un bouton valider
  
  fill(0,200,0); 
  
  //la couleur(et le curseur) vari en fonction de si le curseur est sur le bouton ou non
  if(mouseX > (width-150)/2 && mouseX < (width-150)/2 + 150 && mouseY > (height-60)/2+70 && mouseY < (height-60)/2 + 130){
    cursor(HAND);
    fill(0,100,0);
    
    //Si jamais on clique, ça valide
    if(mousePressed == true){
      pseudo_OK = 1;  
    }
  }
  else if(mouseX > (width-250)/2 && mouseX < (width-250)/2 + 250 && mouseY > (height-70)/2 && mouseY < (height-70)/2 + 70){
    cursor(TEXT);
  }
  else{
    cursor(ARROW);   
  }

  
  rect((width-150)/2,(height-60)/2+70,150,60);
  
  textSize(30);
  fill(0);
  text("VALIDER",(width-150)/2+13,(height-60)/2+110);
  
}


void infoCarte(){
  //affichage pseudo personnage + pv
  for(int i = 0; i < nb_joueur;i++){
    int x = width/2 - (xPers - joueur[i].getX());
    int y = height/2 - (yPers - joueur[i].getY()); 
    if(joueur[i].getEquipe() == 1){
      fill(255,0,0,100);
    }
    else{
      fill(0,50,255,100);  
    }
    rect(x-50,y+40,100,40);
    fill(255,255,0);
    textSize(15);
    text(joueur[i].getPseudo()+"("+str(joueur[i].action)+")",x-40,y+55);
    fill(0,255,0,75);
    rect(x-48,y+65,map(joueur[i].getVie(),0,100,0,96),10);
    noFill();
    rect(x-48,y+65,96,10);
  }
  
  //on affiche la carte
  if(equipe == 1){
    fill(255,0,0,100);
  }
  else{
    fill(0,50,255,100);  
  }
  rect(10,10,150,60);
  fill(255,255,0);
  textSize(20);
  text(pseudo,15,35);
  fill(0,255,0,75);
  rect(12,50,map(pv,0,100,0,146),15);
  noFill();
  rect(12,50,146,15);
  
  
}

void affichePvBase(){
  //barre de pv des bases:
  fill(0);
  stroke(255,0,0);
  rect((width-109)-2,(height-158)-2,100,15);
  float xBar = map(baseA.vie,0,5000,0,96);
  fill(255,0,0);
  rect(width-109,height-158,xBar,11);
  
  fill(0);
  stroke(0,100,255);
  rect((width-109)-2,(height-133)-2,100,15);
  xBar = map(baseB.vie,0,5000,0,96);
  fill(0,100,255);
  rect(width-109,height-133,xBar,11);  
  
}

void afficheEcranFin(){
  //Cette écran correspond à l'affichage de la victoire ou de la défaite.
  
  
  textAlign(CENTER);
  textSize(50);

  
  if(equipe == 1 && baseB.vie <= 0){
    //Victoire  
    fill(255);
    text("Bravo vous etes\nles VAINQUEURS!!!",width/2,height/2-100);
    fill(100,0,0);
    text("Bravo vous etes\nles VAINQUEURS!!!",width/2,height/2-99);
  }
  if(equipe == 2 && baseB.vie <= 0){
    //Defaite  
    fill(255);
    text("vous avez\nPERDU!!!",width/2,height/2-100);
    fill(0,0,100);
    text("vous avez\nPERDU!!!",width/2,height/2-99);
  }
  if(equipe == 1 && baseA.vie <= 0){
    //Defaite
    fill(255);
    text("vous avez\nPERDU!!!",width/2,height/2-100);
    fill(100,0,0);
    text("vous avez\nPERDU!!!",width/2,height/2-99);
  }
  if(equipe == 2 && baseA.vie <= 0){
    //Victoire
    fill(255);
    text("Bravo vous etes\nles VAINQUEURS!!!",width/2,height/2-100);
    fill(0,0,100);
    text("Bravo vous etes\nles VAINQUEURS!!!",width/2,height/2-99);
  }
  
  textAlign(LEFT);
  
}

void choisPerso(){
  fill(255,220,200);
  
  rect((width-300)/2,(height-400)/2,300,400);
  
  String[] listePerso = loadStrings("perso");
  
  JSONObject json = parseJSONObject(listePerso[0]);
  
  JSONArray persoTab = json.getJSONArray("perso");
  
  //personnage choisi
  JSONObject caract_perso = persoTab.getJSONObject(personnage_choix);
  
  
  fill(0);
  textSize(25);
  
  //nom
  textAlign(CENTER);
  text(caract_perso.getString("nom"),width/2,(height-400)/2+50);
  textAlign(LEFT);
  
  //Cadre pour image
  noFill();
  rect((width-250)/2,(height-400)/2+60,250,150);
  
  //on affiche l'image du personnages
  PImage apercuPers = loadImage(caract_perso.getString("img"));
  image(apercuPers,(width-150)/2,(height-400)/2+60,150,150);
  
 
  //chaque propriéte
  textSize(15);
  text("Vie",(width-250)/2+20,(height-400)/2+250);
  rect((width-250)/2+20,(height-400)/2+255,200,15);
  fill(50,255,75);
  rect((width-250)/2+21,(height-400)/2+256,map(caract_perso.getInt("pv"),0,200,0,198),13);
  
  fill(0);
  text("Bouclier",(width-250)/2+20,(height-400)/2+300);
  noFill();
  rect((width-250)/2+21,(height-400)/2+305,200,15);
  fill(50,100,255);
  rect((width-250)/2+22,(height-400)/2+306,map(caract_perso.getInt("resist"),0,100,0,198),13);
  
  fill(0);
  text("Vitesse",(width-250)/2+20,(height-400)/2+350);
  noFill();
  rect((width-250)/2+21,(height-400)/2+355,200,15);
  fill(255,50,75);
  rect((width-250)/2+22,(height-400)/2+356,map(caract_perso.getInt("vitesse"),0,15,0,198),13);
  
  if(mousePressed == true){
    if(mouseX > width/2){
      if(personnage_choix < 2){
        personnage_choix++;     
      }
    }
    else{
      if(personnage_choix > 0){
        personnage_choix--;  
      }
    }
    delay(100);
  }
  if(keyPressed == true){
    perso_OK = 1;  
    
  }
  
  
  
  
}

void deplacementJoueur(){
  int vitesse = 10;
  for(int i = 0; i < nb_joueur;i++){
    if(joueur[i].action == 1){
      joueur[i].y -= vitesse;  
    }   
    if(joueur[i].action == 2){
      joueur[i].x += vitesse;    
    } 
    if(joueur[i].action == 3){
      joueur[i].y += vitesse;    
    } 
    if(joueur[i].action == 4){
      joueur[i].x -= vitesse;    
    } 
  }  
}
