#!/usr/bin/tclsh
# Copyright 2015,2016,2017 Lucas Sköldqvist <frusen@dragora.org>
# License: GPLv3

package require sqlite3

set version "0.5.4"
set arch ""

array set repolist {
	gungre {
		{frusen kelsoo mprodrigues tom mmpg}
		gungre.db
		http://gungre.ch/jul/
	}
}

if {[file exists $::env(HOME)/.julrc] == 1} {
	source $::env(HOME)/.julrc
} elseif {[file exists $::env(HOME)/.jul/config.tcl] == 1} {
	source $::env(HOME)/.jul/config.tcl
}

proc list_repo {args} {
	global repolist
	global arch

	# if there is no argument, search for all
	if {[lindex $args 0] == {}} {
		set query "WHERE"
	} else {
		set query "WHERE name LIKE '%$args%' and"
	}

	if {$arch != ""} {
		if {$query != ""} {
			append query " and arch = '$arch' and"
		} else {
			set query "WHERE arch = '$arch' and"
		}
	}

	set result {}
	foreach repo [lreverse [array names repolist]] {
		set db_file $::env(HOME)/.jul/[get_db_file $repo]
		if {[catch {sqlite3 db $db_file -create false} fid]} {
			puts stderr "jul: search: Unable to open database file."
			return
		}

		foreach re [lindex $repolist($repo) 0] {
			db eval "SELECT rowid,* FROM package $query repo='$re'" {
				set pkg(rowid) $rowid
				set pkg(name) $name
				set pkg(version) $version
				set pkg(repo) $repo
				set pkg(arch) $arch
				set pkg(build) $build
				db eval "SELECT desc FROM description \
					JOIN package USING(name) \
					WHERE lang = 'en' AND name='$name'" {
					set pkg(desc) $desc
				}
				lappend result [array get pkg]
			}
		}

		db close
	}

	return $result
}

# Returns the file name of the repository 'name'.
proc get_db_file {name} {
	global repolist
	return [lindex $repolist($name) 1]
}

proc add {args} {
	global repolist

	set cmd [lindex $args 0]

	set z 0
	set c 0

	# receive a list of all the packages
	set pkg_list [list_repo [lindex $args 1]]

	if {[llength $pkg_list] == 0} {
		puts "jul: $cmd: No packages found."
		return
	}

	set i 1
	set finds {}
	foreach key $pkg_list {
		array set pkg $key
		lappend finds $pkg(rowid)
		puts -nonewline " \[$i\] $pkg(repo) $pkg(name)-$pkg(version)"
		puts "-$pkg(arch)-$pkg(build)"
		array unset pkg
		incr i
	}

	set z 0
	set c 0
	while {$z == 0} {
		puts "Select a package to $cmd or `q' to quit."
		puts -nonewline "Pressing `enter' selects the top package: "
		flush stdout
		set c [gets stdin]
		set z [checkanswer $c [llength $pkg_list]]
		# If enter was pressed, select the first package.
		if {$z == 2} {set c "1"}
	}

	# lists start at 0
	incr c -1

	set result {}
	foreach repo [lreverse [array names repolist]] {
		set db_file $::env(HOME)/.jul/[get_db_file $repo]
		if {[catch {sqlite3 db $db_file -create false} fid]} {
			puts stderr "jul: $cmd: Unable to open database file."
			return
		}

		db eval "SELECT * FROM repository JOIN package \
		    ON repository.name = package.repo \
		    WHERE package.rowid=[lindex $finds $c]" {
			set p(name) $name
			set p(version) $version
			set p(arch) $arch
			set p(build) $build
			set p(url) $url
			lappend result [array get p]
		}

		db close
	}

	foreach item [getplist] {
		if {"$p(name)-$p(version)-$p(arch)-$p(build)" == $item} {
			puts "jul: $cmd: Package already installed."
			return
		}
	}

	cd "$::env(HOME)/.jul/cache"
	set fn $p(name)-$p(version)-$p(arch)-$p(build).tlz
	set pkg $p(url)$p(name)/$fn
	puts -nonewline "Downloading $p(name)... "
	flush stdout
	getfile $pkg
	puts -nonewline "Downloading checksum... "
	getfile $pkg.sha1sum
	puts -nonewline "Verifying... "

	if {[verify_file $fn.sha1sum] == -1} {
		return -1
	}
	puts "done"

	set pfile $::env(HOME)/.jul/cache/$fn
	catch {exec su -c "pkg $cmd $pfile"} results options
	puts $results
}

