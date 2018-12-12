/*****************************************************************************
*
* File                : ssd1331.c
* Hardware Environment: Raspberry Pi
* Build Environment   : GCC
* Version             : V1.0.7
* Author              : Yehui
*
*              (c) Copyright 2005-2017, WaveShare
*                   http://www.waveshare.com
*                   http://www.waveshare.net   
*                      All Rights Reserved
*              
******************************************************************************/

#include <wiringPi.h>
#include <wiringPiSPI.h>
#include <stdio.h>
#include "ssd1331.h"

#define CHANNEL      0

unsigned char buffer[OLED_WIDTH * OLED_HEIGHT * 2];

void command(unsigned char cmd) {
    digitalWrite(DC, LOW);
    wiringPiSPIDataRW(CHANNEL, &cmd, 1);
}

void SSD1331_begin() {
    pinMode(RST, OUTPUT);
    pinMode(DC, OUTPUT);
    wiringPiSPISetup(CHANNEL, 2000000);    //2M

    digitalWrite(RST, HIGH);
    delay(10);
    digitalWrite(RST, LOW);
    delay(10);
    digitalWrite(RST, HIGH);

    command(DISPLAY_OFF);          //Display Off
    command(SET_CONTRAST_A);       //Set contrast for color A
    command(0xFF);                     //145 0x91
    command(SET_CONTRAST_B);       //Set contrast for color B
    command(0xFF);                     //80 0x50
    command(SET_CONTRAST_C);       //Set contrast for color C
    command(0xFF);                     //125 0x7D
    command(MASTER_CURRENT_CONTROL);//master current control
    command(0x06);                     //6
    command(SET_PRECHARGE_SPEED_A);//Set Second Pre-change Speed For ColorA
    command(0x64);                     //100
    command(SET_PRECHARGE_SPEED_B);//Set Second Pre-change Speed For ColorB
    command(0x78);                     //120
    command(SET_PRECHARGE_SPEED_C);//Set Second Pre-change Speed For ColorC
    command(0x64);                     //100
    command(SET_REMAP);            //set remap & data format
    command(0x72);                     //0x72              
    command(SET_DISPLAY_START_LINE);//Set display Start Line
    command(0x0);
    command(SET_DISPLAY_OFFSET);   //Set display offset
    command(0x0);
    command(NORMAL_DISPLAY);       //Set display mode
    command(SET_MULTIPLEX_RATIO);  //Set multiplex ratio
    command(0x3F);
    command(SET_MASTER_CONFIGURE); //Set master configuration
    command(0x8E);
    command(POWER_SAVE_MODE);      //Set Power Save Mode
    command(0x00);                     //0x00
    command(PHASE_PERIOD_ADJUSTMENT);//phase 1 and 2 period adjustment
    command(0x31);                     //0x31
    command(DISPLAY_CLOCK_DIV);    //display clock divider/oscillator frequency
    command(0xF0);
    command(SET_PRECHARGE_VOLTAGE);//Set Pre-Change Level
    command(0x3A);
    command(SET_V_VOLTAGE);        //Set vcomH
    command(0x3E);
    command(DEACTIVE_SCROLLING);   //disable scrolling
    command(NORMAL_BRIGHTNESS_DISPLAY_ON);//set display on
}

void SSD1331_clear() {
    int i;
    for(i = 0; i < sizeof(buffer); i++)
    {
        buffer[i] = 0;
    }
}

void SSD1331_draw_point(int x, int y, unsigned short hwColor) {
    if(x >= OLED_WIDTH || y >= OLED_HEIGHT)
    {
        return;
    }
    buffer[x * 2 + y * OLED_WIDTH * 2] = hwColor >> 8;
    buffer[x * 2 + y * OLED_WIDTH * 2 + 1] = hwColor;
}

void SSD1331_char1616(unsigned char x, unsigned char y, unsigned char chChar, unsigned short hwColor) {
    unsigned char i, j;
    unsigned char chTemp = 0, y0 = y;

    for (i = 0; i < 32; i ++) {
        chTemp = Font1612[chChar - 0x30][i];
        for (j = 0; j < 8; j ++) {
            if (chTemp & 0x80) {
                SSD1331_draw_point(x, y, hwColor);
            } else {
                SSD1331_draw_point(x, y, 0);
            }
            chTemp <<= 1;
            y++;
            if ((y - y0) == 16) {
                y = y0;
                x++;
                break;
            }
        }
    }
}

