#On quitte la simulation en cours éventuelle 
quit -sim 
#directives de compilation des fichiers sources 
vcom exo1.vhd    
vcom exo1_operateur.vhd                              
vcom simu_exo1.vhd 
#lancement du simulateur (résolution de 1ns) 
vsim -t 1ns work.test(bench) 
#ajout des signaux dans la fenêtre de simulation  

add wave -noupdate -divider {entrees du bloc} 
add wave -noupdate -radix unsigned -radixshowbase 0 sim:/test/A
add wave -noupdate -radix unsigned -radixshowbase 0 sim:/test/B
add wave -noupdate -radix binary sim:/test/S
add wave -noupdate sim:/test/Cin

add wave -noupdate -divider {sorties du bloc} 
add wave -noupdate -radix unsigned -radixshowbase 0 sim:/test/G
#add wave -noupdate sim:/test/Cout
add wave -position end  sim:/test/Cout

#simulation de 190 ns
run 200 ns