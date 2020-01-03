/* Multi-Archive-Checker fuer FAME/Amiex Systeme */

OPT OSVERSION=37

MODULE '*mULTI-CHECK_rev','dos/dos','dos/datetime'

	OBJECT user
		name[31]:ARRAY
		pass[8]:ARRAY
		location[30]:ARRAY
		phoneNumber[13]:ARRAY
		slot_Number:INT
		sec_Status:INT
   	sec_Board:INT                   /* File or Byte Ratio */
   	sec_Library:INT                 /* Ratio              */
   	sec_Bulletin:INT                /* Computer Type      */
   	messages_Posted:INT
		newSinceDate:LONG
		confRead1:LONG
		confRead2:LONG
		confRead3:LONG
		confRead4:LONG
    confRead5:LONG
		xferProtocol:INT
		filler2:INT
		lcfiles:INT
		badFiles:INT
		accountDate:LONG
		screenType:INT
		editorType:INT
		conference_Access[10]:ARRAY
		uploads:INT
		downloads:INT
		confRJoin:INT
		times_Called:INT
		time_Last_On:LONG
		time_Used:LONG
		time_Limit:LONG
		time_Total:LONG
		bytes_Download:LONG
		bytes_Upload:LONG
		daily_Bytes_Limit:LONG
		daily_Bytes_Dld:LONG
		expert:CHAR
		confYM1:LONG
		confYM2:LONG
		confYM3:LONG
		confYM4:LONG
		confYM5:LONG
		confYM6:LONG
		confYM7:LONG
    confYM8:LONG
		confYM9:LONG
		beginLogCall:LONG
		protocol:CHAR
		uUCPA:CHAR
		lineLength:CHAR
		new_User:CHAR
ENDOBJECT

OBJECT fameuser
  username[32]:ARRAY
	password[22]:ARRAY
  userlocation[32]:ARRAY
	userfrom[32]:ARRAY
  userphone[16]:ARRAY
	confaccess[22]:ARRAY
	menuprompt[202]:ARRAY
	birthday[10]:ARRAY
	defcryptmepw[12]:ARRAY
  userfbasepw[12]:ARRAY	    	      
  cursorup[8]:ARRAY	      	        
  cursordown[8]:ARRAY
 	cursorright[8]:ARRAY	      	    
  cursorleft[8]:ARRAY
  strnotused[70]:ARRAY
 	calls:LONG		                    
  uploads:LONG
  bytesupload:LONG
  downloads:LONG
  bytesdownload:LONG
	messagewrite:LONG
	messageread:LONG
	dailybytelimit:LONG
	dailyfilelimit:LONG
	dailybytebonus:LONG
	dailyfilebonus:LONG
	dailybytedl:LONG
	dailyfiledl:LONG
	lastconf:LONG
	cnfrejoin:LONG
	bytesNuked:LONG
	filesNuked:LONG
	ntoncomflag1:LONG
	ntoncomflag2:LONG
	numberofchats:LONG
	dayrelogins:LONG
	ulongnotused2:LONG
  lasttime:LONG
  timelimit:LONG
  timeused:LONG
  firstcall:LONG
  highcpsdown:LONG
  highcpsup:LONG
  baud:LONG
  timebonus:LONG
  chattime:LONG
  chattimeused:LONG
  lowcpsdown:LONG
  lowcpsup:LONG
  timetotal:LONG
  userflags1:LONG
  userflags2:LONG
  longnotused1:LONG
  longnotused2:LONG
  deleted_or_not:LONG
  userlevel:LONG
  ratio:LONG
  ratiotype:LONG
  ansi_on_off:LONG
  newscan:LONG
  allhacks:LONG
  lasthacks:LONG
  numlines:LONG
  compitype:LONG
  modemtype:LONG
  extension:LONG
  language:LONG
  zoomtype:LONG
  xferprotocol:LONG
  loscarrier:LONG
  fileiddiz:LONG
  domsgcrypt:LONG
  numberofpages:LONG
  usernumber:INT
  editor:INT
  daypages:INT
ENDOBJECT

DEF filename[200]:STRING,addy[200]:STRING,bbsloc[108]:STRING,packer[200]:STRING,
		filesize,type:LONG,stripfile[200]:STRING,nomodify:LONG
