#On quitte la simulation en cours éventuelle 
quit -sim 
#directives de compilation des fichiers sources 
vcom multiplication.vhd                               
vcom testmult.vhd 
#lancement du simulateur (résolution de 1ns) 
vsim -t 1ns work.test(bench) 
#ajout des signaux dans la fenêtre de simulation  

add wave -noupdate -divider {entrees du bloc multiplication} 
add wave -noupdate sim:/test/clk
add wave -noupdate -radix unsigned -radixshowbase 0 sim:/test/multiplieur
add wave -noupdate -radix unsigned -radixshowbase 0 sim:/test/multiplicande
add wave -noupdate sim:/test/rst
add wave -noupdate sim:/test/go

add wave -noupdate -divider {sorties du bloc multiplication} 
add wave -noupdate -radix unsigned -radixshowbase 0 sim:/test/S
add wave -noupdate sim:/test/fin

add wave -noupdate -divider {signaux internes} 
add wave -noupdate sim:/test/UUT/c
add wave -noupdate -radix hexadecimal -radixshowbase 0 sim:/test/UUT/q
add wave -noupdate -radix hexadecimal -radixshowbase 0 sim:/test/UUT/a
add wave -noupdate -radix hexadecimal -radixshowbase 0 sim:/test/UUT/i
add wave -noupdate sim:/test/UUT/etat

#simulation de 1us 
run 400 ns