# List the changes in 'repo'.
proc changes {repo} {
	global repolist

	if {$repo == ""} {
		puts "jul: changes: You must specify a repository."
		exit
	} elseif {$repo == "-h"} {
		help changes
	}

	if {[lsearch -exact [lreverse [array names repolist]] $repo] == -1} {
		puts "jul: changes: `$repo' is not a valid repository."
		exit
	}

	if {[file exists $::env(HOME)/.jul/repos/$repo.changes] == 1} {
		set f [open $::env(HOME)/.jul/repos/$repo.changes]
		fcopy $f stdout
		close $f
	} else {
		puts -nonewline "jul: changes: Can't list changes for `$repo'."
		puts " Try synchronising."
	}
}

# Check if 'value' is in 'range' and return 1 if that is the case.  Exit if
# 'value' is 'q'.
proc checkanswer {value range} {
	if {$value == "q"} {exit}
	if {$value == ""}  {return 2}

	if {[string is integer -strict $value] == 1} {
		# $value < $range because we start to count from 0 and
		# array size does not
		if {[expr {$value >= 1}] && [expr {$value <= $range}]} {
			return 1
		}
	}

	return 0
}

# Remove '$HOME/.jul'.
proc clean {args} {
	if {$args == "-h"} {help clean}

	if {$args != "-y"} {
		puts "You're about to delete `$::env(HOME)/.jul/' and all of its "
		puts "content."
		puts -nonewline "Proceed? (Y/n) "
		flush stdout

		set c [read stdin 1]
		if {$c == "n" || $c == "N"} {
			puts "Aborted"
		} else {
			file delete -force $::env(HOME)/.jul
			puts "Deleted"
		}
	} else {
		file delete -force $::env(HOME)/.jul
		puts "Deleted $::env(HOME)/.jul and all of its content."
	}
}

proc getfile {url} {
	if {[catch {exec curl -sfO $url} results options]} {
		set details [dict get $options -errorcode]

		puts "failed"
		puts -nonewline "Could not download file: "

		if {[lindex $details 0] eq "CHILDSTATUS"} {
			set status [lindex $details 2]
			if {$status == 22} {
				puts "HTTP error code > 400"
				puts "The file was probably not found."
				puts "Please report this!"
			} elseif {$status == 23} {
				puts "Write error in $::env(PWD)"
			}
		} elseif {[lindex $details 1] eq "ENOENT"} {
			puts "Could not find `curl'. Make sure it is installed."
		} else {
			puts "Unknown error. Please report this!"
		}
	} else {
		puts "done"
	}
}

proc verify_file {fn} {
	if {[catch {exec sha1sum -c $fn} results options]} {
		puts "failed\n"
		puts $results
		puts ""
		return -1
	}
}

# Print the usage of the command passed as 'args' or the help screen if no
# command is passed.
proc help {args} {
	if {$args == ""} {
		usage
		exit
	}

	switch -exact $args {
		changes {
			puts "Usage: jul changes \[options\] repository"
			puts "Shows the changelog of repository.\n"
			puts "Changes command options:"
			puts "  -h          display this help and exit"
		}
		clean {
			puts "Usage: jul clean \[options\]"
			puts "Removes ~/.jul and all of its content.\n"
			puts "Clean command options:"
			puts "  -h          display this help and exit"
			puts "  -y          skip (y/N) prompt"
		}
		default {
			puts "jul: help: $args no such command."
		}
	}

	exit
}

# Lists the installed packages.
proc listpkgs {pattern} {
	foreach item [getplist] {
		if {$pattern != ""} {
			if {[string match "*$pattern*" $item] == 1} {
				puts $item;
			}
		} else {
			puts $item
		}
	}
}

# Return a sorted list of all installed packages.
proc getplist {} {
	set lst {}
	foreach file [glob -nocomplain -directory \
	    "/var/db/pkg" -tails -types f *] {
		lappend lst $file
	}
	return [lsort $lst]
}

proc printColumnarLines {lines} {
	foreach fields $lines {
		set col 0
		foreach field $fields {
			set w [string length $field]
			if {![info exist width($col)] || $width($col) < $w} {
				set width($col) $w
			}
			incr col
		}
	}

	foreach fields $lines {
		set col 0
		foreach field $fields {
			puts -nonewline [format "%-*s " $width($col) $field]
			incr col
		}
		puts "";
	}
}

# Search for packages.
proc search {args} {
	# receive a list of all the packages
	set pkg_list [list_repo [lindex $args 0]]

	# if the number of elements in $pkg_list is 0, put an error and return
	if {[llength $pkg_list] == 0} {
		puts "jul: search: No packages found."
		return
	}

	set lines {}
	foreach key $pkg_list {
		array set p $key
		lappend lines [list $p(repo) \
		    $p(name)-$p(version)-$p(arch)-$p(build) $p(desc)]
	}

	printColumnarLines $lines
}

