
%{
char suavType [20];
int n;
int nbc;
int tabnd=0;
char* saveN ;
char* type;
int siCST=0;
%}
%union {
float flt;
int num;
char* str;
}

%token bib_inout  bib_arithme parO parF vg accO accF cro crf <str>idf mc_main mc_ret <str>mc_const <str>mc_int <str>mc_float <str>mc_string mc_fct mc_wh mc_fr mc_ft pvg aff <num>vint <flt>vfloat <str>str opr in out opc
%%
S: BIB FONCTIONS {printf("syntaxe correcte\n");YYACCEPT;}
;

BIB: bib_inout BIB
    | bib_arithme BIB
	|
;   

FONCTIONS: SIG_FCT accO BLOC accF FONCTIONS
    | mc_int mc_main parO parF accO BLOC accF
    |
;
BLOC: DEC INST
;
INST:AFFEC INST {
                                         if(absen_bib_arit()==0)
                                            printf("erreur Semantique: absence de la bibliotheque Arithme , avant la ligne %d, la colonne %d\n", n,nbc);
                }
    | in parO LIST_VAR parF pvg INST {
                                        if(absen_bib_io()==0)
                                            printf("erreur Semantique: absence de la bibliotheque InOut , avant la ligne %d, la colonne %d\n", n,nbc);
                                     }
    | out parO OUT_PAR parF pvg INST {
                                        if(absen_bib_io()==0)
                                            printf("erreur Semantique: absence de la bibliotheque InOut , avant la ligne %d, la colonne %d\n", n,nbc);
                                     }
    | mc_wh parO COND parF mc_fr BLOC mc_ft INST
    | mc_ret OP pvg INST
    | idf parO LIST_VAR parF pvg INST 
    |
;
DEC: TYPE idf DEC_S pvg DEC { if (doubleDeclaration($2)==0)
                                {   
                                    insererType($2,suavType);
                                    if(siCST==1)
                                        {insererCons($2);}
                                }
                            else printf("erreur Semantique: double declation de %s, avant la ligne %d, la colonne %d\n", $2, n,nbc);
                            
                            insererTaille($2,1);
                            }
    | TYPE TAB DEC_S pvg DEC
    | 
;
DEC_S: vg idf DEC_S{if (doubleDeclaration($2)==0)
                                {   
                                    insererType($2,suavType);
                                    if(siCST==1)
                                        {insererCons($2);}
                                }
                            else printf("erreur Semantique: double declation de %s, avant la ligne %d, a la colonne %d\n", $2, n,nbc);
                    insererTaille($2,1);
                    }
    | vg TAB  DEC_S
    |
;
TAB: idf cro vint crf {
                        if (doubleDeclaration($1)==0)insererType($1,suavType);
                                 else printf("erreur Semantique: double declation de %s, avant la ligne %d, a la colonne %d\n", $1, n,nbc);
                        insererTaille($1,$3);
                        saveN=$1;
                        }
;
COND:idf opc OP {if(nonDeclare($1))
                            printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);
                }
    |TAB opc OP
;
OUT_PAR: LIST_VAR PAR_V
    | str PAR_V 
    |
;
PAR_V: vg LIST_VAR PAR_V 
    | vg str PAR_V 
    |
