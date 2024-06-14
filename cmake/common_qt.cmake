set (QT_5 OFF)
set (QT_6 OFF)
unset (QT_MAJOR)
unset (QT_LIBRARY_PATH)
if (Qt6_DIR OR Qt6_ROOT)
	find_package (Qt6 REQUIRED COMPONENTS Core)
	if (Qt6_FOUND)
		set (QT_6 ON)
		set (QT_MAJOR 6)
	endif (Qt6_FOUND)
elseif (Qt5_DIR OR Qt5_ROOT)
	find_package (Qt5 REQUIRED COMPONENTS Core)
	if (Qt5_FOUND)
		set (QT_5 ON)
		set (QT_MAJOR 5)
	endif (Qt5_FOUND)
else ( )	# Spack ?
	find_package (Qt6 COMPONENTS Core)
	if (Qt6_FOUND)
		set (QT_6 ON)
		set (QT_MAJOR 6)
	else (Qt6_FOUND)
		find_package (Qt5 COMPONENTS Core)
		if (Qt5_FOUND)
			set (QT_5 ON)
			set (QT_MAJOR 5)
		else (Qt5_FOUND)
			message (FATAL_ERROR "Version majeure de Qt non gérée.")
		endif (Qt5_FOUND)
	endif (Qt6_FOUND)
endif ( )

# Qt (5 et 6) créé et installe ses bibliothèques avec un RUNPATH reposant sur $ORIGIN. Le RUNPATH est moins 
# prioritaire que le LD_LIBRARY_PATH, lui même moins prioritaire que le RPATH.
# Nos applications et bibliothèques t.q. QtUtil posent un RPATH permettant de charger la 1ère lib Qt
# (Qt5Core ? Qt5Widgets ?) au bon endroit, mais celle-ci va ensuite charger les suivantes selon la directive RUNPATH,
# et comme LD_LIBRARY_PATH prime ce sont celles accessibles par ce biais qui sont prises ... => mélanges de libs Qt
# de versions différentes.
# A noter qu'installé par Spack Qt ne pose pas nécessairement de problème car car spack fait un patchelf après installation 
# des binaires, en positionnant les paths à RPATH ou RUNPATH selon la configuration spack.
if (NOT QT_LIBRARY_PATH)
	get_target_property (QT_CORE_LOCATION Qt${QT_MAJOR}::Core LOCATION)
	get_filename_component (QT_LIBRARY_PATH ${QT_CORE_LOCATION} DIRECTORY)
endif (NOT QT_LIBRARY_PATH)

