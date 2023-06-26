#
# Charge le pkgconfig omniORB4 et propose la macro OMNIORB4_IDL_COMPILATION qui
# gère les compilations %.idl -> %_stub.cpp %.hh
#
#
# Version 0.2
#


# Répertoire proposé pour héberger les fichiers idl :
set (CMAKE_INSTALL_IDLDIR "idl")

# Chargement du package pkgconfig omniORB4. Requiert qu'il soit accessible via
# la variable d'environnement PKG_CONFIG_PATH :
include(FindPkgConfig)
pkg_check_modules (omniORB4 REQUIRED omniORB4)
pkg_get_variable(omniORB4_OMNIIDL omniORB4 omniidl)
pkg_get_variable(omniORB4_DATA_DIR omniORB4 datadir)
pkg_get_variable(omniORB4_IDL_DIR omniORB4 idldir)
pkg_get_variable(omniORB4_LIB_DIR omniORB4 libdir)

if (NOT omniORB4_LIBRARY)
	unset (omniORB4_LIBRARY)
	find_library (omniORB4_LIBRARY omniORB4 ${omniORB4_LIB_DIR})
endif ( )
if (NOT omnithread_LIBRARY)
	unset (omnithread_LIBRARY)
	find_library (omnithread_LIBRARY omnithread ${omniORB4_LIB_DIR})
endif ( )
if (NOT omniDynamic4_LIBRARY)
	unset (omniDynamic4_LIBRARY)
	find_library (omniDynamic4_LIBRARY omniDynamic4 ${omniORB4_LIB_DIR})
endif ( )
if (NOT COS4_LIBRARY)
	unset (COS4_LIBRARY)
	find_library (COS4_LIBRARY COS4 ${omniORB4_LIB_DIR})
endif ( )
if (NOT COSDynamic4_LIBRARY)
	unset (COSDynamic4_LIBRARY)
	find_library (COSDynamic4_LIBRARY COSDynamic4 ${omniORB4_LIB_DIR})
endif ( )

set (omnithread_TARGET "omniORB4::omnithread")
if (NOT TARGET omniORB4::omnithread)
	add_library (${omnithread_TARGET} SHARED IMPORTED)
	set_target_properties (omniORB4::omnithread PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${omniORB4_INCLUDE_DIRS} IMPORTED_LOCATION ${omnithread_LIBRARY})
