#On quitte la simulation en cours éventuelle 
quit -sim 
#directives de compilation des fichiers sources 
vcom exo2.vhd                                
vcom simu_exo2.vhd 
#lancement du simulateur (résolution de 1ns) 
vsim -t 1ns work.test(bench) 
#ajout des signaux dans la fenêtre de simulation  

add wave -noupdate -divider {entrees du bloc} 
add wave -noupdate sim:/test/rst
add wave -noupdate sim:/test/H
add wave -noupdate sim:/test/rw
add wave -noupdate sim:/test/enable
add wave -noupdate -radix binary sim:/test/datain

add wave -noupdate -divider {sorties du bloc} 

add wave -noupdate sim:/test/empty
add wave -noupdate sim:/test/full
add wave -noupdate -radix binary sim:/test/dataout
add wave -noupdate -radix binary sim:/test/UUT/reg
add wave -noupdate -radix binary sim:/test/UUT/q
add wave -noupdate -radix binary sim:/test/UUT/mux

#simulation de 190 ns
run 500 ns
