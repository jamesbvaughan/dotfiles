#!/bin/sh

if [ "$BLOCK_BUTTON" = 1 ];then
	mpc toggle -q
	mpc current | tr -d "\n"
else
	mpc status | perl -ne 'if (/\[playing\]/) {CORE::say (`mpc current | tr -d "\n"`)}'
fi
