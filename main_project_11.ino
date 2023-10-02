//--------------------------------------------- Kütüphaneler Bölümü -------------------------------------------------------
#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>
#include <Servo.h>
#include "HX711.h" // ÖNEMLİ! "HX711 scale" olan kısmı buraya yazınca internete bağlanmıyor. o yüzden ben de setup ve loop kısımlarına ayrı ayrı yazdım.

//--------------------------------------------- Tanımlamalar Bölümü -------------------------------------------------------

//1. Firebase veritabanı adresini, Token bilgisini ve ağ adresi bilgilerinizi giriniz.
#define FIREBASE_HOST "bitirme-projesi-23-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "YHFqWycHGKvahzhCuccwMXlbyFiq7anhOgehLScR"
//#define WIFI_SSID "bitirme"
#define WIFI_SSID "Fatih iPhone’u"
#define WIFI_PASSWORD "bitirme23"

#define DOUT  D3 //loadcell DT-D3
#define CLK  D4 //loadcell SCK-D4

#define trig_depo 14  //trig-D5ve gnd 5v arduinoya bağlı
#define echo_depo 12  //echo-D6ve gnd 5v arduinoya bağlı
#define trig_arac 13  //trig-D7ve gnd 5v arduinoya bağlı
#define echo_arac 15  //echo-D8ve gnd 5v arduinoya bağlı

Servo servo; //servoyu D1 pinine bağladık

long duration, distance, UltraSensorDepo, UltraSensorArac;

//float calibration_factor = -109525; //-106600 worked for my 40Kg max scale setup
//float calibration_factor =  -17034.36;
//float calibration_factor =  -375;
float calibration_factor =  394.86;


//2. veritabanim adında bir firebase veritabanı nesnesi oluşturuyoruz
FirebaseData veritabanim;

//--------------------------------------------- Void Setup Bölümü -------------------------------------------------------
void setup()
{


  Serial.begin(115200);

//------------- İnternet Bağlantısı ------------------

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Ağ Bağlantısı Oluşturuluyor");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("IP adresine bağlanıldı: ");
  Serial.println(WiFi.localIP());
  Serial.println();


  //------- 3. Firebase bağlantısı başlatılıyor ------

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  //4. Ağ bağlantısı kesilirse tekrar bağlanmasına izin veriyoruz
  Firebase.reconnectWiFi(true);

//------------------------------------

 pinMode(D2,OUTPUT);
 digitalWrite(D2,LOW);


 pinMode(trig_depo, OUTPUT); // Sets the trigPin as an Output
 pinMode(echo_depo, INPUT); // Sets the echoPin as an Input
 pinMode(trig_arac, OUTPUT); // Sets the trigPin as an Output
 pinMode(echo_arac, INPUT); // Sets the echoPin as an Input


 servo.attach(5); //servoyu D1 pinine bağladık
 servo.write(120); //120 yap


 HX711 scale(DOUT, CLK);
 scale.set_scale();

 scale.tare(); //Reset the scale to 0

 long zero_factor = scale.read_average(); 

 delay(2000);
}

//----------------------------------- Void Loop Bölümü ---------------------------------------------------------------
void loop()
{
  HX711 scale(DOUT, CLK);
  scale.set_scale(calibration_factor); 
  int agirlik = scale.get_units() - 97;

//------------------ Firebase Get Bölümü ------------------------------
  
int a = Firebase.getInt(veritabanim, "/dailySpecial/kantar");
int kantar1 = veritabanim.intData();

int b = Firebase.getInt(veritabanim, "/dailySpecial/depo");
int depo1 = veritabanim.intData();

int d = Firebase.getInt(veritabanim, "/dailySpecial/istenenDepo/istenenDepo");
int istenendepo1 = veritabanim.intData();

int i = Firebase.getInt(veritabanim, "/dailySpecial/istenenDepoDurum/istenenDepoDurum");
int istenendepodurum1 = veritabanim.intData();

Firebase.getString(veritabanim, "/dailySpecial/otomatik/otomatik");
String oto_durum1 = veritabanim.stringData();

Firebase.getString(veritabanim, "/Kontrol/Servo");
String servo_durum1 = veritabanim.stringData();

Firebase.getString(veritabanim, "/dailySpecial/description");
String arac_durum1 = veritabanim.stringData();

int manuel_agirlik = agirlik + istenendepo1;
int oto_agirlik = agirlik + 40; // 100 - otomatik modda araca 100g eklenince sistemi durdur (agirlik == oto_agirlik olunca durdur gibi ama mesela durdurunca 100 gr yerine vakitten dolayı 130 gr oluyorsa agirlik == oto_agirlik-30 dersin yine öyle de çözülebilir)

//------------------------------

SonarSensor(trig_depo, echo_depo);
UltraSensorDepo = distance;

SonarSensor(trig_arac, echo_arac);
UltraSensorArac = distance;

//------------------ Firebase Set Bölümü ------------------------------

  //---------------- agirlik, depo ve arac kontrolu yapimi ------------------------
  Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);

