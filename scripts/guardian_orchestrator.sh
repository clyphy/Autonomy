#!/bin/bash
echo "╔═══ OCETI WEAVE GUARDIAN ═══╗"
echo "║ Turtle Mountain · Day $(date +%j) ║"
echo "╚════════════════════════════╝"
echo "1) Sunrise 2) Council 3) Pulse 4) Drum 5) Exit"
read opt
case $opt in 1) echo "sunrise ritual";; 3) ./calculate_L.sh;; 4) sqlite3 ~/memory_drum.db "SELECT * FROM coherence_log DESC LIMIT 5";; 5) exit;; esac
