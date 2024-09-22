#include<stdio.h>
#include<assert.h>
#include<stdlib.h>

int anotherGame(void)
{
  char answer;

  do
  { 
      printf("Do you want to play another game? [y/n]: ");
      answer = tolower(getchar());
  }
  while (! (answer == 'y' || answer == 'n'));
  
  if (answer == 'y')
    return 1;
  else 
    return 0;
} 

int * readGuess()
{
	printf(" Enter your guess: \n");
	
	int *guess;
	guess = malloc(4 * sizeof(*guess));

	for (int i = 0; i < 4; i++)
	{
		do
		  {
				scanf("%d", &guess[i]);
			}
		while (guess[i] < 1 || guess[i] > 9);
	}        
	return guess;
}

int blackScore(int guess[], int code[]) 
{

	int score = 0;
	for (int i = 0; i < 4; i++) 
	{
		if (code[i] == guess[i])
			score++;
	}

	return score;
}

int whiteScore(int guess[], int code[])
{

	int score = 0;
	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			if (i != j && code[i] == guess[j])
				score++;
		}
	}
	return score;
}

void printScore(int g[], int c[]) 
{
	printf("\n(%d, %d)", blackScore(g, c), whiteScore(g, c));
}


int main(void) 
{
	int codes[5][4] = 
		{{1, 8, 9, 2}, {2, 4, 6, 8}, {1, 9, 8, 3}, {7, 4, 2, 1}, {4, 6, 8, 9}};  

	for (int i = 0; i < 4; i++) 
	{
		int *guess;
		guess = readGuess();
		while (blackScore(
						guess, 
						codes[i] 
					) != 4)
		{
			printScore(guess, codes[i]);	
			guess = readGuess();
		}

	  printf("You have guessed correctly!");
	  if (i < 4) 
		  if (anotherGame() == 0)
			  break;
	}
}
