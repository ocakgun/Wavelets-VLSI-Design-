/*
 * main.c
 *
 *  Created on: Mar 21, 2017
 *      Author: parin
 */



#include "stdio.h"
#include "io.h"
#include "system.h"
#include "stdint.h"
#include "altera_avalon_pio_regs.h"

int main(void)
{
	unsigned int a=0,b=10,c,ans;
	int i,j;
	unsigned int data_in=0,addres_r=2;
	unsigned int composite;
	composite= a<<16 + addres_r << 8 + data_in;

	while(1)
	{
	c=0;
	for ( i =0; i<62; i++)
	{
		IOWR(DAC_RAM_0_BASE,0,c);
		//printf("\n%d",c);
		ans=IORD(DAC_RAM_0_BASE,0);
		//printf("\n%d",ans);
		for(j=0;j<20;j++)
		{
			;
		}
		IOWR(0x11000,0,ans);
		c++;
	}
	}
	//IOWR(DAC_RAM_0_BASE,0,c);

	//ans=IORD(DAC_RAM_0_BASE,0);
	//printf("\n%d",ans);
	//IOWR(0x11000,0,ans);

}

