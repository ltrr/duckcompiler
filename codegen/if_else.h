
#include "instr.h"

class if_Tree : public CodeTree{

public:

      if_Tree (CodeTreePtr left, CodeTreePtr midd, CodeTreePtr right) :
           left(left) , midd(midd), right(right){}

      tuple4_vec genCode(context c);

private:

    
      CodeTreePtr left;
      CodeTreePtr midd;
      CodeTreePtr right; 

};




