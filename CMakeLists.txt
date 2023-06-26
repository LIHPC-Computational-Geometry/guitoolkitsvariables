cmake_minimum_required(VERSION 3.14)

project (GUIToolkitsVariables LANGUAGES CXX)

set (CURRENT_PACKAGE_NAME "GUIToolkitsVariables")
set (CURRENT_PACKAGE_MACRO_NAME "GUI_TOOLKITS_VARIABLES")

include (GNUInstallDirs)

include (${CMAKE_SOURCE_DIR}/cmake/version.cmake)
include (${CMAKE_SOURCE_DIR}/cmake/organization.cmake)

include(CMakePackageConfigHelpers)


# Installation des fichiers cmake partagés par les composantes installées de GUIToolkits :
set (ConfigPackageLocation ${CMAKE_CMAKE_DIR})
file (GLOB CMAKE_GUI_TOOLKITS_SHARED_FILES "${CMAKE_SOURCE_DIR}/cmake/*.cmake" "${CMAKE_SOURCE_DIR}/cmake/*.py")
install (FILES ${CMAKE_GUI_TOOLKITS_SHARED_FILES} DESTINATION ${ConfigPackageLocation} PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ GROUP_WRITE WORLD_READ)

# Utilisation par d'autres composantes :
set (PACKAGE_CMAKE_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/${ConfigPackageLocation}/")		# GUIToolkitsVariables_CMAKE_DIR avec GUIToolkitsVariablesConfig.cmake.in
write_basic_package_version_file(${CMAKE_PACKAGE_VERSION_FILE} VERSION ${GUI_TOOLKITS_VARIABLES_VERSION} COMPATIBILITY SameMajorVersion)

# Création du fichier GUIToolkitsVariablesConfig.cmake qui définira GUIToolkitsVariables_CMAKE_DIR :
configure_package_config_file (cmake/${CMAKE_PACKAGE_CONFIG_NAME}.cmake.in ${CMAKE_PACKAGE_CONFIG_FILE} INSTALL_DESTINATION ${CMAKE_CMAKE_DIR} PATH_VARS PACKAGE_CMAKE_INSTALL_DIR)
	
# Copie du fichier GUIToolkitsVariablesConfig.cmake dans prefix/lib/GUIToolkitsVariables/cmake :
install (FILES ${CMAKE_PACKAGE_CONFIG_FILE} ${CMAKE_PACKAGE_VERSION_FILE} DESTINATION ${ConfigPackageLocation} PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ GROUP_WRITE WORLD_READ)

