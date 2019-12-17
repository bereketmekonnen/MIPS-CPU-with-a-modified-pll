package require ::quartus::project
project_open "C:/My_Designs/my_first_fpga.qsf"
set f [open "C:/My_Designs/espinoza_lab3/part2/synthesis/pin_assignments.qsf" w]
set asgn_col [get_all_instance_assignments -name *]

foreach_in_collection asgn $asgn_col {

   set id [lindex $asgn 0]
   set from [lindex $asgn 1]
   set to [lindex $asgn 2]
   set name [lindex $asgn 3]
   set value [lindex $asgn 4]
   set ename [lindex $asgn 5]
   set tag [lindex $asgn 6]
   set cmd "set_instance_assignment "
	if {$ename != ""} {append cmd "-entity $ename "}
	if {$from != ""} {append cmd "-from $from "}
	append cmd "-name $name "
	if {[string is integer -strict $value]} {if  {$value < 10 && $value > 0} {append cmd "$value "} else {append cmd "\"$value\" "} } else {append cmd "\"$value\" "}
	if {$id != ""} {append cmd "-section_id $id "}
	if {$tag != ""} {append cmd "-tag $tag "}
	if {$to != ""} {append cmd "-to $to "}
	puts $f $cmd
}

close $f
