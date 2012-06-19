# Copyright (C) 2012 Alexander Shpilkin <ashpilkin@gmail.com>

use install

proc jam_install {dir} {
    if {[catch {
        set libdir [file join $dir autosetup]
        file mkdir $libdir

        set bulk [open [file join $libdir autosetup.jam] w]
        set mods {}

        foreach file [lsort [glob -directory $::autosetup(libdir) *.tcl]] {
            set jamFile [file rootname $file].jam
            if {![file readable $jamFile]} {
                continue
            }

            if {[string match "*\n# @synopsis:*" [readfile $file]]} {
                lappend mods $jamFile
                continue
            }

            set module [file rootname [file tail $file]]
            puts $bulk "# MODULE: $module"
            puts $bulk ""
            puts $bulk [readfile $jamFile]
            puts $bulk ""
        }

        close $bulk

        foreach file $mods {
            autosetup_install_file $file $libdir
        }
    } error]} then {
        user-error "Failed to install autosetup/jam: $error"
    }

    autosetup_install $dir
}
