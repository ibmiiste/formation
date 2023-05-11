**FREE

ctl-opt BndDir('PUNKAPI') DftActGrp(*no);

/Copy qrpgleref,punkapi

Dcl-pi EXEMPLE1;
  pPage Char(2);
END-PI;

Dcl-s pageNumerique Int(5);
Dcl-s data Pointer;
Dcl-s count Int(5);
Dcl-s index Int(5);
Dcl-s biereCourante Pointer;
Dcl-s nom varchar(52);

pageNumerique = %Int(pPage);

data = bieresGet('':pageNumerique:5);

if bieresSucces();
  count = bieresCount(data);

  For index = 1 to count;
    biereCourante = bieresElementAt(data:index-1);
    nom = bieresStringAt(biereCourante:'name');
    Dsply nom;
  ENDFOR;
Else;
  Dsply 'Il y a une erreur';
ENDIF;

bieresFermeture(data);

Return;
