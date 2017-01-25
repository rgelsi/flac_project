
// Factorial
double fac(double x) {
    if(x==0){
        return (double) 1;
    }else{
        return (x*fac(x-1));
    }
}

// Greatest Common Divisor
int gcd (int a, int b) {
  int c;
  while ( a != 0 ) {
     c = a;
     a = b%a;
     b = c;
  }
  return b;
}

// Least Common Multiple
int lcm(int a, int b) {
    return (a * b) / gcd(a, b);
}

/* Compares two numbers. Returns 1 if the first number is greater than the second,
    returns 2 if the second number is greater and
    returns 0 if the numbers are the same   */
int comp(float i, float j)
{
    int greater = 0;
    if (i>j)
        greater = 1;
    else if(j>i)
        greater = 2;
    return greater;
}

/* Returns true if a number is 1 or 0, false otherwise */
int checkIfBinary(int i)
{
    return (i == 0 || i == 1) ? 1  : 0;
}

/* Converts a binary number to a decimal number and returns it. */
int binToDec(long bin)
{
    int decimal = 0, i = 0, remainder;
    while (bin!=0)
    {
        remainder = bin%10;
        if(checkIfBinary(remainder) == 1){
            bin /= 10;
            decimal += remainder*pow(2,i);
            ++i;
        } else {
            yyerror("Not Binary");
            return -1;
        }
    }
    return decimal;
}

/* Converts a decimal number to a binary number and returns it. */
long decToBin(int dec)
{
    long binary = 0;
    int remainder, i = 1, step = 1;

    while (dec!=0)
    {
        remainder = dec%2;
        dec /= 2;
        binary += remainder*i;
        i *= 10;
    }
    return binary;
}

/* Logical NOT operation */
int not(int i)
{
    int result = -1;
    if(i==1)
        result = 0;
    else if (i==0)
        result = 1;
    else{
        yyerror("Not Binary");
    }
    return result;
}

/* Logical AND operation */
int and(int i, int j)
{
    int result = -1;
    // If the sum == 2, it means that both functions must have returned 1
    if((checkIfBinary(i) + checkIfBinary(j)) == 2)
    {
        result = (i+j == 2) ? 1 : 0;
    }else{
        yyerror("Not Binary");
    }
    return result;
}

/* Logical OR operation */
int or(int i, int j)
{
    int result = -1;
    // If the sum == 2, it means that both functions must have returned 1
    if((checkIfBinary(i) + checkIfBinary(j)) == 2)
    {
        result = (i+j > 0 ) ? 1 : 0;
    }else{
        yyerror("Not Binary");
    }
    return result;
}

/* Logical NAND operation */
int nand(int i, int j)
{
    int result = -1;
    // If the sum == 2, it means that both functions must have returned 1
    if((checkIfBinary(i) + checkIfBinary(j)) == 2)
    {
        result = (i+j < 2) ? 1 : 0;
    }else{
        yyerror("Not Binary");
    }
    return result;
}

/* Logical NOR operation */
int nor(int i, int j)
{
    int result = -1;
    // If the sum == 2, it means that both functions must have returned 1
    if((checkIfBinary(i) + checkIfBinary(j)) == 2)
    {
        result = (i+j > 0 ) ? 0 : 1;
    }else{
        yyerror("Not Binary");
    }
    return result;
}

/* Logical XOR operation */
int xor(int i, int j)
{
    int result = -1;
    // If the sum == 2, it means that both functions must have returned 1
    if((checkIfBinary(i) + checkIfBinary(j)) == 2)
    {
        result = (i+j == 1 ) ? 1 : 0;
    }else{
        yyerror("Not Binary");
    }
    return result;
}
