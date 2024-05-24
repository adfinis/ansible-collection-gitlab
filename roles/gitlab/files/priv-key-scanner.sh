#!/bin/bash

#https://gist.github.com/aaronk6/70a2be0c70bb16b55caefe224e13a4c0#file-check-vault-encryption
set -o errexit
set -o nounset

TEMPDIR=$(mktemp -d)

prefix="[private-key-check]"
zero_commit="0000000000000000000000000000000000000000"
bad_file=0

while read -r oldrev newrev refname; do

	OLDIFS=$IFS
	IFS=$'\n'

	# branch or tag gets deleted
	if [ "$newrev" = "$zero_commit" ]; then
		continue
	fi

	echo "$prefix Looking for private key files"

	if [ "$oldrev" = "$zero_commit" ]; then
		# First commit on this branch, just get the list of files
		files=$(git diff-tree --name-only --no-commit-id -r "$newrev")
	else
		# Get the file names, without directory, of the files that have been modified
		# between the new revision and the old revision
		files=$(git diff --name-only "$oldrev" "$newrev")
	fi

	# Get a list of all objects in the new revision
	objects=$(git ls-tree --full-name -r "$newrev")

	# Iterate over each of these files
	for file in ${files}; do

		# Search for the file name in the list of all objects
		object=$(echo -e "${objects}" | grep -E "(\\s)${file}\$" | awk '{ print $3 }')

		# If it's not present, then continue to the the next iteration
		if [ -z "${object}" ]; then
			continue
		fi

		# Otherwise, create all the necessary sub directories in the new temp directory
		mkdir -p "${TEMPDIR}/$(dirname "${file}")" &>/dev/null
		# and output the object content into its original file name
		git cat-file blob "${object}" > "${TEMPDIR}/${file}" 2> /dev/null && rc=$? || rc=$?
		if [ $rc -ne 0 ]; then
			echo "$prefix \`git cat-file blob "${object}"\` failed, maybe a submodule? Ignoring..."
		fi

	done

	IFS=$OLDIFS
done

# Now loop over each file in the temp dir to verify it
files_found=$(find "${TEMPDIR}" -iname "*dsa*" -o -iname "*ed25519*" -o -iname "*ed25519-sk*" -o -iname "*rsa*" -o -iname "*ecdsa" -o -iname "*ecdsa-sk*")
for f in ${files_found}; do
	if [[ $(head -n1 "$f") = "-----BEGIN OPENSSH PRIVATE KEY-----" ]]; then
		  echo "ERROR: $(basename "$f") is a private key. Encrypt or upload to Bitwarden."
		  bad_file=1
	fi
done

rm -rf "${TEMPDIR}" &> /dev/null

if [[ $bad_file -eq 1 ]]
then
	exit 1
fi
