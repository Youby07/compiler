%{
 #include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "synt.tab.h"
extern int n;
extern YYSTYPE yylval;
extern int nbc;

typedef struct
{
    char NomEntite[20];
    char TypeEntite[20];
    int TailleEntite;
    int cons;
}TypeTS;

TypeTS ts[100];

int cts=0;

int recherche(char entite[])
{
    int i=0;
    while(i<cts)
    {
        if(strcmp(entite,ts[i].NomEntite)==0)return i;
        i++;
    }
    return -1;
}

void afficher()
{
    printf("\n/***************Table des symboles ******************/\n");
    printf("\t_____________________________________________________\n");
    printf("\t| NomEntite | TypeEntite | TailleEntite | CONST ?|\n");
    printf("\t_____________________________________________________\n");
    int i=0;
    while(i<cts)
    {
        printf("\t| %10s | %12s | %d |%d\n",ts[i].NomEntite,ts[i].TypeEntite,ts[i].TailleEntite,ts[i].cons);
        i++;
    }

}

void inserer(char entite[])
{
    if(recherche(entite)==-1)
    {
        strcpy(ts[cts].NomEntite,entite);
        ts[cts].cons=0;
        cts++;
    }
}

void insererType(char entite[],char type[])
{
    int ie=recherche(entite);
    if(ie!=-1)
    {
        strcpy(ts[ie].TypeEntite,type);
    }
}

void insererTaille(char entite[],int Taille)
{
    int ie=recherche(entite);
    if(ie!=-1)
        ts[ie].TailleEntite=Taille;
}
void insererCons(char entite[])
{
    int ie=recherche(entite);
    if(ie!=-1)
        ts[ie].cons=1;
}
int typeInt(char entite[])
{
    int ie=recherche(entite);
    if(ie!=-1 && ts[ie].TypeEntite=="int")
    {return 1;}
}
int typeFloat(char entite[])
{
    int ie=recherche(entite);
    if(ie!=-1 && ts[ie].TypeEntite=="float")
    {return 1;}
}
int typeString(char entite[])
{
    int ie=recherche(entite);
    if(ie!=-1 && ts[ie].TypeEntite=="string")
    {return 1;}
}
int typeConst(char entite[])
{
    int ie=recherche(entite);
    if(ie!=-1 && ts[ie].TypeEntite=="CONST")
    {return 1;}
}
int retournerTaille (char entite[])
{
    int ie=recherche(entite);
    if(ie!=-1)
     return ts[ie].TailleEntite;
}

int doubleDeclaration(char entite[])
{
    int ie=recherche(entite);

    if(strcmp(ts[ie].TypeEntite,"")==0)
        return 0;
    else
        return 1;
}

int nonDeclare(char entite[])
{
    int ie=recherche(entite);
    if(strcmp(ts[ie].TypeEntite,"")==0)
        return 1;
    return 0;
}
int constEd(char entite[])
{
    int ie=recherche(entite);
    if(strcmp(ts[ie].TypeEntite,"CONST")==0)
        return 1;
    return 0;
}

int absen_bib_io(){
    if(recherche("#include<InOut>")==-1){
        return 0;
    }
    else
        return 1;
}

int absen_bib_arit(){
    if(recherche("#include<Arithme>")==-1){
        return 0;
    }
    else
        return 1;
}
%}

inout "#include<InOut>"
arithme "#include<Arithme>"
idf [a-zA-Z][a-zA-Z0-9]*
vint ([1-9][0-9]*|0)
vfloat [-+]?([1-9][0-9]*|0)\,[0-9]*[1-9]
str \"[^\n]*\"
in "input"
out "output"
ft "Fait"
opr [-+*/]
wh "While"
fr "Faire"
com <|>|=|!=|<=|>=
ret "Return"
main "main"
comment "//"[^\n]*
%%
{comment}  {nbc+=yyleng; ("comm: %s\n", yytext);}
{opr} {nbc+=yyleng;inserer(yytext);printf ("opr: %s\n", yytext);return opr;}
{main} {nbc+=yyleng;inserer(yytext);printf ("main: %s\n", yytext);return mc_main;}
{ret} {nbc+=yyleng;inserer(yytext);printf ("return: %s\n", yytext);return mc_ret;}
{wh} {nbc+=yyleng;inserer(yytext);printf ("while: %s\n", yytext);return mc_wh;}
{ft} {nbc+=yyleng;inserer(yytext);printf ("fait: %s\n", yytext);return mc_ft;}
{fr} {nbc+=yyleng;inserer(yytext);printf ("faire: %s\n", yytext);return mc_fr;}
{in} {nbc+=yyleng;inserer(yytext);printf ("input: %s\n", yytext);return in;}
{out} {nbc+=yyleng;inserer(yytext);printf ("output: %s\n", yytext);return out;}
{com} {nbc+=yyleng;inserer(yytext);printf ("comparaison: %s\n", yytext);return opc;}
{inout} {inserer(yytext);
        printf ("bibinout: %s\n", yytext);
        nbc+=yyleng;
        return bib_inout;}
{arithme} {inserer(yytext);
        printf ("bibarithme: %s\n", yytext);
        nbc+=yyleng;
        return bib_arithme;} 
{vint} {nbc+=yyleng;
        yylval.num=atoi(yytext);
        inserer(yytext);
        printf ("integer: %s\n", yytext);
        return vint;}
{vfloat} {yylval.flt=atoi(yytext);
        inserer(yytext);
        nbc+=yyleng;
        printf ("float: %s\n", yytext);
        return vfloat;}
{str} {yylval.str=strdup(yytext);
        inserer(yytext);
        printf ("string: %s\n", yytext);
        nbc+=yyleng;
        return str;}
int {yylval.str=strdup(yytext);
    inserer(yytext);
    printf ("mcint: %s\n", yytext);
    nbc+=yyleng;
    return mc_int;}
float {yylval.str=strdup(yytext);
    inserer(yytext);
    printf ("mcfloat: %s\n", yytext);
    nbc+=yyleng;
    return mc_float;}
String {yylval.str=strdup(yytext);
        inserer(yytext);
        printf ("mcstring: %s\n", yytext);
        nbc+=yyleng;
        return mc_string;}
CONST {yylval.str=strdup(yytext);
    inserer(yytext);
    printf ("constante: %s\n", yytext);
    nbc+=yyleng;
    return mc_const;}
FUNCTION {inserer(yytext);
        printf ("fonction: %s\n", yytext);
        nbc+=yyleng;
        return mc_fct;}

{idf} { if (yyleng<=12){nbc+=yyleng;
                        inserer(yytext);
                        yylval.str=strdup(yytext);
                        printf ("idf: %s\n", yytext);
                        return idf;}  
    else {printf ("erreur lexicale : idf trop long");}
}

\:= {nbc+=yyleng;return aff;}
\[ {nbc+=yyleng;return cro;}
\] {nbc+=yyleng;return crf;}
\( {nbc+=yyleng;return parO;}
\) {nbc+=yyleng;return parF;}
\{ {nbc+=yyleng;return accO;}
\} {nbc+=yyleng;return accF;}
; {nbc+=yyleng;return pvg;}
, {nbc+=yyleng;return vg;}


[ \t]
\n {nbc=0;n++;}

. printf("erreur lexicale a la ligne: %d et la colonne %d.\n",n,nbc);