DEF	username[32]:STRING,userlocation[32]:STRING,strnode[10]:STRING,
		tailer[200]:STRING,date[50]:ARRAY,time[50]:ARRAY

ENUM 	NOERR=0,NOFILE,WRONG_ARGS,NO_TEST,NO_MEM,NO_ADDY,WRONG_TYPE,NO_KILLFILE,NO_COPY_TEXT,COPY_HEADER,NO_TAILER

ENUM LZX=0,LHA,ZIP,TXT

/* --- Defines fuer ReadArgs() Argumente --- */

ENUM ARG_ADVERT=0, ARG_BBSPATH, ARG_STRIPFILE, ARG_PACKER, ARG_TYPE, ARG_TAILER, ARG_MODIFY, ARG_FILENAME

PROC main() HANDLE
	DEF	myargs:PTR TO LONG,rdargs,myerr

	myargs:=[0,0,0,0,0,0,0,0]
	WriteF('\n[15C[35mmULTI-cHECK [mV\d.\d [36mby SieGeL/tRSi [m([36mtRSi[m-[36miNNOVATiONs[m)\n\n',VERSION,REVISION)
  IF rdargs:=ReadArgs('ADVERT=AD/K,BBS-PATH=BBS/K,STRIPFILE=SF/K,PACKER=P/K,TYPE=T/K/A,TAILER=TA/K,NOMODIFY=NOM/S,FILENAME/A',myargs,NIL)
    AstrCopy(filename,myargs[ARG_FILENAME])
    IF StrCmp('LZX',myargs[ARG_TYPE])=TRUE
			type:=LZX
		ELSEIF StrCmp('LHA',myargs[ARG_TYPE])=TRUE
      type:=LHA
		ELSEIF StrCmp('ZIP',myargs[ARG_TYPE])=TRUE
			type:=ZIP
		ELSEIF StrCmp('TXT',myargs[ARG_TYPE])=TRUE
			type:=TXT
		ELSE
			Raise(WRONG_TYPE)
		ENDIF
		IF myargs[ARG_PACKER]<>NIL
			AstrCopy(packer,myargs[ARG_PACKER])
    ELSE
			packer:=NIL
		ENDIF
		IF myargs[ARG_ADVERT]<>NIL
			StrCopy(addy,myargs[ARG_ADVERT])
			IF myargs[ARG_BBSPATH]<>NIL
				StrCopy(bbsloc,myargs[ARG_BBSPATH])
			ELSE
        bbsloc:=NIL
			ENDIF
		ELSE
			addy:=NIL
		ENDIF
		IF myargs[ARG_STRIPFILE]<>NIL
			StrCopy(stripfile,myargs[ARG_STRIPFILE])
		ELSE
			stripfile:=NIL
		ENDIF
 		IF myargs[ARG_TAILER]<>NIL
			StrCopy(tailer,myargs[ARG_TAILER])
		ELSE
			tailer:=NIL
		ENDIF
		IF myargs[ARG_MODIFY]<>NIL
			nomodify:=1
		ELSE
			nomodify:=0
		ENDIF
		FreeArgs(rdargs)
		cHECKFILE()
		tESTFILE()
		Raise(NOERR)
	ELSE
		Raise(WRONG_ARGS)
	ENDIF

