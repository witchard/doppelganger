#!/bin/bash
set -e

# Setup
cd "$( dirname "${BASH_SOURCE[0]}" )"
python3 -mvenv test_venv

export dg_non_interractive=1
test_dir=$(pwd)
dgf="$test_dir/.doppelganger"

function cleanup {
  rm  -r test_venv
  rm $dgf
}
trap cleanup EXIT

save="source ../doppelganger.sh && source test_venv/bin/activate && export dgf=$dgf && dgs"
load="source ../doppelganger.sh && export dgf=$dgf && dgl && which python3"
load_deactivate="source ../doppelganger.sh && export dgf=$dgf && dgl && deactivate && which python3"
expected="$test_dir/test_venv/bin/python3"

# Test with bash
echo "Testing on bash..."
bash -c "$save"
result=$( bash -c "$load" )
result_deactivated=$( bash -c "$load_deactivate" )

if [ "$expected" != "$result" ]
then
	echo "Invalid - expected activated python to be: [$expected], got: [$result]"
	echo "-------"
	cat $dgf
	exit 1
fi
if [ "$expected" == "$result_deactivated" ]
then
	echo "Invalid - expected deactivated python not be: [$expected], got: [$result_deactivated]"
	echo "-------"
	cat $dgf
	exit 1
fi
echo "success"

# Test with zsh
echo "Testing on zsh..."
zsh -c "$save"
result=$( zsh -c "$load" )
result_deactivated=$( zsh -c "$load_deactivate" )

if [ "$expected" != "$result" ]
then
	echo "Invalid - expected activated python to be: [$expected], got: [$result]"
	echo "-------"
	cat $dgf
	exit 1
fi
if [ "$expected" == "$result_deactivated" ]
then
	echo "Invalid - expected deactivated python not be: [$expected], got: [$result_deactivated]"
	echo "-------"
	cat $dgf
	exit 1
fi
echo "success"
