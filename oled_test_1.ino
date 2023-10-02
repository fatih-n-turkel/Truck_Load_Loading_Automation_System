#include "U8glib.h"
U8GLIB_SH1106_128X64 u8g(U8G_I2C_OPT_NONE);
//kırmızı A4, gri A5 pinlerine takılı

void draw(void) {
  u8g.setFont(u8g_font_profont12);
  u8g.setPrintPos(0, 10);
  u8g.print("  Fatih Naim TURKEL");
  u8g.setPrintPos(0, 25);
  u8g.print("     201813151041");
  u8g.setPrintPos(0, 45);
  u8g.print("  2023 BAHAR DONEMI");
    u8g.setFont(u8g_font_profont10);
  u8g.setPrintPos(0, 60);
  u8g.print(" Elektrik-Elektronik Muh.");

}

void draw2(void) {

  u8g.setFont(u8g_font_profont10);
  u8g.setPrintPos(0, 10);
  u8g.print("  Bitirme Projesi & Tezi");
  u8g.setPrintPos(0, 35);
  u8g.setFont(u8g_font_profont10);
  u8g.print("       Yuk Doldurma");
  u8g.setPrintPos(0, 50);
  u8g.setFont(u8g_font_profont10);
  u8g.print("     Otomasyon Sistemi");
}

void setup(void) {
}

void loop(void) {
  u8g.firstPage();
  do {
    draw();
  } while (u8g.nextPage() );
  delay(3500);
  u8g.firstPage();
  do {
    draw2();
  } while (u8g.nextPage());
  delay(3500);
}