-> ******** EXCEPTION-HANDLER ********

	EXCEPT
    SELECT exception
			CASE NOERR
							WriteF('[m\n')
							CleanUp(0)
			CASE NO_MEM
							WriteF('[37mERROR: Unable to allocate some bytes of memory...[m\n\n')
							SetIoErr(ERROR_NO_FREE_STORE);
							myerr:=20
			CASE NOFILE
							WriteF('[37mERROR: Unable to open [32m\s [37m![m\n\n',filename)
							SetIoErr(ERROR_OBJECT_NOT_FOUND);
							myerr:=20
			CASE WRONG_ARGS
							myerr:=20
			CASE NO_TEST
							WriteF('Archive Corrupt!\n\n')
							myerr:=1
			CASE NO_ADDY
							WriteF('[37mERROR: [37mUnable to find [32m\s [37mto add to archive ![m\n\n',addy)
							SetIoErr(ERROR_OBJECT_NOT_FOUND);
							myerr:=3
			CASE NO_KILLFILE
							WriteF('[37mERROR: [37mUnable to find Stripfile [32m\s[37m ![m\n',stripfile)
							SetIoErr(ERROR_OBJECT_NOT_FOUND)
							myerr:=4
			CASE WRONG_TYPE
							WriteF('[37mERROR: [32m\s [37mis no valid archive-type !\n\nPlease look in the documentation for further infos ![m\n\n',myargs[3])
              FreeArgs(rdargs)
             	SetIoErr(ERROR_INVALID_COMPONENT_NAME);
							myerr:=5
			CASE NO_COPY_TEXT
							WriteF('[37mUnable to copy textfile !\n\n')
							myerr:=6
							SetIoErr(ERROR_INVALID_RESIDENT_LIBRARY)
			CASE COPY_HEADER
							WriteF('[37mERROR: Copying header from tempdir failed !\n\n')
							myerr:=7
			CASE NO_TAILER
							WriteF('[37mERROR: Unable to find Tailer (\s)\n\n',tailer)
							myerr:=8
    ENDSELECT
	PrintFault(IoErr(),'mULTI-cHECK')
	CleanUp(myerr)
ENDPROC

/*
 *  --- FUNKTION ZUM ARCHIVE-TESTEN ---
 */

OBJECT packernames
	name[4]:ARRAY
ENDOBJECT

PROC tESTFILE()
	DEF	cmd[200]:STRING,error,ptypes[4]:ARRAY OF packernames

	AstrCopy(ptypes[0].name,'LZX')
	AstrCopy(ptypes[1].name,'LHA')
	AstrCopy(ptypes[2].name,'ZIP')
	AstrCopy(ptypes[3].name,'TXT')
  IF type=TXT
		WriteF('[26C[36mfILE-nAME[33m: [32m\s\n',FilePart(filename))
		WriteF('[26C[36mfILE-sIZE[33m: [32m\d\n',filesize)
  	WriteF('[26C[36mfILE-tYPE[33m: [32m\s\n\n',ptypes[type].name)
    IF addy<>NIL
			WriteF('[23C[36maDDING hEADER[34m...\n\n')
			aDDADVERT()
		ENDIF
		IF tailer<>NIL
			WriteF('[23C[36maDDING tAILER[34m...\n\n')
			aDDTAILER()
		ENDIF
	ELSE
		WriteF('[24C[36maRCHIVE-nAME[33m: [32m\s\n',FilePart(filename))
		WriteF('[24C[36maRCHIVE-sIZE[33m: [32m\d\n',filesize)
	  WriteF('[24C[36maRCHIVE-tYPE[33m: [32m\s\n\n',ptypes[type].name)
		WriteF('[22C[35mtESTING aRCHIVE[34m...[m\b\n\n')
		SELECT type
			CASE LZX
			  StringF(cmd,'\c\s\c >NIL: -F t \c\s\c',34,packer,34,34,filename,34)
			CASE LHA
			  StringF(cmd,'\c\s\c >NIL: -F t \c\s\c',34,packer,34,34,filename,34)
			CASE ZIP
				StringF(cmd,'\c\s\c >NIL: -T \c\s\c',34,packer,34,34,filename,34)
		ENDSELECT
		error:=SystemTagList(cmd,NIL)
		IF error=0
			WriteF('[2A\b[40C[32mpASSED ![m\n')
		ELSE
			Raise(NO_TEST)
		ENDIF
		IF stripfile<>NIL
			kILLADVERT()
		ENDIF
	  IF addy<>NIL
			aDDADVERT()
	  ENDIF
	ENDIF
ENDPROC

/*
 *  --- FILEGROESSE ERMITTELN ---
 */

PROC cHECKFILE()
	DEF	fh,myfib:PTR TO fileinfoblock

	IF myfib:=AllocDosObject(DOS_FIB,NIL)
		IF fh:=Open(filename,MODE_OLDFILE)
			ExamineFH(fh,myfib)
			filesize:=myfib.size;
			Close(fh)
      FreeDosObject(DOS_FIB,myfib)
		ELSE
			FreeDosObject(DOS_FIB,myfib)
			Raise(NOFILE)
		ENDIF
	ELSE
		Raise(NO_MEM)
  ENDIF
