**FREE

ctl-opt BndDir('PUNKAPI') DftActGrp(*no);

/Copy qrpgleref,punkapi

Dcl-s data Pointer;
Dcl-s biereCourante Pointer;

Dcl-s id int(10);
Dcl-s nom varchar(52);
Dcl-s tagline varchar(50);
Dcl-s dateBrassage Date;

Dcl-s count Int(5);
Dcl-s index Int(5);


data = bieresGet('':1:5);

count = bieresCount(data);

For index = 1 to count;
  biereCourante = bieresElementAt(data:index-1);
  nom = biereGetName(biereCourante);
  id = biereGetId(biereCourante);
  tagline = biereGettagline(biereCourante);
  dateBrassage = biereGetDateBrassage(biereCourante);

  Dsply ('ID: ' + %Char(id) + ' ('+ %Char(dateBrassage:*Iso) + ')');
  Dsply nom;
ENDFOR;

bieresFermeture(data);

Return;
