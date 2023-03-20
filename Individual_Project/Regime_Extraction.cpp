# include <iostream>

int main ()
{ 
    int N = 8;
    int InRemain [7] = {1,0,0,1,0,0,0};
    int RegimeCheck = InRemain[6];
    std::cout<< "Leading bit is : "<< RegimeCheck<<std::endl;
    int LP = 1;
   
    for(int i = 1; i < 7-1; i++)
        {
            std::cout<< i <<std::endl;
            std::cout<< " It is the " <<(8-2-i)<<"th bit being tested, which is "<< InRemain[8-2-i]<<std::endl;
            if(RegimeCheck == InRemain[8-2-i])
               {
                LP = LP + 1;
                //std::cout<< "LP is "<<LP<< std::endl;
               } 
            else //if(RegimeCheck != InRemain[8-2-i])
                break;
        }
    std::cout<< "The Regime Ending Position is found at : " << LP+1<<std::endl;
    return 0;
}