ENDPROC

/*
 *  --- ADVERT ZUM ARCHIVE ADDEN ---
 */

PROC aDDADVERT()
	DEF	dt:PTR TO datetime,ds:PTR TO datestamp
	DEF str[256]:STRING,addname[108]:STRING
	DEF	myptr,dest,datefound,error,mybuf

  IF type<>TXT
		WriteF('[23C[35maDDING aDVERT[34m...[m\b\n\n')
	ENDIF
	NEW dt
	NEW ds
	IF bbsloc<>NIL
		rEADUSERDATA()
  ELSE
		lOCAL()
  ENDIF
	ds:=DateStamp(dt.stamp)
	dt.format:=FORMAT_USA
	dt.flags:=NIL
	dt.strdate:=date
	dt.strtime:=time
	DateToStr(dt)
	END dt
	END ds
	IF nomodify=0
		IF myptr:=Open(addy,MODE_OLDFILE)
			StringF(addname,'T:\s',FilePart(addy))
			IF dest:=Open(addname,MODE_NEWFILE)
	      WHILE Fgets(myptr,str,255)
					datefound:=InStr(str,'@@-@@-@@')
    	    IF datefound<>-1 THEN	aDDITEM(str,date,datefound,8,NIL)
					datefound:=InStr(str,'##:##:##')
	        IF datefound<>-1 THEN	aDDITEM(str,time,datefound,8,NIL)
					datefound:=InStr(str,'¹¹')
    	    IF datefound<>-1 THEN aDDITEM(str,strnode,datefound,2,NIL)
					datefound:=InStr(str,'-U-S-E-R-H-A-N-D-L-E-')
	        IF datefound<>-1 THEN aDDITEM(str,username,datefound,21,1)
					datefound:=InStr(str,'-U-S-E-R-L-O-C-A-T-I-O-N-')
    	    IF datefound<>-1 THEN	aDDITEM(str,userlocation,datefound,25,1)
					Fputs(dest,str)
				ENDWHILE
				Close(myptr)
				Close(dest)
			ELSE
				Close(myptr)
				Raise(NO_ADDY)
			ENDIF
	  ELSE
			Raise(NO_ADDY)
		ENDIF
	ELSE
    StrCopy(addname,addy)
	ENDIF
	IF type<>TXT
		SELECT type
			CASE	LZX
				StringF(str,'\c\s\c >NIL: -F a \c\s\c \c\s\c',34,packer,34,34,filename,34,34,addname,34)
	    CASE 	LHA
				StringF(str,'\c\s\c >NIL: -F a \c\s\c \c\s\c',34,packer,34,34,filename,34,34,addname,34)
			CASE 	ZIP
				StringF(str,'\c\s\c >NIL: -q \c\s\c \c\s\c',34,packer,34,34,filename,34,34,addname,34)
		ENDSELECT
		error:=SystemTagList(str,NIL)
    IF nomodify=0
			DeleteFile(addname)
		ENDIF
	ELSE
		cOPYHEADER(addname)
		DeleteFile(addname)
		StrCopy(addname,filename)
		StrAdd(addname,'.new')
    IF myptr:=Open(addname,MODE_READWRITE)
			IF dest:=Open(filename,MODE_OLDFILE)
				Seek(myptr,0,OFFSET_END)
				Fputs(myptr,'\n')
				Flush(myptr)
				mybuf:=New(filesize+50)
				IF mybuf<>0
					datefound:=0
					WHILE 1
						datefound:=Read(dest,mybuf, filesize+48)
						IF datefound=0 THEN JUMP out_of_race
						IF Write(myptr,mybuf,datefound)<>datefound OR (datefound=-1)
							Close(myptr)
							Close(dest)
							FreeVec(mybuf)
							Raise(NO_COPY_TEXT)
						ENDIF
					ENDWHILE
					out_of_race:
					END mybuf
				ELSE
					WHILE Fgets(dest,str,199)	/* Kein Speicher, normale Copyroutine */
						Fputs(myptr,str)
					ENDWHILE
				ENDIF
				Close(myptr)
				Close(dest)
				IF DeleteFile(filename)=DOSFALSE
					error:=1
				ELSE
					IF Rename(addname,filename)=DOSFALSE
						error:=1
  				ELSE
						error:=0
        	ENDIF
        ENDIF
			ELSE
				Close(myptr)
				Raise(NOFILE)
			ENDIF
		ELSE
      Raise(NO_ADDY)
		ENDIF
	ENDIF
  IF error=0
		WriteF('[2A\b[39C[32maDDED !\n')
	ELSE
		WriteF('\n\n[37mAdding of advert [32m\s [37mfailed !\n',FilePart(addname))
	ENDIF
