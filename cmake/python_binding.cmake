# Version 0.8 (03/12/24, Python > 3.10, répertoire d'installation des modules python fourni par le python utilisé)

include (GNUInstallDirs)
find_package (SWIG 4 REQUIRED)


message (STATUS "========================================= UTILISATION DE PYTHON 3 =========================================")
set (Python3_FIND_STRATEGY LOCATION)	# Nécessaire pour python >= 3.10
find_package (Python3 REQUIRED COMPONENTS Interpreter Development)
set (Python_INCLUDE_DIRS ${Python3_INCLUDE_DIRS})
set (Python_EXECUTABLE ${Python3_EXECUTABLE})
set (Python_VERSION ${Python3_VERSION})
set (Python_LIBRARIES ${Python3_LIBRARIES})
set (Python_LIBRARY_DIRS ${Python3_LIBRARY_DIRS})
set (PYTHON_MAJOR_VERSION 3)


# Recherche du répertoire d'installation des modules (procédure spack organizer) : 
# get python installation path
macro (_set_from_python outvar python_code)
	if (NOT ${outvar})
		execute_process (
			COMMAND ${Python_EXECUTABLE} -c "${python_code}"
			OUTPUT_VARIABLE ${outvar}
			OUTPUT_STRIP_TRAILING_WHITESPACE)
		if (NOT ${outvar})
			message (FATAL_ERROR "Failed to detect ${outvar} from command:${Python_EXECUTABLE} -c ${python_code}")
		endif ( )
	endif ( )
endmacro ( )

# REM : en l'état actuel, sous ubuntu/debian, et avec un python installé dans le système, le répertoire est du type local/lib/python3.12/dist-packages
# => installer un python dans /opt, ou utiliser un venv (mais pose problème avec omniidl ...).
_set_from_python(
    _GET_PYTHON_SITEARCH
    "import sysconfig; print(sysconfig.get_path('platlib', vars=dict(base='', platbase='', prefix='')).lstrip('/\/\/\/\'))"
)
set (PYTHON_BINDING_DIR ${_GET_PYTHON_SITEARCH})
set (CMAKE_PYTHON_RPATH_DIR ${CMAKE_INSTALL_PREFIX}/${_GET_PYTHON_SITEARCH})

include (${SWIG_USE_FILE})

message (STATUS "========================================= VARIABLES LIEES A PYTHON =========================================")
message (STATUS "PYTHON_BINDING_DIR=${PYTHON_BINDING_DIR}")
message (STATUS "Python_INCLUDE_DIRS=${Python_INCLUDE_DIRS}")
message (STATUS "Python_EXECUTABLE=${Python_EXECUTABLE}")
message (STATUS "Python_VERSION=${Python_VERSION} PYTHON_MAJOR_VERSION=${PYTHON_MAJOR_VERSION}")
message (STATUS "Python_LIBRARIES=${Python_LIBRARIES}")
message (STATUS "Python_LIBRARY_DIRS=${Python_LIBRARY_DIRS}")
message (STATUS "PYTHON_BINDING_DIR=${PYTHON_BINDING_DIR}")
message (STATUS "CMAKE_PYTHON_RPATH_DIR=${CMAKE_PYTHON_RPATH_DIR}")
message (STATUS "============================================================================================================")






