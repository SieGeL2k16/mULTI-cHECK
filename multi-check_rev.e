-> Bumpee revision bump module. Do not alter this file manually.

OPT MODULE
OPT EXPORT
OPT PREPROCESS

/*
BUMP
  NAME=mULTI-cHECK
  VERSION=1
  REVISION=6
ENDBUMP
*/

CONST VERSION=1
CONST REVISION=6

CONST VERSION_DAY=07
CONST VERSION_MONTH=05
CONST VERSION_YEAR=2003

#define VERSION_STRING {version_string}
#define VERSION_INFO {version_info}

PROC dummy() IS NIL

version_string:
CHAR '$VER: '
version_info:
CHAR 'mULTI-cHECK 1.6 (07.05.2003)',0
