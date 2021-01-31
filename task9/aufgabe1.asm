Aufgabe 1: MIPS-Makrobefehle

1. # Kopiert Wert von %rs nach %rd
.macro mov (%rd, %rs)
	add %rd, %rs, $zero
.end_macro

2. # Schiebt Wert %reg auf den Stack
.macro push (%reg)
	sw %reg, (%sp)
	sub %sp, %sp, 4
.end_macro

3. # Holt den obersten Wert vom Stack
.macro pop (%reg)
	add %sp, %sp, 4
	lw %reg, (%sp)
.end_macro

4. # %rd = %rs * %rt; %rd: least 32 bit
.macro mult (%rd, %rs, %rt)
	mult %rs, %rt
	mflo %rd
.end_macro

5. %rd = %rs / %rt
.macro div (%rd, %rs, %rt)
	div %rs %rt
	mflo %rd
.end_macro

6. # %rd = %rs % %rt
.macro mod (%rd, %rs, %rt)
	div %rs, %rt
	mfhi %rd
.end_macro

7. # %reg = ~% reg
.macro not (%reg)
	nor %reg, %reg, %reg
.end_macro

8. # %reg = 0
.macro clear (%reg)
	xor %reg, %reg, %reg
.end_macro

9. # Rotiert %imm Bits nach rechts
.macro ror (%reg, %imm)
	srl $at, %reg, %imm
	sll %reg, %reg, 32-%imm
	or %reg, %reg, $at
.end_macro

10. # Rotiert %imm Bits nach links
.macro rol (%reg, %imm)
	sll $at, %reg, %imm
	srl %reg, %reg, 32-%imm
	or %reg, %reg, $at
.end_macro

11. # if (%rs > %rt) goto % label
.macro bgt (%rs, %rt, %label)
	slt $at, %rt, %rs
	bne $at, $zero, %label
.end_macro

12. # if (% rs <= %rt) goto % label
.macro ble (%rs, %rt, %label)
	slt $at, %rt, %rs
	beq %at, $zero, %label
.end_macro
