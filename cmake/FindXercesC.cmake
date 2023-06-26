#
# Charge le pkgconfig xerces-c
#
# Version 0.2
#

# Le fichier fourni par cmake 3.24.2 ne suffit pas avec XercesC 4.0.0 :
#CMake Error at /opt/cmake/3.24.2/share/cmake-3.24/Modules/FindPackageHandleStandardArgs.cmake:230 (message):
#  Failed to find XercesC (missing: XercesC_LIBRARY XercesC_INCLUDE_DIR
#  XercesC_VERSION)
#Call Stack (most recent call first):
#  /opt/cmake/3.24.2/share/cmake-3.24/Modules/FindPackageHandleStandardArgs.cmake:594 (_FPHSA_FAILURE_MESSAGE)
#  /opt/cmake/3.24.2/share/cmake-3.24/Modules/FindXercesC.cmake:112 (FIND_PACKAGE_HANDLE_STANDARD_ARGS)
#  src/PrefsXerces/CMakeLists.txt:10 (find_package)
# Le pkgconfig/xerces-c.pc est :
# prefix=/opt22/xerces-c/4.0.0
# exec_prefix=/opt22/xerces-c/4.0.0
# libdir=/opt22/xerces-c/4.0.0/lib
# includedir=/opt22/xerces-c/4.0.0/include
#
# Name: Xerces-C++
# Description: Validating XML parser library for C++
# Version: 4.0.0
# Libs: -L/opt22/xerces-c/4.0.0/lib -lxerces-c
# Libs.private:
# Cflags: -I/opt22/xerces-c/4.0.0/include

set (XercesC_FOUND FALSE)

# Chargement du package pkgconfig xerces-c. Requiert qu'il soit accessible via
# la variable d'environnement PKG_CONFIG_PATH :
include(FindPkgConfig)
pkg_check_modules (Xerces-C++ REQUIRED xerces-c)
pkg_get_variable (XercesC_LIBRARY xerces-c xerces-c)
pkg_get_variable (XercesC_VERSION xerces-c Version)
pkg_get_variable (XercesC_INCLUDE_DIR xerces-c includedir)
pkg_get_variable (XercesC_LIBRARIES xerces-c libraries)
pkg_get_variable (XercesC_LIBDIR xerces-c libdir)
pkg_get_variable (XercesC_PREFIX xerces-c prefix)

if (Xerces-C++_FOUND)
	set (XercesC_FOUND TRUE)
endif ( )

if (NOT XercesC_LIBRARY)
	unset (XercesC_LIBRARY)
	find_library (XercesC_LIBRARY xerces-c ${XercesC_LIBDIR})
endif ( )

set (XercesC_VERSION ${Xerces-C++_VERSION})
set (XercesC_TARGET "XercesC::XercesC")
if (NOT TARGET XercesC::XercesC)
	add_library (${XercesC_TARGET} SHARED IMPORTED)
	set_target_properties (XercesC::XercesC PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${XercesC_INCLUDE_DIR} IMPORTED_LOCATION ${XercesC_LIBRARY})
endif( )
set (XercesC_LIBRARY_DIRS ${XercesC_LIBDIR})
set (XercesC_LIBRARIES ${XercesC_LIBRARY})


MESSAGE (STATUS "========================== Module XercesC++ ========================== ")
# Variables CMake prédéfinies :
MESSAGE (STATUS "XercesC_PREFIX        =" ${XercesC_PREFIX})
MESSAGE (STATUS "XercesC_VERSION       =" ${XercesC_VERSION})
MESSAGE (STATUS "XercesC_INCLUDE_DIR   =" ${XercesC_INCLUDE_DIR})
MESSAGE (STATUS "XercesC_LIBDIR        =" ${XercesC_LIBDIR})
MESSAGE (STATUS "XercesC_LIBRARY_DIRS  =" ${XercesC_LIBRARY_DIRS})
MESSAGE (STATUS "XercesC_LIBRARY       =" ${XercesC_LIBRARY})
MESSAGE (STATUS "XercesC_LIBRARIES     =" ${XercesC_LIBRARIES})
MESSAGE (STATUS "XercesC_LINK_LIBRARIES=" ${XercesC_LINK_LIBRARIES})
MESSAGE (STATUS "XercesC_CFLAGS        =" ${XercesC_CFLAGS})
MESSAGE (STATUS "XercesC_LDFLAGS       =" ${XercesC_LDFLAGS})
MESSAGE ("========================== Module Xerces-C++ ========================== ")