//----------------

      if (UltraSensorArac<=5){
  Firebase.setString(veritabanim, "/dailySpecial/description", "Yerlesti");
}
 else {
    Firebase.setString(veritabanim, "/dailySpecial/description", "Yerlesmedi");
}

//----------------
// NOT: BİRDEN FAZLA ELSEİF OLUNCA YÜZDE60 I GÖRÜYOR SİSTEM SADECE, 40 20 VS OLMADI. NEDEN BİLMİYORUM

   if (UltraSensorDepo>=1 && UltraSensorDepo<=5){
  Firebase.setInt(veritabanim, "/dailySpecial/depo", 100);
}
 else {
    Firebase.setInt(veritabanim, "/dailySpecial/depo", 0);
}

//--------------------------------------- ANA KONTROLLER ---------------------------------------
  if (istenendepodurum1 == 0){ //depodurum 0
                HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            int agirlik = scale.get_units() - 97; //95
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);
    
    Serial.println("ŞUAN DEPO DURUM 0'DA");
    
    if (oto_durum1 == "Acik"){ //otomatik açık
                  HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);
      
      Serial.println("OTOMATİK AÇIK");
      
      if (depo1 != 0){ // yeterli yük var
                    HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);

        Serial.println("YETERLİ YÜK VAR");

        if (arac_durum1 == "Yerlesti"){ //araç yerleşti
                      HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);
          
          Serial.println("ARAÇ YERLEŞTİ");
          int oto_agirlik = agirlik + 40; //100
          
          while (agirlik < oto_agirlik) // eğer a değeri 50 küçük ise while çalışsın.
  {//while
    Serial.println("YÜK OTOMATİK BOŞALTILIYOR..");
            
            servo.write(0); //0 yap
            HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            delay(500);
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);
            Serial.println("istenen ağırlık:");
            Serial.println(oto_agirlik);
            Serial.println(" ");
            Serial.println("ağırlık:");
            Serial.println(agirlik);
