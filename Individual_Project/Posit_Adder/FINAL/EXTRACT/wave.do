onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /Test_Data_Extraction/In
add wave -noupdate -radix binary /Test_Data_Extraction/Sign
add wave -noupdate -radix binary /Test_Data_Extraction/InRemain
add wave -noupdate -radix decimal /Test_Data_Extraction/RegimeValue
add wave -noupdate -radix binary /Test_Data_Extraction/Exponent
add wave -noupdate /Test_Data_Extraction/Mantissa
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 228
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
WaveRestoreZoom {0 ps} {917 ps}