ENDPROC

/*
 *  Copies the prepared Headerfile to the same dir like the original textfile
 *  to allow after adding the simple renaming of it, which is by far the faastest
 */

PROC cOPYHEADER(addname)
	DEF mybuf[200]:STRING,src,dest,readbuf[200]:ARRAY,err1

	err1:=0
	StrCopy(mybuf,filename)
  StrAdd(mybuf,'.new')
	IF src:=Open(addname,MODE_OLDFILE)
		IF dest:=Open(mybuf,MODE_NEWFILE)
			WHILE Fgets(src,readbuf,199)
				Fputs(dest,readbuf)
			ENDWHILE
		Close(dest)
		ELSE
			err1:=1
		ENDIF
		Close(src)
  ELSE
		err1:=2
	ENDIF
	IF err1<>0 THEN Raise(COPY_HEADER)
ENDPROC

/*
 *  --- Adds the Tailer to the given Textfile ---
 *
 *  V1.5: Adds now also the same special commands to the textfile like when
 *        adding the Header!
 */

PROC aDDTAILER()
	DEF	was,addtext,readbuf[200]:STRING, datefound

  IF was:=Open(tailer,MODE_OLDFILE)
		IF addtext:=Open(filename,MODE_READWRITE)
      Seek(addtext,0,OFFSET_END)
			Fputs(addtext,'\n')
			WHILE Fgets(was,readbuf,199)
				datefound:=InStr(readbuf,'@@-@@-@@')
        IF datefound<>-1 THEN	aDDITEM(readbuf,date,datefound,8,NIL)
				datefound:=InStr(readbuf,'##:##:##')
        IF datefound<>-1 THEN	aDDITEM(readbuf,time,datefound,8,NIL)
				datefound:=InStr(readbuf,'¹¹')
        IF datefound<>-1 THEN aDDITEM(readbuf,strnode,datefound,2,NIL)
				datefound:=InStr(readbuf,'-U-S-E-R-H-A-N-D-L-E-')
        IF datefound<>-1 THEN aDDITEM(readbuf,username,datefound,21,1)
				datefound:=InStr(readbuf,'-U-S-E-R-L-O-C-A-T-I-O-N-')
        IF datefound<>-1 THEN	aDDITEM(readbuf,userlocation,datefound,25,1)
				Fputs(addtext,readbuf)
			ENDWHILE
			StringF(readbuf,'                                             [mULTI-cHECK v\d.\d by SieGeL/tRSi]\n',VERSION,REVISION)
			Fputs(addtext,readbuf)
			Close(was)
			Close(addtext)
		ELSE
      Close(was)
			Raise(NOFILE)
		ENDIF
	ELSE
		Raise(NO_TAILER)
	ENDIF
	WriteF('[2A\b[39C[32maDDED !\n')
ENDPROC


/*
 *  --- KENNUNG IM ADVERT DURCH 'item' ERSETZEN LASSEN
 */

PROC aDDITEM(s,item,foundpos,offset,wie)
	DEF	backup[256]:STRING,mytemp1[256]:STRING,error,count

	StrCopy(backup,s,foundpos)
	StrAdd(backup,item)
	IF wie<>NIL
		error:=StrLen(item)
		FOR count:=0 TO (offset-1)-error DO StrAdd(backup,' ')
	ENDIF
	MidStr(mytemp1,s,foundpos+offset)
	StrAdd(backup,mytemp1)
  StrCopy(s,backup)
ENDPROC

/*
 *  --- USER.DATA abchecken und einladen (FAME oder AMIEX) ---
 */

