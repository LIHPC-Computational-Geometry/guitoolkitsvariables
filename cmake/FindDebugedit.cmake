#
# Recherche le programme debuedit. Défini en cas de succès :
# - DEBUGEDIT_EXE : chemin d'accès à debugedit
# - DEBUGEDIT_FOUND : TRUE
#
# En cas d'échec défini :
# - DEBUGEDIT_FOUND : FALSE
#

find_program (DEBUGEDIT_EXE NAMES debugedit)

if (DEBUGEDIT_EXE)
	message (STATUS "Found debugedit program : ${DEBUGEDIT_EXE}")
	set (DEBUGEDIT_FOUND TRUE)
else (DEBUGEDIT_EXE)
	message (STATUS "debugedit program not found")
	set (DEBUGEDIT_FOUND FALSE)
endif (DEBUGEDIT_EXE)

mark_as_advanced (DEBUGEDIT_EXE)