delay(200); // 200 ms bekle
if (agirlik >= oto_agirlik){//break
  break;
  }//break

  }//while
  Serial.println("YÜK OTOMATİK BOŞALTILDI");
            servo.write(120); //120 yap
            while(UltraSensorArac<=5)
            {
                digitalWrite(trig_arac, LOW);
  delayMicroseconds(2);
  digitalWrite(trig_arac, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig_arac, LOW);

  duration = pulseIn(echo_arac, HIGH);
  distance = (duration/2) / 29.1;
  UltraSensorArac = distance;
              
  Firebase.setString(veritabanim, "/dailySpecial/description", "Yerlesti");
  HX711 scale(DOUT, CLK);
              scale.set_scale(calibration_factor); 
              int agirlik = scale.get_units() - 97;
              Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);
              Serial.println(agirlik);
              delay(200);
              //Firebase.getString(veritabanim, "/dailySpecial/description");
               //String arac_durum1 = veritabanim.stringData();
               Serial.println("YERLEŞTİ DÖNGÜSÜ");

 if(UltraSensorArac>5) {
    Firebase.setString(veritabanim, "/dailySpecial/description", "Yerlesmedi");
    delay(1500);
  break;
}    
              }
            //Firebase.setString(veritabanim, "/dailySpecial/description", "Yerlesmedi");
            Serial.println("SİSTEM YENİDEN AKTİF");
            

          /*
          if (agirlik < oto_agirlik){ //yük boşaltmayı başlat
            Serial.println("YÜK OTOMATİK BOŞALTILIYOR..");
            servo.write(120);
            delay(5000);
            
            } //yük boşaltmayı başlat
      
            else if (agirlik >= oto_agirlik){ //yük boşaltmayı durdur
            Serial.println("YÜK OTOMATİK BOŞALTILDI");
            servo.write(0);
            
            } //yük boşaltmayı durdur

            else{}

            */
          } //araç yerleşti

          
          
          else{ //araç yerleşmedi
            Serial.println("ARAÇ YERLEŞMEDİ");
            } //araç yerleşmedi
            
        } // yeterli yük var
        
        else{// yeterli yük yok
          Serial.println("YETERLİ YÜK YOK");
          }// yeterli yük yok
         
          
      }//otomatik açık
      
      else{//otomatik kapalı
        Serial.println("OTOMATİK KAPALI");
        if (servo_durum1 == "Acik"){// kapak açık
          servo.write(0); //0 yap
          Serial.println("KAPAK AÇIK");
          }// kapak açık
          else{// kapak kapalı
            servo.write(120); //120 yap
            Serial.println("KAPAK KAPALI");
            }// kapak kapalı
        }//otomatik kapalı
        
    } // depodurum 0
    
    else{ //depodurum 1
      
      Serial.println("ŞUAN DEPO DURUM 1'DE");

      HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);

      if (depo1 != 0){ // yeterli yük var
                    HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);

        Serial.println("YETERLİ YÜK VAR");

        if (arac_durum1 == "Yerlesti"){ //araç yerleşti
                      HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            delay(500);
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);
          
          Serial.println("ARAÇ YERLEŞTİ");
          int manuel_agirlik = agirlik + istenendepo1;
          
          
          while (agirlik < manuel_agirlik) // eğer a değeri 50 küçük ise while çalışsın.
  {//while
    Serial.println("YÜK MANUEL BOŞALTILIYOR..");
            
            servo.write(0); //0 yap
            HX711 scale(DOUT, CLK);
            scale.set_scale(calibration_factor); 
            int agirlik = scale.get_units() - 97;
            Firebase.setInt(veritabanim, "/dailySpecial/kantar", agirlik);
            Serial.println("istenen ağırlık:");
            Serial.println(manuel_agirlik);
            Serial.println(" ");
            Serial.println("ağırlık:");
            Serial.println(agirlik);
            
delay(200); // 200 ms bekle
if (agirlik >= manuel_agirlik){//break
  break;
  }//break

  }//while
  Serial.println("YÜK MANUEL BOŞALTILDI");
            servo.write(120); //120 yap
            

          /*
          if (agirlik < oto_agirlik){ //yük boşaltmayı başlat
            Serial.println("YÜK OTOMATİK BOŞALTILIYOR..");
            servo.write(120);
            delay(5000);
            
            } //yük boşaltmayı başlat
      
            else if (agirlik >= oto_agirlik){ //yük boşaltmayı durdur
            Serial.println("YÜK OTOMATİK BOŞALTILDI");
            servo.write(0);
            
            } //yük boşaltmayı durdur

            else{}

            */
          } //araç yerleşti

          
          
          else{ //araç yerleşmedi
            Serial.println("ARAÇ YERLEŞMEDİ");
            } //araç yerleşmedi
            
        } // yeterli yük var
        
        else{// yeterli yük yok
          Serial.println("YETERLİ YÜK YOK");
          }// yeterli yük yok
      
      } // depodurum1

    }//void loop

//----------------------------------- Void SonarSensor Bölümü ---------------------------------------------------------------
void SonarSensor(int trigPinSensor, int echoPinSensor)
{
  digitalWrite(trigPinSensor, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPinSensor, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPinSensor, LOW);

  duration = pulseIn(echoPinSensor, HIGH);
  distance = (duration/2) / 29.1;
}
