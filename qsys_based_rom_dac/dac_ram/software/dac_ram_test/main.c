/*
 * main.c
 *
 *  Created on: Mar 21, 2017
 *      Author: parin
 */


#include "stdio.h"
#include "io.h"
#include "system.h"

int main(void)
{
	unsigned int a=10,b=10,c,ans;
	int i;
	c=(a << 16)+b;
	IOWR(DAC_RAM_0_BASE ,0,c);
	for(i=0;i<30;i++);
	ans=IORD(DAC_RAM_0_BASE ,0);
	printf("%d",ans);
	while(1);

}

