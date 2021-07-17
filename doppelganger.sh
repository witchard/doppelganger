dgf=$HOME/.doppelganger

if [ -z "${BASH_SOURCE[0]}" ]
then
	dg_location="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"
else
	dg_location="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
fi

dgs() {
	# Save current shell settings to doppelganger file

	# Get current directory
	echo "cd $(pwd)" > $dgf

	# Get current shell local variables and functions
	if [ ! -z "${ZSH_NAME}" ]
	then
		# Functions doesn't exist in bash, but set dumps the functions anyway
		functions >> $dgf
		if [ -s "$dg_location/set_ignores" ]
		then
			# We grep for "=" to exclude unset things that confuse zsh
			set | grep -vf "$dg_location/set_ignores" | grep = >> $dgf
		else
			# We grep for "=" to exclude unset things that confuse zsh
			set | grep = >> $dgf
		fi
	else
		if [ -s "$dg_location/set_ignores" ]
		then
			set | grep -vf "$dg_location/set_ignores" >> $dgf
		else
			set >> $dgf
		fi
	fi

	# Get exported env vars
	if [ -s "$dg_location/export_ignores" ]
	then
		export -p | grep -vf "$dg_location/export_ignores" >> $dgf
	else
		export -p >> $dgf
	fi
}

dgl() {
	# Load doppelganger file
	if [ -f "$dgf" ]
	then
		source $dgf
		reset # Weird characters sometimes get printed, reset solves it...
		echo "doppelgänger engaged"
	else
		echo "no doppelgänger available"
	fi
}

dgc() {
	# Clean doppelganger file
	if [ -f "$dgf" ]
	then
		rm $dgf
	fi
}
