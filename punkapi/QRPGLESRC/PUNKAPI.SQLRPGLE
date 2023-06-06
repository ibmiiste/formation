**FREE
      // >>PRE-COMPILER<<
      //   >>CRTCMD<<  CRTSQLRPGI SRCFILE(&SL/&SF) SRCMBR(&SM);
      //   >>IMPORTANT<<
      //     >>PARM<<  OBJ(&LI/&OB);
      //     >>PARM<<  OBJTYPE(*MODULE);
      //     >>PARM<<  OPTION(*EVENTF);
      //     >>PARM<<  RPGPPOPT(*LVL2);
      //     >>PARM<<  CLOSQLCSR(*ENDACTGRP);
      //     >>PARM<<  DATFMT(*ISO);
      //     >>PARM<<  TIMFMT(*ISO);
      //   >>END-IMPORTANT<<
      //   >>CMD<<  RMVBNDDIRE BNDDIR(PUNKAPI) OBJ((*LIBL/&SM));
      //   >>EXECUTE<<
      //   >>CMD<<  CRTSRVPGM SRVPGM(&LI/&OB) EXPORT(*ALL);
      //   >>CMD<<  ADDBNDDIRE BNDDIR(PUNKAPI) OBJ((*LIBL/&SM));
      // >>END-PRE-COMPILER<<


//bieresGet() retourne un pointer JSON;
//bieresGet();
//bieresGet(beerName);
//bieresGet(beerName:page:parPage);
//bieresGetById();

//bieresCount(pointer); - Retourne compte de l'appel de l'API GetBieres
//currentElementPtr = beersElementAt(arrayPointer:index);
//bieresStringAt(currentElementPtr:property);

//biereGetId(currentElementPtr) - retourne un nombre
//biereGetName(currentElementPtr) - retourne une chaîne
//biereGetTagLine(currentElementPtr) - retourne une chaîne
//biereGetDateBrassage(currentElementPtr) - retourne une chaîne
//biereGetDescription(currentElementPtr) - retourne une chaîne

Ctl-opt Nomain Bnddir('PUNKAPI');

/Copy qrpgleref,jsonxml

Dcl-proc bieresGet Export;
  Dcl-pi bieresGet Pointer;
    pSearch Pointer Value Options(*String:*Nopass);
    pPage Int(5) Const Options(*Nopass);
    pPerPage Int(5) Const Options(*Nopass);
  END-PI;

  dcl-s response Varchar(16000);
  dcl-s split Char(1) Inz('?');
  Dcl-s search Varchar(16);
  Dcl-s URL Varchar(128);
  Dcl-s JSON Pointer;

  URL = 'https://api.punkapi.com/v2/beers';

  If %parms >= 1;
    search = %Str(pSearch);
    if search <> *Blank;
      URL += split + 'beer_name=' + search;
      split = '&';
    Endif;
  ENDIF;

  If %parms >= 2;
    URL += split + 'page=' + %Char(pPage);
    split = '&';
  ENDIF;

  If %parms >= 3;
    URL += split + 'per_page=' + %Char(pPerPage);
    split = '&';
  ENDIF;

  Exec sql
    Set :Response = Systools.Httpgetclob(:URL, '');

  JSON = json_parseString(response);

  Return JSON;

END-PROC;

//*******************************************
dcl-proc beerGetById Export;
  dcl-pi beerGetById Pointer;
    pBeerId Int(5) Const;
  end-pi;

  dcl-s response Varchar(16000);
  Dcl-s URL Varchar(128);
  Dcl-s JSON Pointer;

  URL = 'https://api.punkapi.com/v2/beers/' + %Char(pBeerId);

  Exec sql
    Set :Response = Systools.Httpgetclob(:URL, '');

  JSON = json_parseString(response);

  Return JSON;

end-proc;

Dcl-proc bieresSucces Export;
  Dcl-pi bieresSucces Ind End-pi;

  Return Sqlstate = '00000';
END-PROC;

Dcl-proc bieresCount Export;
  Dcl-pi bieresCount Int(10);
    pArray Pointer;
  END-PI;

  return json_getLength(parray);
END-PROC;

Dcl-proc bieresElementAt Export;
  Dcl-pi bieresElementAt Pointer;
    pArray Pointer;
    pIndex Int(5) Const;
  END-PI;

  Return json_locate(pArray:'[' + %Char(pIndex) + ']');
END-PROC;

Dcl-proc bieresStringAt Export;
  Dcl-pi bieresStringAt Varchar(256);
    pObject Pointer;
    pProperty Pointer Value Options(*String:*Nopass);
  END-PI;

  Return json_getStr(pObject:pProperty);
END-PROC;


Dcl-proc biereGetId Export;
  Dcl-pi biereGetId Int(10);
    pObject Pointer;
  END-PI;

  Return json_getNum(pObject:'id');
END-PROC;


Dcl-proc biereGetName Export;
  Dcl-pi biereGetName Varchar(50);
    pObject Pointer;
  END-PI;

  Return json_getStr(pObject:'name');
END-PROC;

Dcl-proc biereGetTagLine Export;
  Dcl-pi biereGetTagLine Varchar(50);
    pObject Pointer;
  END-PI;

  Return json_getStr(pObject:'tagline');
END-PROC;

Dcl-proc biereGetDateBrassage Export;
  Dcl-pi biereGetDateBrassage Date;
    pObject Pointer;
  END-PI;

  Dcl-s String Char(7);
  Dcl-s isoString Char(10);


  String = Json_getStr(pObject:'first_brewed');
  isostring = %subst(String:4:4) + '-' + %subst(String:1:2) + '-01';

  Return %Date(isoString:*iso);
END-PROC;

Dcl-proc biereGetDescription Export;
  Dcl-pi biereGetDescription Varchar(256);
    pObject Pointer;
  END-PI;

  Return json_getStr(pObject:'description');
END-PROC;


Dcl-proc bieresFermeture Export;
  Dcl-pi bieresFermeture;
    pJson Pointer;
  END-PI;

  json_close(pJson);
END-PROC;