endif( )
set (omniORB4_TARGET "omniORB4::omniORB4")
if (NOT TARGET omniORB4::omniORB4)
	add_library (${omniORB4_TARGET} SHARED IMPORTED)
	set_target_properties (omniORB4::omniORB4 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${omniORB4_INCLUDE_DIRS}" IMPORTED_LOCATION ${omniORB4_LIBRARY} INTERFACE_LINK_LIBRARIES omniORB4::omnithread)
endif( )
set (omniDynamic4_TARGET "omniORB4::omniDynamic4")
if (NOT TARGET omniORB4::omniDynamic4)
	add_library (${omniDynamic4_TARGET} SHARED IMPORTED)
	set_target_properties (omniORB4::omniDynamic4 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${omniORB4_INCLUDE_DIRS} IMPORTED_LOCATION ${omniDynamic4_LIBRARY} INTERFACE_LINK_LIBRARIES omniORB4::omniORB4)
endif( )


# CREATION DES VARIABLES MAJOR, MINOR, PATCH, TWEAK :
# ===================================================

FUNCTION (stringToVersion version major minor patch tweak)
	# Entrée attendue pour ${version} : [major[.minor[.patch[.tweak]]]]
	# Les nombres non transmis valent 0 en sortie
	string (REGEX REPLACE "([0-9]*)([.][0-9]*[.][0-9]*)(-?.*)$" "\\1" numbers ${version})
    string (FIND ${numbers} "." pos)
    # Si '.' est trouvé => erreur dans la fonction string => on affecte 0
    if (${pos} EQUAL -1)
		set (${major} ${numbers} PARENT_SCOPE)
	else ( )
		set (${major} "0" PARENT_SCOPE)
	endif ( )
    string (REGEX REPLACE "([0-9]*[.])([0-9]*)([.][0-9]*-?.*)$" "\\2" numbers ${version})
    string (FIND ${numbers} "." pos)
    if (${pos} EQUAL -1)
		set (${minor} ${numbers} PARENT_SCOPE)
    else ( )
		set (${minor} "0" PARENT_SCOPE)
	endif ( )
	string (REGEX REPLACE "([0-9]*[.][0-9]*[.])([0-9]*)(-?.*)$" "\\2" numbers ${version})
    string (FIND ${numbers} "." pos)
    if (${pos} EQUAL -1)
		set (${patch} ${numbers} PARENT_SCOPE)
    else ( )
		set (${patch} "0" PARENT_SCOPE)
	endif ( )
	string (REGEX REPLACE "([0-9]*[.][0-9]*[.][0-9]*[.])([0-9]*)$" "\\2" numbers ${version})
    string (FIND ${numbers} "." pos)
    if (${pos} EQUAL -1)
		set (${tweak} ${numbers} PARENT_SCOPE)
    else ( )
		set (${tweak} "0" PARENT_SCOPE)
	endif ( )
ENDFUNCTION (stringToVersion)

# CREATION DE LA VERSION AU FORMAT HEXADECIMAL  :
# ===============================================

FUNCTION (shortHex decimal shortHex)
	# Transforme l'entier en notation décimale en argument en hexadécimal sans le 0x mais sur 2 caractères
	math (EXPR sh ${decimal} OUTPUT_FORMAT HEXADECIMAL)
	string (LENGTH ${sh} len)
	string (SUBSTRING ${sh} 2 ${len} shorter)
	string (LENGTH ${shorter} len)
	if (len EQUAL 1)
		set (${shortHex} "0${shorter}" PARENT_SCOPE)
	else ( )
		set (${shortHex} "${shorter}" PARENT_SCOPE)
	endif ()
ENDFUNCTION (shortHex)

FUNCTION (versionToHexadecimal version hexadecimalVersion)
	# Transforme les entiers de la version en notation hexadécimale où chaque nombre occupe 2 octets.
	# => 1.2.3.4 -> 0x01020304, 4.1.7 -> 0x40107, 4.1.7.12 -> 0x401070c
	# Rem : cette valeur est retournée par omniORB::versionHex ( )
	stringToVersion (${version} major minor patch tweak)
	shortHex (${major} hmajor)
	shortHex (${minor} hminor)
	shortHex (${patch} hpatch)
	shortHex (${tweak} htweak)
	set (${hexadecimalVersion} "0x${hmajor}${hminor}${hpatch}${htweak}" PARENT_SCOPE)
ENDFUNCTION (versionToHexadecimal)

stringToVersion (${omniORB4_VERSION} omniORB4_MAJOR omniORB4_MINOR omniORB4_PATCH omniORB4_TWEAK)
versionToHexadecimal (${omniORB4_VERSION} omniORB4_HEXADECIMAL_VERSION)


MESSAGE (STATUS "========================== Module omniORB4 ========================== ")
# Variables spécifiques à omniORB4 :
MESSAGE (STATUS "omniORB4_VERSION             = ${omniORB4_VERSION}")
MESSAGE (STATUS "omniORB4_MAJOR               = ${omniORB4_MAJOR}")
MESSAGE (STATUS "omniORB4_MINOR               = ${omniORB4_MINOR}")
MESSAGE (STATUS "omniORB4_PATCH               = ${omniORB4_PATCH}")
MESSAGE (STATUS "omniORB4_HEXADECIMAL_VERSION = ${omniORB4_HEXADECIMAL_VERSION}")
MESSAGE (STATUS "omniORB4_OMNIIDL             = ${omniORB4_OMNIIDL}")
MESSAGE (STATUS "omniORB4_IDL_DIRS            = ${omniORB4_IDL_DIR}")
MESSAGE (STATUS "omniORB4_LIBRARY             = ${omniORB4_LIBRARY}")
MESSAGE (STATUS "omnithread_LIBRARY           = ${omnithread_LIBRARY}")
MESSAGE (STATUS "omniDynamic4_LIBRARY         = ${omniDynamic4_LIBRARY}")
MESSAGE (STATUS "COS4_LIBRARY                 = ${COS4_LIBRARY}")
MESSAGE (STATUS "COSDynamic4_LIBRARY          = ${COSDynamic4_LIBRARY}")
# Variables CMake prédéfinies :
MESSAGE (STATUS "omniORB4_INCLUDE_DIRS        = ${omniORB4_INCLUDE_DIRS}")
MESSAGE (STATUS "omniORB4_LIB_DIR             = ${omniORB4_LIB_DIR}")
MESSAGE (STATUS "omniORB4_LIBRARY_DIRS        = ${omniORB4_LIBRARY_DIRS}")
MESSAGE (STATUS "omniORB4_LIBRARIES           = ${omniORB4_LIBRARIES}")
MESSAGE (STATUS "omniORB4_LINK_LIBRARIES      = ${omniORB4_LINK_LIBRARIES}")
MESSAGE (STATUS "omniORB4_CFLAGS              = ${omniORB4_CFLAGS}")
MESSAGE (STATUS "omniORB4_LDFLAGS             = ${omniORB4_LDFLAGS}")
MESSAGE (STATUS "========================== Module omniORB4 ========================== ")
if (omniORB4_IDL_DIRS)
	set (omniORB4_IDL_FLAGS -I${omniORB4_IDL_DIR} -bcxx -Wbuse_quotes -Wba -Wbh=.hh -Wbs=_stub.cpp)
else (omniORB4_IDL_DIRS)
	set (omniORB4_IDL_FLAGS -bcxx -Wbuse_quotes -Wba -Wbh=.hh -Wbs=_stub.cpp)
endif (omniORB4_IDL_DIRS)
#
# Macro OMNIORB4_IDL_COMPILATION.
# Entrée idlfiles : liste de fichiers idl.
# Sortie OMNIORB4_GENERATED_IDL_SOURCES : liste de sources racines (%_stub.cpp) 
#      correspondant aux fichiers idl,
# Sortie OMNIORB4_GENERATED_IDL_HEADERS : liste de fichiers entêtes (%.hh) 
#      correspondant aux fichiers idl
#
MACRO(OMNIORB4_IDL_COMPILATION idlfiles)
	SET(OMNIORB4_GENERATED_IDL_SOURCES "")
	SET(OMNIORB4_GENERATED_IDL_HEADERS "")
    FOREACH (idlfile IN LISTS ${idlfiles})
        GET_FILENAME_COMPONENT(fullfilename ${idlfile} ABSOLUTE)
        GET_FILENAME_COMPONENT(basename ${fullfilename} NAME_WE)
        GET_FILENAME_COMPONENT(directory ${fullfilename} PATH)
#        ADD_CUSTOM_COMMAND (OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${basename}_stub.cpp ${basename}.hh  COMMAND ${omniORB4_OMNIIDL} -I${omniORB4_IDL_DIR} -bcxx -Wbuse_quotes -Wba -Wbh=.hh -Wbs=_stub.cpp ${OMNIORB4_ADDITIONAL_FLAGS} -I${CMAKE_CURRENT_SOURCE_DIR} ${idlfile})
        ADD_CUSTOM_COMMAND (OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${basename}_stub.cpp ${basename}.hh  COMMAND ${omniORB4_OMNIIDL} ${omniORB4_IDL_FLAGS} ${OMNIORB4_ADDITIONAL_FLAGS} -I${CMAKE_CURRENT_SOURCE_DIR} -I${directory}/.. ${idlfile})
        LIST(APPEND OMNIORB4_GENERATED_IDL_SOURCES ${CMAKE_CURRENT_BINARY_DIR}/${basename}_stub.cpp)
        LIST(APPEND OMNIORB4_GENERATED_IDL_HEADERS ${CMAKE_CURRENT_BINARY_DIR}/${basename}.hh)
    ENDFOREACH (idlfile)
ENDMACRO (OMNIORB4_IDL_COMPILATION)

