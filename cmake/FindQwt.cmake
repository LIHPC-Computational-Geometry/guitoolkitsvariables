#
# Surcouche CEA/DAM : ajout des targets (en fin de fichier)
#

#
#  (C) 2005-2017 Centre National d'Etudes Spatiales (CNES)
#
# This file is part of Orfeo Toolbox
#
#     https://www.orfeo-toolbox.org/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Qt Widgets for Technical Applications
# available at http://www.http://qwt.sourceforge.net/
#
# The module defines the following variables:
#  QWT_FOUND - the system has Qwt
#  QWT_INCLUDE_DIR - where to find qwt_plot.h
#  QWT_INCLUDE_DIRS - qwt includes
#  QWT_LIBRARY - where to find the Qwt library
#  QWT_LIBRARIES - additional libraries
#  QWT_MAJOR_VERSION - major version
#  QWT_MINOR_VERSION - minor version
#  QWT_PATCH_VERSION - patch version
#  QWT_VERSION_STRING - version (ex. 5.2.1)
#  QWT_ROOT_DIR - root dir

#=============================================================================
# Copyright 2010-2013, Julien Schueller
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# The views and conclusions contained in the software and documentation are those
# of the authors and should not be interpreted as representing official policies,
# either expressed or implied, of the FreeBSD Project.
#=============================================================================

# message( "QWT_INCLUDE_DIR: '${QWT_INCLUDE_DIR}'" )
# message( "QWT_INCLUDE_DIR: '${QT_INCLUDE_DIR}'" )

find_path( QWT_INCLUDE_DIR
  NAMES qwt_plot.h
  PATH_SUFFIXES qwt
)

# message( "QWT_INCLUDE_DIR: '${QWT_INCLUDE_DIR}'" )
# message( "QWT_INCLUDE_DIR: '${QT_INCLUDE_DIR}'" )

set ( QWT_INCLUDE_DIRS ${QWT_INCLUDE_DIR} )

# version
set ( _VERSION_FILE ${QWT_INCLUDE_DIR}/qwt_global.h )
if ( EXISTS ${_VERSION_FILE} )
  file ( STRINGS ${_VERSION_FILE} _VERSION_LINE REGEX "define[ ]+QWT_VERSION_STR" )
  if ( _VERSION_LINE )
    string ( REGEX REPLACE ".*define[ ]+QWT_VERSION_STR[ ]+\"(.*)\".*" "\\1" QWT_VERSION_STRING "${_VERSION_LINE}" )
    string ( REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\1" QWT_MAJOR_VERSION "${QWT_VERSION_STRING}" )
    string ( REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\2" QWT_MINOR_VERSION "${QWT_VERSION_STRING}" )
    string ( REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)" "\\3" QWT_PATCH_VERSION "${QWT_VERSION_STRING}" )
  endif ()
endif ()


# check version
set ( _QWT_VERSION_MATCH TRUE )
if ( Qwt_FIND_VERSION AND QWT_VERSION_STRING )
  if ( Qwt_FIND_VERSION_EXACT )
    if ( NOT Qwt_FIND_VERSION VERSION_EQUAL QWT_VERSION_STRING )
      set ( _QWT_VERSION_MATCH FALSE )
    endif ()
  else ()
    if ( QWT_VERSION_STRING VERSION_LESS Qwt_FIND_VERSION )
      set ( _QWT_VERSION_MATCH FALSE )
    endif ()
  endif ()
endif ()


find_library ( QWT_LIBRARY
  NAMES qwt qwt${QWT_MAJOR_VERSION} qwt-qt5
  HINTS ${QT_LIBRARY_DIR}
)

set ( QWT_LIBRARIES ${QWT_LIBRARY} )

# try to guess root dir from include dir
if ( QWT_INCLUDE_DIR )
  string ( REGEX REPLACE "(.*)/include.*" "\\1" QWT_ROOT_DIR ${QWT_INCLUDE_DIR} )
# try to guess root dir from library dir
elseif ( QWT_LIBRARY )
  string ( REGEX REPLACE "(.*)/lib[/|32|64].*" "\\1" QWT_ROOT_DIR ${QWT_LIBRARY} )
endif ()

# handle the QUIETLY and REQUIRED arguments
include ( FindPackageHandleStandardArgs )
if ( CMAKE_VERSION LESS 2.8.3 )
  find_package_handle_standard_args( Qwt DEFAULT_MSG QWT_LIBRARY QWT_INCLUDE_DIR _QWT_VERSION_MATCH )
else ()
  find_package_handle_standard_args( Qwt REQUIRED_VARS QWT_LIBRARY QWT_INCLUDE_DIR _QWT_VERSION_MATCH VERSION_VAR QWT_VERSION_STRING )
endif ()

mark_as_advanced (
  QWT_LIBRARY
  QWT_LIBRARIES
  QWT_INCLUDE_DIR
  QWT_INCLUDE_DIRS
  QWT_MAJOR_VERSION
  QWT_MINOR_VERSION
  QWT_PATCH_VERSION
  QWT_VERSION_STRING
  QWT_ROOT_DIR
)

# =======================================================================================================================================
# CEA (ajout de la cible qwt pour le "cmake modern") :
set (QWT_TARGET "qwt::qwt")

if (NOT TARGET qwt::qwt)
	add_library (${QWT_TARGET} SHARED IMPORTED)

# Ajout dépendances Qt 5 ou 6 (issues des fichiers tests de qwt 6.2.0) :
	include (${GUIToolkitsVariables_CMAKE_DIR}/common_qt.cmake)
	find_package (Qt${QT_MAJOR}Widgets ${QT_MAJOR} REQUIRED NO_CMAKE_SYSTEM_PATH)
	find_package (Qt${QT_MAJOR}Concurrent ${QT_MAJOR} REQUIRED NO_CMAKE_SYSTEM_PATH)
	find_package (Qt${QT_MAJOR}PrintSupport ${QT_MAJOR} REQUIRED NO_CMAKE_SYSTEM_PATH)
	find_package (Qt${QT_MAJOR}Svg ${QT_MAJOR} NO_CMAKE_SYSTEM_PATH)
	find_package (Qt${QT_MAJOR}OpenGL ${QT_MAJOR} NO_CMAKE_SYSTEM_PATH)
	set (QWT_QT_LINKED_LIBRARIES "Qt${QT_MAJOR}::Widgets;Qt${QT_MAJOR}::Concurrent;Qt${QT_MAJOR}::PrintSupport")
	if (Qt5Svg_FOUND)
		list (APPEND QWT_QT_LINKED_LIBRARIES "Qt${QT_MAJOR}::Svg")
	endif (Qt5Svg_FOUND)
	if (Qt5OpenGL_FOUND)
		list (APPEND QWT_QT_LINKED_LIBRARIES "Qt${QT_MAJOR}::OpenGL")
	endif (Qt5OpenGL_FOUND)
	
	set_target_properties (qwt::qwt PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES ${QWT_INCLUDE_DIR}
		IMPORTED_LOCATION ${QWT_LIBRARIES}
		INTERFACE_LINK_LIBRARIES "${QWT_QT_LINKED_LIBRARIES}"
#		INTERFACE_LINK_LIBRARIES ${QWT_LIBRARIES}	# A priori on y met plutôt les dépendances, par exemple les libs Qt*.
	)
endif (NOT TARGET qwt::qwt)

# Fin CEA
# =======================================================================================================================================
