 short screenW=800;short screenH=600;
 
 import java.util.List;
 import java.util.HashSet;
 
 List<GameCharacter> characters;
 //HashSet<Character> keysUsedInGame;
 HashSet<Character> activeKeys;

 PlayerCharacter playerCharacter;
 abstract class State {
   abstract public void handleInput();
   abstract public void update();
 }
 short walkingSpeed=4;
 class WalkingState extends State{
    public void handleInput(){
      if(activeKeys.contains('a'))
        playerCharacter.setVx((short)(-walkingSpeed));
      else if(activeKeys.contains('d'))
        playerCharacter.setVx((short)(walkingSpeed));
      else {}
        //playerCharacter.nothing();
    }
    public void update(){
    }
 }
  class RunningState extends State{
    public void handleInput(){
      if(activeKeys.contains('q'))
        playerCharacter.setVx((short)(-walkingSpeed*2));
      else if(activeKeys.contains('e'))
        playerCharacter.setVx((short)(walkingSpeed*2));
      else {}
        //playerCharacter.nothing();
    }
    public void update(){
    }
 }
  class JumpingState extends State{
    public void handleInput(){      
      if(activeKeys.contains('w'))
        playerCharacter.setVy((short)(-10));
    }
    public void update(){
    }
 }
 class LadderState extends State{public void update(){}    public void handleInput(){   
   short epsilon=1;
      if(activeKeys.contains('o')){println("ladder up");playerCharacter.setY((short)(playerCharacter.getY()-epsilon));}
      if(activeKeys.contains('l'))playerCharacter.setY((short)(playerCharacter.getY()+epsilon));
    }}
 class NothingState extends State{
    public void handleInput(){           
      playerCharacter.setVx((short)(0));
      playerCharacter.setVy((short)(0));
    }
    public void update(){}
 }
 void keyPressed()
{
  // If the key is between 'A'(65) to 'Z' and 'a' to 'z'(122)
  if((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) {
    //if(keysUsedInGame.contains(key)) 
    {
      activeKeys.add(key);
      //playerCharacter.walk();
    }
  }
}
 void keyReleased()
{
  // If the key is between 'A'(65) to 'Z' and 'a' to 'z'(122)
  //if((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) 
  {
    //if(key == 'w' || key == 'W') 
    {
      activeKeys.remove(key);
      //playerCharacter.nothing();
    }
  }
}
 interface Jumpable{public void jump();}interface Drawable{public void drawIt();}
 abstract class GameCharacter implements Drawable{
   //public void jump(){state = new JumpingState();}
   //public void run(){state = new RunningState();}
   //public void walk(){state = new WalkingState();}
   //public void nothing(){state = new NothingState();}
   abstract public void drawIt();//{rectMode(CENTER); rect(x,y-50,20,50);}
   abstract public void update();//{x+=vx;y+=vy;state.handleInput();}
   //State state;
   short x;short y;public short getX(){return x;}public short getY(){return y;}public void setX(short x){this.x=x;}public void setY(short y){this.y=y;}
   short vx;short vy;public void setVx(short vx){this.vx=vx;}public void setVy(short vy){this.vy=vy;}public short getVx(){return vx;}public short getVy(){return vy;}
   short ax;short ay;   public void setAx(short ax){this.ax=ax;}public void setAy(short ay){this.ay=ay;}
   short w;short h;public short getW(){return w;}public short getH(){return h;}
   public GameCharacter()
   {
     //x=(short)(w/2);y=h;
     //state = new NothingState();
   }
      public GameCharacter(short x,short y)
   {
     this.x=x;this.y=y;
   }
 }
 short gravity=1;
  class PlayerCharacter extends GameCharacter implements Jumpable{
    public String playerAsString(){return "x:"+x+", y:"+y;}
   public void jump(){state = new JumpingState();}
   public void run(){state = new RunningState();}
   public void walk(){state = new WalkingState();}
   public void nothing(){state = new NothingState();}
   public void ladder(){state = new LadderState();}
   public void drawIt(){//rectMode(CENTER); 
 fill(255,0,100);rect(x,y,w*5,h*5);fill(0,0,0);}
   public Character checkForCollision(GameCharacter gameCharacter){
     
     //collision under playerCharacter
     short epsilon=9;
     
     if(gameCharacter instanceof Ladder){       
     if(!(x+w<gameCharacter.getX()||x>gameCharacter.getX()+gameCharacter.getW())){
              if(!(y+h<gameCharacter.getY()||y>gameCharacter.getY()+gameCharacter.getH()))
              {
                //println("Ladder collision");
   return DOWN;
              }
     }
   }
     
     
     if(vy>0)
     if(x+w>=gameCharacter.getX()&&x<=gameCharacter.getX()+gameCharacter.getW())
       if(y+h<=gameCharacter.getY()+epsilon &&y+h>=gameCharacter.getY()-epsilon)//||x>gameCharacter.getX()+gameCharacter.getW())
       {
   return DOWN;   
       }
       if(x+w>=gameCharacter.getX()&&x<=gameCharacter.getX()+gameCharacter.getW())
       if(gameCharacter.getY()<=y+h+epsilon &&gameCharacter.getY()>=y+h-epsilon)//||x>gameCharacter.getX()+gameCharacter.getW())
       {
   return UP;   
       }
   return 0;
 } boolean ladderCollision=false;
   public void update(){
     if(isInTheAir){
       //if(vy<=0)
       vy+=gravity;
       x+=vx;y+=vy;
       if(x<0)x=0;if(x>screenW-w)x=(short)(screenW-w);
       return;
     }//vy=0;
     if((ladderCollision && (activeKeys.contains('o')||activeKeys.contains('l')))||
     ((state instanceof LadderState)&&activeKeys.size()==0)
     )playerCharacter.ladder();else 
   if(activeKeys.contains('q')||activeKeys.contains('e'))playerCharacter.run();
   else if(activeKeys.contains('a')||activeKeys.contains('d'))playerCharacter.walk();else playerCharacter.nothing();
   if(activeKeys.contains('w'))playerCharacter.jump();
   x+=vx;/*if(random(1)<0.1)*/y+=vy;state.handleInput();
   if(x<0)x=0;if(x+w>screenW)x=(short)(screenW-w);
   
 } 
   State state;
 boolean isInTheAir=true; boolean getIsInTheAir(){return isInTheAir;}void setIsInTheAir(boolean isInTheAir){this.isInTheAir= isInTheAir;}
   //short x;short y;short vx;short vy;short ax;short ay;
   //public void setVx(short vx){this.vx=vx;}public void setVy(short vy){this.vy=vy;}
   public PlayerCharacter()
   {
     w=2;h=2;
     x=(short)(screenW/2);y=(short)(screenH-25);
     state = new NothingState();
   }
 }
 class Platform extends GameCharacter{
   public void drawIt(){//rectMode(CENTER); 
 rect(x,y,w,h);}
   public void update(){}
   public Platform(short x,short y){super(x,y);w=screenW;h=20;}
   public Platform(short x,short y,short w,short h){super(x,y);this.w=w;this.h=h;}
 }
  class Ladder extends GameCharacter{
   public void drawIt(){//rectMode(CENTER); 
 rect(x,y,w,h);}
   public void update(){}
   public Ladder(short x,short y){super(x,y);w=10;h=80;}
   public Ladder(short x,short y,short w,short h){super(x,y);this.w=w;this.h=h;}
 }
 
//abstract class Command<T>
//{
//abstract public void execute(T o);
//}
//class JumpCommand extends Command<Jumpable>{
//  public void execute(Jumpable j){j.jump();}
//}
 
  void setup()  {   
    frameRate(60);
          size(800,600); // Set the size of the window 
          screenW=(short)width;screenH=(short)height;
           smooth(); 
            //keysUsedInGame = new HashSet<Character>();keysUsedInGame.add('w');keysUsedInGame.add('s');keysUsedInGame.add('a');keysUsedInGame.add('d');keysUsedInGame.add('q');keysUsedInGame.add('e');
            activeKeys = new HashSet<Character>();
           characters = new ArrayList<GameCharacter>();
           
           GameCharacter platform = new Platform((short)(0),(short)(screenH-20));characters.add(platform);
           platform = new Platform((short)(20),(short)(screenH-100),(short)(screenW-20),(short)(20));characters.add(platform);
           platform = new Platform((short)(40),(short)(screenH-180),(short)(screenW-40),(short)(20));characters.add(platform);
           
           platform = new Platform((short)(80),(short)(screenH-260),(short)(screenW-80),(short)(20));characters.add(platform);
           platform = new Platform((short)(100),(short)(screenH-340),(short)(screenW-100),(short)(20));characters.add(platform);
           platform = new Platform((short)(120),(short)(screenH-420),(short)(screenW-120),(short)(20));characters.add(platform);
           platform = new Platform((short)(140),(short)(screenH-500),(short)(screenW-140),(short)(20));characters.add(platform);
           //platform = new Platform((short)(160),(short)(screenH-580),(short)(screenW-160),(short)(20));characters.add(platform);
           
           GameCharacter ladder = new Ladder((short)(screenW/4),(short)(screenH-100));characters.add(ladder);
           ladder = new Ladder((short)(3*screenW/4),(short)(screenH-180));characters.add(ladder);
           
           ladder = new Ladder((short)(screenW/4),(short)(screenH-260));characters.add(ladder);
           ladder = new Ladder((short)(3*screenW/4),(short)(screenH-340));characters.add(ladder);
           ladder = new Ladder((short)(screenW/4),(short)(screenH-420));characters.add(ladder);
           ladder = new Ladder((short)(3*screenW/4),(short)(screenH-500));characters.add(ladder);
           
           playerCharacter = new PlayerCharacter();
           characters.add(playerCharacter);
           }   
           int t=0;
   void draw()  {
     
     background(255); 
   fill(0);
   boolean airFlag=!(playerCharacter.state instanceof LadderState) ? true:false;
   boolean ladderFlag=false;
   
   //if(playerCharacter.state instanceof LadderState)println("LadderState" );
   
   for(GameCharacter gameCharacter : characters){
     if(gameCharacter!=playerCharacter){if(gameCharacter instanceof Platform ){
       if (playerCharacter.checkForCollision(gameCharacter)==DOWN){         //println("DOWN" );
         if((playerCharacter.getIsInTheAir()&&playerCharacter.getVy()>0)||playerCharacter.state instanceof LadderState){
           playerCharacter.setY((short)(gameCharacter.getY()-playerCharacter.getH()));
           playerCharacter.setIsInTheAir(false);airFlag=false;
   }playerCharacter.setVy((short)0);
   
 }else 
 if(airFlag)playerCharacter.setIsInTheAir(true); }
 
 if(gameCharacter instanceof Ladder ){
   fill(60,42,42);
   if (playerCharacter.checkForCollision(gameCharacter)==DOWN || playerCharacter.checkForCollision(gameCharacter)==UP)
     ladderFlag=true;//playerCharacter.ladderCollision=true; else playerCharacter.ladderCollision=false; 
   
 }
     }
 
 
 
     gameCharacter.update();
     gameCharacter.drawIt();
   }     
   if(ladderFlag)playerCharacter.ladderCollision=true; else playerCharacter.ladderCollision=false;
     }