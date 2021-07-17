dgf=$HOME/.doppelganger
dg_location="$( cd "$( dirname "$0" )" &> /dev/null && pwd )"

dgs() {
	# Save current shell settings to doppelganger file
	echo "cd $(pwd)" > $dgf
	functions >> $dgf
	if [ -s "$dg_location/set_ignores" ]
	then
		set | grep -vf "$dg_location/set_ignores" | grep = >> $dgf
	else
		set | grep = >> $dgf
	fi
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