PROC rEADUSERDATA()
	DEF udata,str[200]:STRING,temp[200]:STRING,zaehler,node

  StrCopy(temp,filename)
	UpperStr(temp)
  zaehler:=InStr(temp,'NODE')
  IF zaehler<>-1
		MidStr(str,filename,zaehler+4,2)
		node:=Val(str)
		StringF(strnode,'\d',node)
    StringF(temp,'\snode\d.user',bbsloc,node)
    IF udata:=Open(temp,MODE_OLDFILE)
      IF Read(udata,str,8)<=NIL
				Close(udata)
				lOCAL()
			ELSE
				IF StrCmp('FAMEUSDA',str)=TRUE
					rEADFAME(udata)
				ELSE
          rEADAMIEX(udata)
				ENDIF
			ENDIF
			Close(udata)
		ELSE
			lOCAL()
		ENDIF
	ELSE
		lOCAL()
	ENDIF
ENDPROC

/*
 *  --- KEINE USER.DATA VORHANDEN, ALSO LOCAL UPLOAD ---
 */

PROC lOCAL()
  StrCopy(username,'-+- THE SYSOP -+-')
	StrCopy(userlocation,'-+- LOCAL UPLOAD -+-')
	StrCopy(strnode,'--')
ENDPROC

/*
 *  --- AMIEX USER.DATA EINLESEN ---
 */

PROC rEADAMIEX(woher)
	DEF	myuser:PTR TO user

	NEW myuser
	Seek(woher,0,OFFSET_BEGINNING)
  IF Read(woher,myuser,SIZEOF user)<=NIL
		lOCAL()
	ELSE
  	AstrCopy(username,myuser.name)
		AstrCopy(userlocation,myuser.location)
  ENDIF
	END myuser
ENDPROC

/*
 *  --- FAME USER.DATA EINLESEN ---
 */

PROC rEADFAME(woher)
	DEF myfameuser:PTR TO fameuser

	NEW myfameuser
	Seek(woher,61,OFFSET_BEGINNING);
	IF Read(woher,myfameuser,SIZEOF fameuser)<=NIL
		lOCAL()
	ELSE
		AstrCopy(username,myfameuser.username)
		AstrCopy(userlocation,myfameuser.userlocation)
	ENDIF
	END myfameuser
ENDPROC

/*
 *  --- ADVERTS AUS ARCHIV LOESCHEN ---
 */

PROC kILLADVERT()
	DEF killfile,bu[108]:ARRAY, files[256]:STRING,counta=0

  WriteF('[22C[35mdELETING aDDIES[34m...[m\b\n\n')
	IF type=LHA
		kILL_LHA()
	ELSE
		killfile:=Open(stripfile,MODE_OLDFILE)
		IF killfile=NIL
		Raise(NO_KILLFILE)
		ENDIF
		WHILE Fgets(killfile,bu,107)
			bu[StrLen(bu)-1]:="\0"
			StrAdd(files,bu)
      StrAdd(files,' ')
      INC counta
			IF counta>5
				files[StrLen(files)-1]:="\0"
				kILL_tHEM(files)
        files:=String(256)
				counta:=0
			ENDIF
		ENDWHILE
		Close(killfile)
		IF counta<>NIL
	    files[StrLen(files)-1]:="\0"
  		kILL_tHEM(files)
		ENDIF
	ENDIF
	IF type=ZIP
		WriteF('[m\n')
	ELSE
		WriteF('[2A\b[40C[32mdELETED !\n')
	ENDIF
ENDPROC

PROC kILL_tHEM(filelist)
	DEF cmdstr[300]:STRING,error

	SELECT type
		CASE LZX
			StringF(cmdstr,'\c\s\c >NIL: d \c\s\c \s',34,packer,34,34,filename,34,filelist)
		CASE ZIP
			StringF(cmdstr,'\c\s\c <NIL: >NIL: -d -q \c\s\c \s',34,packer,34,34,filename,34,filelist)
 	ENDSELECT
	error:=SystemTagList(cmdstr,NIL)
	IF (error<>NIL) AND (type<>ZIP)  THEN Raise(NO_TEST)
ENDPROC

PROC kILL_LHA()
	DEF mycmd[108]:STRING

	StringF(mycmd,'\c\s\c >NIL: d \c\s\c @\s',34,packer,34,34,filename,34,stripfile)
	SystemTagList(mycmd,NIL)
ENDPROC
