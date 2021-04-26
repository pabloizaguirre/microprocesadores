/*********************************************************************
 * pract3b.c
 *
 * Microprocessor-Based Systems
 * 2020-2021
 * Laboratory Assignment 3s2
 * Find substring and contro digit
 *
 *********************************************************************/
 
#include <stdio.h>
#include <stdlib.h>

#define MAXCOL 640
#define MAXROW 480

#define MAXPOINTS 400

#define OK 0
#define ERR -1

/***** Functions declaration *****/

/*******************************************************************************
* Name: findSubString
* 
* Aim: returns the index since the substring named “substr” is contained in the main string “str”
*
* Inputs parameters:
* 				- char *str : pointer to the string where we want to find the substring
*				- char *substr : pointer to the substring
* Returning values:
*				- int: 	the index where the substring starts
*						-1 if the substring was not found		
******************************************************************************/
int findSubString(char *str, char *substr);

/*******************************************************************************
* Name: calculateSecondDC
* 
* Aim: returns the second control digit of a bank account from a 10 digits bank account number given
* as an ASCII string.
*
* Inputs parameters:
* 				- char *bankAccountNumber: pointer to the string with the bank account number
* Returning values:
*				- unsigned int: second control digit of the bank account	
******************************************************************************/
unsigned int calculateSecondDC(char* bankAccountNumber);


//////////////////////////////////////////////////////////////////////////
///// -------------------------- MAIN ------------------------------ /////
//////////////////////////////////////////////////////////////////////////
int main( void ){
	// Variable declaration
	unsigned char option = 'e';
	char string[20];
	char substring[20];
	char accNumber[10];
	int ret;
	
	
	//Ask the user for a choice
	printf("Choose the option you want to test: \n");
	printf("a - Find a substring in a string \n");
	printf("b - Find the second control digit of a bank account \n");
	scanf("%c", &option);
	
	//Comprueba es una opcion valida del menu
	if (option >= 'a' && option <= 'b'){
		printf("-Option chosen --> %c -\n",option);
	}else{
		printf("-Option %c: incorrect. Outside from [a,b]\n Bye\n",option);
		return ERR;
	}
	
	//Depending of the chosen option we execute in assembler one function or another
	switch(option){
		
		
		//find substring
		case 'a': 
				printf("Introduce a string (max 20 characters): \n");
				fflush(stdin);
				fgets(string, 21, stdin);
				strtok(string, "\n");
				printf("Introduce a substring (max 20 characters): \n");
				fflush(stdin);
				fgets(substring, 21, stdin);
				strtok(substring, "\n");
				ret = findSubString(string, substring);
				
				if(ret == ERR) printf("The substring was not found in the string\n");
				else printf("The substring was found in the index: %d\n", ret);
				break;
				
				
		//calculate second dc
		case 'b': 
				printf("Introduce your bank accuont number (max 10 digits): \n");
				fflush(stdin);
				fgets(accNumber, 11, stdin);
				strtok(accNumber, "\n");
				ret = calculateSecondDC(accNumber);
				
				printf("The value of the second control digit is: %d", ret);
				break;	
				
		
		
								
		default: break;
							
	} // ends of switch(option)
	
	return OK;
}