proc lstrepo {} {
	# fill finds with all available packages
	array set finds [list_repo [lindex "" 0]]

	for {set x 0} {$x < [array size finds]} {incr x} {
		set s [split_pkg [lindex $finds($x) 0]]
		puts $s
	}
}

# Split the package string 'p' into a list and return it.
proc split_pkg {p} {
	# remove the trailing '.tlz'
	set p [string trimright $p ".tlz"]

	# split 'p' at every '-' found
	set psplit [split $p -]

	if {[llength $psplit] > 4} {
		# number of dashes in the package name part
		set dashes [expr {[llength $psplit] - 4}]

		# the new package name, with dashes
		set newname [join [lrange $psplit 0 $dashes] -]

		# replace the elements for the 'package name' with 'newname'
		set psplit [lreplace $psplit 0 $dashes $newname]
	}

	return $psplit
}

proc update {} {
	lstrepo
}

# Get and verify files.
proc dosync {repo} {
	global repolist
	puts "$repo syncing"
	puts -nonewline "Downloading [get_db_file $repo]... "
	getfile [lindex $repolist($repo) 2][get_db_file $repo]
	puts -nonewline "Downloading checksum... "
	getfile [lindex $repolist($repo) 2][get_db_file $repo].sha1sum
	puts -nonewline "Verifying... "
	if {[verify_file $repo.db.sha1sum] == -1} {
		return -1
	}
	puts "done"
}

# TODO: refactor
proc sync {} {
	global repolist

	if {[file exists $::env(HOME)/.jul/cache] == 0} {
		file mkdir $::env(HOME)/.jul/cache
	}

	cd "$::env(HOME)/.jul"

	# loop through all repositories
	foreach repo [lreverse [array names repolist]] {
		set rpo [get_db_file $repo]

		# synchronise if there is no database
		if {[file isfile $rpo] == 0} {
			dosync $repo
		} else {
			# read the local and remote version
			# TODO: only reads first line
			set f [open $::env(HOME)/.jul/$rpo.sha1sum]
			set lver [gets $f]
			close $f

			set rver_file [lindex $repolist($repo) 2]$rpo.sha1sum
			if {[catch {set rver [exec curl -sf $rver_file]} results options]} {
				set details [dict get $options -errorcode]

				puts "Trying to download $rver_file"
				puts -nonewline "Could not download file: "

				if {[lindex $details 0] eq "CHILDSTATUS"} {
					set status [lindex $details 2]
					if {$status == 22} {
						puts "HTTP error code > 400"
						puts "The file was probably not found."
						puts "Please report this!"
					} elseif {$status == 23} {
						puts "Write error in $::env(PWD)"
					}
				} else {
					puts "Unknown error.  Please report this!"
				}

				exit
			}

			# if the local and remote versions are the same, verify
			# the files
			if {$lver == $rver} {
				puts "$repo is up to date"
				puts -nonewline "Verifying... "

				# synchronise if the verification fails
				if {[verify_file $repo.db.sha1sum] == -1} {
					dosync $repo
				} else {
					puts "done"
				}
			} else {
				dosync $repo
			}
		}
	}
}

proc usage {} {
	puts "Usage: jul <command> \[options] \[package|keyword|command]"
	puts "\nCommands:"
	puts "  changes     lists recent changes in the repositories"
	puts "  clean       removes ~/.jul and all of its content"
	puts "  help        display information for a command or this screen"
	puts "  add/install fetch and install packages from repositories"
	puts "  list        list installed or downloaded packages"
	puts "  search      search repositories for packages"
	puts "  sync        synchronise with repositories"
	puts "  upgrade     fetch and upgrade packages from repositories"
	puts "  version     show version of this program"
}

if {$argc > 0} {
	switch -exact [lindex $::argv 0] {
		add     {add add  [lindex $::argv 1]}
		changes {changes  [lindex $::argv 1]}
		clean   {clean    [lindex $::argv 1]}
		help    {help     [lindex $::argv 1]}
		install {add add  [lindex $::argv 1]}
		"list"  {listpkgs [lindex $::argv 1]}
		search  {search   [lindex $::argv 1]}
		sync    {sync}
		update  {update}
		upgrade {add upgrade [lindex $::argv 1]}
		version {puts "This is jul version $version"}
		default {puts "jul: [lindex $::argv 0]: No such command."}
	}
} else {
	usage
}
