
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


class else_Tree : public CodeTree{

public:
      else_Tree ( CodeTreePtr child): 
           child(child) {}
      tuple4_vec genCode(context c);

private:
     
      CodeTreePtr child;

};


class else_if_Tree : public CodeTree{

public:
      else_if_Tree ( CodeTreePtr child): 
            child(child) {}
      tuple4_vec genCode(context c);

private:
      
      CodeTreePtr child;

};


