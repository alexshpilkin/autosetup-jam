# Initial local.tcl created by 'autosetup --install'

# @synopsis:
#
# Module for project-specific autosetup customization.

if {[opt-val {help manual ref reference}] ne ""} {
    return
}

# Add any project-specific declarations here

if {[opt-bool init]} {
    use jam-init
    jam_init
}

if {[opt-val install] ne ""} {
    use jam-install
    jam_install [opt-val install]
}
