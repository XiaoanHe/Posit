onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -childformat {{{/Test_Alignment/InRemain1[6]} -radix binary} {{/Test_Alignment/InRemain1[5]} -radix binary} {{/Test_Alignment/InRemain1[4]} -radix binary} {{/Test_Alignment/InRemain1[3]} -radix binary} {{/Test_Alignment/InRemain1[2]} -radix binary} {{/Test_Alignment/InRemain1[1]} -radix binary} {{/Test_Alignment/InRemain1[0]} -radix binary}} -expand -subitemconfig {{/Test_Alignment/InRemain1[6]} {-height 15 -radix binary} {/Test_Alignment/InRemain1[5]} {-height 15 -radix binary} {/Test_Alignment/InRemain1[4]} {-height 15 -radix binary} {/Test_Alignment/InRemain1[3]} {-height 15 -radix binary} {/Test_Alignment/InRemain1[2]} {-height 15 -radix binary} {/Test_Alignment/InRemain1[1]} {-height 15 -radix binary} {/Test_Alignment/InRemain1[0]} {-height 15 -radix binary}} /Test_Alignment/InRemain1
add wave -noupdate -radix binary -childformat {{{/Test_Alignment/InRemain2[6]} -radix binary} {{/Test_Alignment/InRemain2[5]} -radix binary} {{/Test_Alignment/InRemain2[4]} -radix binary} {{/Test_Alignment/InRemain2[3]} -radix binary} {{/Test_Alignment/InRemain2[2]} -radix binary} {{/Test_Alignment/InRemain2[1]} -radix binary} {{/Test_Alignment/InRemain2[0]} -radix binary}} -expand -subitemconfig {{/Test_Alignment/InRemain2[6]} {-height 15 -radix binary} {/Test_Alignment/InRemain2[5]} {-height 15 -radix binary} {/Test_Alignment/InRemain2[4]} {-height 15 -radix binary} {/Test_Alignment/InRemain2[3]} {-height 15 -radix binary} {/Test_Alignment/InRemain2[2]} {-height 15 -radix binary} {/Test_Alignment/InRemain2[1]} {-height 15 -radix binary} {/Test_Alignment/InRemain2[0]} {-height 15 -radix binary}} /Test_Alignment/InRemain2
add wave -noupdate -radix decimal /Test_Alignment/RegimeValue1
add wave -noupdate -radix decimal /Test_Alignment/RegimeValue2
add wave -noupdate -radix binary /Test_Alignment/Exponent1
add wave -noupdate -radix binary /Test_Alignment/Exponent2
add wave -noupdate -radix decimal /Test_Alignment/E_diff
add wave -noupdate /Test_Alignment/Alignment1/R_diff
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {79018 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {420 ns}
