# Copyright (C) 2012 Alexander Shpilkin <ashpilkin@gmail.com>

proc jam_init {} {
    autosetup_create_configure

    if {![file exists auto.def]} {
        puts "I don't see auto.def, so I will create a default one."
        writefile auto.def {# Initial auto.def created by 'autosetup --init'

use cc jam

# Add any user options here
options {
}

make-config-header config.h
make-jam-stub
make-jam-config Jamconfig
}
    }
    if {![file exists auto.jam]} {
        puts "I don't see auto.jam, so I will create a default one."
        writefile auto.jam {# Initial auto.jam created by 'autosetup --init'

AutoGen config.h ;
HDRS += $(BUILD_TOP) ;
}
    }
    if {![file exists Jamrules]} {
        puts "I don't see Jamrules, so I will create a default one."
        writefile Jamrules {# Initial Jamrules created by 'autosetup --init'

# Add any rule definitions here

# Find and include Jamconfig
LOCATE on Jamconfig ?= $(TOP) ;
NoCare    Jamconfig ;
include   Jamconfig ;
if ! $(JAMCONFIGURED)
{
    Exit "can't find Jamconfig: run 'configure' first" ;
}
}
    }
    if {![file exists Jamfile]} {
        puts "Note: I don't see Jamfile. You will probably need to create one."
    }

    exit 0
}

# Code copied (literally) from lib/init.tcl
proc autosetup_create_configure {} {
    set create_configure 1
    if {[file exists configure]} {
        if {!$::autosetup(force)} {
            # Could this be an autosetup configure?
            if {![string match "*\nWRAPPER=*" [readfile configure]]} {
                puts "I see configure, but not created by autosetup, so I won't overwrite it."
                puts "Use autosetup --init --force to overwrite."
                set create_configure 0
            }
        } else {
            puts "I will overwrite the existing configure because you used --force."
        }
    } else {
        puts "I don't see configure, so I will create it."
    }
    if {$create_configure} {
        if {!$::autosetup(installed)} {
            user-notice "Warning: Initialising from the development version of autosetup"

            writefile configure "#!/bin/sh\nWRAPPER=\"\$0\"; export WRAPPER; exec $::autosetup(dir)/autosetup \"\$@\"\n"
        } else {
            writefile configure \
{#!/bin/sh
dir="`dirname "$0"`/autosetup"
WRAPPER="$0"; export WRAPPER; exec "`$dir/find-tclsh`" "$dir/autosetup" "$@"
}
        }
        catch {exec chmod 755 configure}
    }
}