;
AFFEC:idf aff OP pvg AFFEC {
                            if(nonDeclare($1)==1)
                                printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);
                        }
    |idf aff vint pvg {if(nonDeclare($1)==1)
                               {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                       else{if(typeInt($1)!=1 && typeFloat($1)!=1)
                            {printf("erreur Semantique: type de %s est incompatible avec %d : avant la ligne %d, a la colonne %d\n",$1,$3, n,nbc);}                             
                    } }
    |idf aff vfloat pvg {if(nonDeclare($1)==1)
                               {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                       
                             else{if(typeInt($1)!=1 && typeFloat($1)!=1)
                                    {printf("erreur Semantique: type de %s est incompatible avec un float : avant la ligne %d, a la colonne %d\n",$1, n,nbc);}                         
                                 }   
                         }
    |idf aff str pvg {if(nonDeclare($1)==1)
                               {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                       
                         else{if(typeInt($1)!=1 && typeFloat($1)!=1)
                            {printf("erreur Semantique: type de %s est incompatible avec %s : avant la ligne %d, a la colonne %d\n",$1,$3, n,nbc);}                             
                         }
                    }
    |idf aff idf pvg{
                        if(nonDeclare($1)==1)
                            {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                        else{
                            if(nonDeclare($3)==1)
                               {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $3, n,nbc);} 
                            else{
                                
                                if(typeInt($1)==1 && typeInt($3)!=1)
                                    {printf("erreur Semantique: type de %s est incompatible avec type de %s : avant la ligne %d, a la colonne %d\n",$1,$3, n,nbc);}                             
                                if(typeFloat($1)==1 && typeString($3)==1)
                                    {printf("erreur Semantique: type de %s est incompatible avec type de %s : avant la ligne %d, a la colonne %d\n",$1,$3, n,nbc);}                             
                                if(typeString($1)==1 && typeString($3)!=1)
                                    {printf("erreur Semantique: type de %s est incompatible avec type de %s : avant la ligne %d, a la colonne %d\n",$1,$3, n,nbc);}                             
                            }
                        }
                    }
    |TAB aff OP pvg AFFEC {}
    |idf cro vint crf aff vint pvg {if(nonDeclare($1)==1)
                                        {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                                    else{if(typeInt($1)!=1 && typeFloat($1)!=1)
                                             {printf("erreur Semantique: type de %s est incompatible avec %d : avant la ligne %d, a la colonne %d\n",$1,$6, n,nbc);}                             
                                     } }
    |idf cro vint crf aff vfloat pvg {if(nonDeclare($1)==1)
                                            {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                       
                                        else{if(typeInt($1)!=1 && typeFloat($1)!=1)
                                                {printf("erreur Semantique: type de %s est incompatible avec un float : avant la ligne %d, a la colonne %d\n",$1, n,nbc);}                         
                                        }   
                                      }
    |idf cro vint crf aff str pvg {if(nonDeclare($1)==1)
                                         {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                                    else{if(typeInt($1)!=1 && typeFloat($1)!=1)
                                         {printf("erreur Semantique: type de %s est incompatible avec %s : avant la ligne %d, a la colonne %d\n",$1,$3, n,nbc);}                             
                                         }
                                     }
    |idf cro vint crf aff idf pvg{
                                    if(nonDeclare($1)==1)
                                        {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);} 
                                    else{
                                        if(nonDeclare($6)==1)
                                        {printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $6, n,nbc);} 
                                        else{
                                            
                                            if(typeInt($1)==1 && typeInt($6)!=1)
                                                {printf("erreur Semantique: type de %s est incompatible avec type de %s : avant la ligne %d, a la colonne %d\n",$1,$6, n,nbc);}                             
                                            if(typeFloat($1)==1 && typeString($6)==1)
                                                {printf("erreur Semantique: type de %s est incompatible avec type de %s : avant la ligne %d, a la colonne %d\n",$1,$6, n,nbc);}                             
                                            if(typeString($1)==1 && typeString($6)!=1)
                                                {printf("erreur Semantique: type de %s est incompatible avec type de %s : avant la ligne %d, a la colonne %d\n",$1,$6, n,nbc);}                             
                                        }
                                    }
                                  }
    |
;

OP:idf opr OP  {
                  if(nonDeclare($1)==1)
                     printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);
                }
    |idf    
    |vint opr OP
    |vfloat opr OP
    |str opr OP  
    |TAB 
    |
;
LIST_VAR: idf LIST_S {if(nonDeclare($1))
                            printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $1, n,nbc);
                        
                    }
    | TAB LIST_S
    |
;
LIST_S: vg idf LIST_S {if(nonDeclare($2))
                            printf("erreur Semantique: %s non declare, avant la ligne %d, a la colonne %d\n", $2, n,nbc);
                        
                        }
    |vg TAB LIST_S
    |
;
SIG_FCT: TYPE mc_fct idf parO LISTE_DEC parF
;

LISTE_DEC: TYPE idf SUITE_DEC{ if (doubleDeclaration($2)==0)
                                {   
                                    insererType($2,suavType);
                                    if(siCST==1)
                                        {insererCons($2);}
                                }
                                 else printf("erreur Semantique: double declation de %s, avant la ligne %d, a la colonne %d\n", $2, n,nbc); }
        | TYPE TAB SUITE_DEC
        |
;
SUITE_DEC: vg TYPE idf SUITE_DEC{ if (doubleDeclaration($3)==0)
                                {   
                                    insererType($3,suavType);
                                    if(siCST==1)
                                        {insererCons($3);}
                                }
                                 else printf("erreur Semantique: double declation de %s, avant la ligne %d, a la colonne %d\n", $3, n,nbc); }
        | vg TYPE TAB SUITE_DEC
        |
;
TYPE: mc_int mc_const {strcpy(suavType,$1); siCST=1;}
     |mc_float mc_const {strcpy(suavType,$1); siCST=1;}
	 |mc_string mc_const {strcpy(suavType,$1); siCST=1;}
     |mc_int  {strcpy(suavType,$1); }
     |mc_float  {strcpy(suavType,$1); }
	 |mc_string {strcpy(suavType,$1); }
;
%%
main()
{yyparse();
afficher();
}
yywrap()
{}

int yyerror(char* msg)
{
    printf("Erreur syntaxique rencontree a la ligne %d, la colonne %d\n",n,nbc);
}