void SSD1331_char3216(unsigned char x, unsigned char y, unsigned char chChar, unsigned short hwColor) {
    unsigned char i, j;
    unsigned char chTemp = 0, y0 = y; 

    for (i = 0; i < 64; i++) {
        chTemp = Font3216[chChar - 0x30][i];
        for (j = 0; j < 8; j++) {
            if (chTemp & 0x80) {
                SSD1331_draw_point(x, y, hwColor);
            } else {
                SSD1331_draw_point(x, y, 0);
            }

            chTemp <<= 1;
            y++;
            if ((y - y0) == 32) {
                y = y0;
                x++;
                break;
            }
        }
    }
}

static void SSD1331_char(unsigned char x, unsigned char y, char acsii, char size, char mode, unsigned short hwColor) {
    unsigned char i, j, y0=y;
    char temp;
    unsigned char ch = acsii - ' ';
    for(i = 0;i<size;i++) {
        if(size == 12)
        {
            if(mode)temp=Font1206[ch][i];
            else temp = ~Font1206[ch][i];
        }
        else 
        {            
            if(mode)temp=Font1608[ch][i];
            else temp = ~Font1608[ch][i];
        }
        for(j =0;j<8;j++)
        {
            if(temp & 0x80) SSD1331_draw_point(x, y, hwColor);
            else SSD1331_draw_point(x, y, 0);
            temp <<=1;
            y++;
            if((y-y0)==size)
            {
                y = y0;
                x ++;
                break;
            }
        }
    }
}

void SSD1331_string(unsigned char x, unsigned char y, const char *pString, unsigned char Size, unsigned char Mode, unsigned short hwColor) {
    while (*pString != '\0') {       
        if (x > (OLED_WIDTH - Size / 2)) {
            x = 0;
            y += Size;
            if (y > (OLED_HEIGHT - Size)) {
                y = x = 0;
            }
        }
        
        SSD1331_char(x, y, *pString, Size, Mode, hwColor);
        x += Size / 2;
        pString ++;
    }
}

void SSD1331_mono_bitmap(unsigned char x, unsigned char y, const unsigned char *pBmp, char chWidth, char chHeight, unsigned short hwColor) {
    unsigned char i, j, byteWidth = (chWidth + 7) / 8;
    for(j = 0; j < chHeight; j++) {
        for(i = 0; i <chWidth; i ++) {
            if(*(pBmp + j * byteWidth + i / 8) & (128 >> (i & 7))) {
                SSD1331_draw_point(x + i, y + j, hwColor);
            }
        }
    }        
}

void SSD1331_bitmap24(unsigned char x, unsigned char y, unsigned char *pBmp, char chWidth, char chHeight) {
    unsigned char i, j;
    unsigned short hwColor;
    unsigned int temp;

    for(j = 0; j < chHeight; j++) {
        for(i = 0; i < chWidth; i ++) {
            temp = *(unsigned int*)(pBmp + i * 3 + j * 3 * chWidth);
            hwColor = RGB(((temp >> 16) & 0xFF),
                          ((temp >> 8) & 0xFF),
                           (temp & 0xFF));
            SSD1331_draw_point(x + i, y + chHeight - 1 - j, hwColor);
        }
    }
}

void SSD1331_display() {
    int txLen = 512;
    int remain = sizeof(buffer);
    unsigned char *pBuffer = buffer;
    command(SET_COLUMN_ADDRESS);
    command(0);         //cloumn start address
    command(OLED_WIDTH - 1); //cloumn end address
    command(SET_ROW_ADDRESS);
    command(0);         //page atart address
    command(OLED_HEIGHT - 1); //page end address
    digitalWrite(DC, HIGH);
    while (remain > txLen)
    {
        wiringPiSPIDataRW(CHANNEL, pBuffer, txLen);
        remain -= txLen;
        pBuffer += txLen;
    }
    wiringPiSPIDataRW(CHANNEL, pBuffer, remain);
}

void SSD1331_clear_screen(unsigned short hwColor) {
    unsigned short i, j;
    for(i = 0; i < OLED_HEIGHT; i++) {
        for(j = 0; j < OLED_WIDTH; j ++) {
            SSD1331_draw_point(j, i, hwColor);
        }
    }
}

