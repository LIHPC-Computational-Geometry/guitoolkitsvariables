# =========================== Colorisation des messages ===========================

string (ASCII 27 ESC)
set (AnsiEscapeCodeReset "${ESC}[m")
set (Bold "${ESC}[1m")
set (BoldOff "${ESC}[22m")
set (Em "${ESC}[35m")
set (BoldEm "${ESC}[1;35m")
set (Bold "${ESC}[1m")
set (BoldOff "${ESC}[22m")
set (CrossedOut "${ESC}[9m")
set (CrossedOutOff "${ESC}[29m")
set (ItalicOff "${ESC}[23m")
set (Underline "${ESC}[4m")
set (UnderlineOff "${ESC}[24m")
set (BlackFg "${ESC}[30m")
set (RedFg "${ESC}[31m")
set (GreenFg "${ESC}[32m")
set (YellowFg "${ESC}[33m")
set (BlueFg "${ESC}[34m")
set (MagentaFg "${ESC}[35m")
set (CyanFg "${ESC}[36m")
set (WhiteFg "${ESC}[37m")
set (DefaultFg "${ESC}[39m")
set (BlackBg "${ESC}[40m")
set (RedBg "${ESC}[41m")
set (GreenBg "${ESC}[42m")
set (YellowBg "${ESC}[43m")
set (BlueBg "${ESC}[44m")
set (MagentaBg "${ESC}[45m")
set (CyanBg "${ESC}[46m")
set (WhiteBg "${ESC}[47m")
set (DefaultBg "${ESC}[49m")
set (SaveCursorPosition "${ESC}[s")				# Does it work ? Even if ${ESC} 7
set (RestoreCursorPosition "${ESC}[u")			# Does it work ? Even if ${ESC} 8
set (EraseAfterCursorPosition "${ESC}[0J")
set (EraseFromBeginningToCursorPosition "${ESC}[1J")
set (EraseScreen "${ESC}[2J")

# ========================== ! Colorisation des messages ==========================


# ================================ print_variables ================================ 

# Affiche toutes les variables cmake contenant pattern.

function (print_variables pattern)

	message (STATUS "\n** dump #${pattern}# cmake variables ***")
	get_cmake_property (_all_var_names VARIABLES)
	foreach (_var_name ${_all_var_names})
		string (FIND ${_var_name} "${pattern}" pos_found)
		if (NOT pos_found STREQUAL -1)
			message (STATUS "${_var_name}=${${_var_name}}")
		endif (NOT pos_found STREQUAL -1)
	endforeach ( )
	message (STATUS "** dump end ***\n")
	
endfunction (print_variables)

# =============================== ! print_variables ===============================


# ============================ print_target_properties ============================ 

# Affiche toutes les propriétés de la target transmises en argument.
# https://stackoverflow.com/questions/32183975/how-to-print-all-the-properties-of-a-target-in-cmake/56738858#56738858

function (print_target_properties tgt)

	if (NOT TARGET ${tgt})
		message (STATUS "There is no target named '${tgt}'")
		return ( )
	endif (NOT TARGET ${tgt})

	# On récupère toutes les propriétés supportées par cmake :
	execute_process (COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)
	STRING (REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
	STRING (REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
	list (REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)

	# Dans le cas de libs réalisées au sein du projet, de la part de CMP0026, et comme elles 
	# n'existent pas encore (on est en phase cmake), on va avoir un message du type :
	#The LOCATION property may not be read from target "abc".  Use the target
	#  name directly with add_custom_command, or use the generator expression
	#  $<TARGET_FILE>, as appropriate.
	# Le contournement souvent proposé sur le net est d'enlever "LOCATION", "^LOCATION"
	# et "_LOCATION" de CMAKE_PROPERTY_LIST. Mais on l'enlève de toutes les cibles, ce qui nous
	# prive du coup de cette précieuse information de tout binaire généré :(.
	# Contournement proposé ici : on modifie cette politique juste le temps de la fonction.
	# Push the current (NEW) CMake policy onto the stack, and apply the OLD policy.
	# https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
	cmake_policy (PUSH)
# On efface un message d'injures du fait de l'utilisation de cmake_policy (SET CMP0026 OLD)
#	message (STATUS "${SaveCursorPosition}")
	cmake_policy (SET CMP0026 OLD)
#	message (STATUS "${RestoreCursorPosition} ${EraseAfterCursorPosition}")
	message (STATUS "${ESC}[12F ${EraseAfterCursorPosition}")

	foreach (prop ${CMAKE_PROPERTY_LIST})
		string (REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
		# Ci-dessous : on ne récupère pas les propriétés définies mais vides :
		#	get_target_property (propval ${tgt} ${prop})
		#	if (propval)
		#		message (STATUS "${tgt} ${prop} = ${propval}")
		#	endif (propval)
		# Ci-dessous : avec SET propval vaut 1 si la propriété existe. On récupère alors la valeur de 
		# la propriété par un seconde appel :
		get_property (propval TARGET ${tgt} PROPERTY ${prop} SET)
		if (propval)
#			message (STATUS "${tgt} ${prop} = ${propval}")	# 1
			get_target_property (propval ${tgt} ${prop})
			message (STATUS "${tgt} ${prop} = ${propval}")
		endif (propval)

	endforeach(prop)

	# Pop the previous policy from the stack to re-apply the NEW behavior.
	cmake_policy (POP)
    
endfunction (print_target_properties)

# =========================== ! print_target_properties ===========================
