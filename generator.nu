
(function forTest () 
	(for ((set i 5) (< i 10) (set i (+ i 1)))
		(puts "inside for")
		(yield "i is #{i}")
		(puts "++") ))

(function whileTest (i)
	(set i 0)
	(while (< i 5)
		(puts "inside while")
		(yield "i is #{i}")
		(set i (+ i 1))
		(puts "end while") ))

(function untilTest (i)
	(until (== i 5)
		(puts "inside until")
		(yield "i is #{i}")
		(set i (+ i 1))
		(puts "end until") ))

(NuYieldOperator install)
((forTest) each:(do (j) 
	(puts j) 
	(puts "--") ))

((whileTest 1) each:(do (i)
	(puts i)
	(puts "@@") ))

((untilTest 0) each:(do (j)
	(puts j)
	(puts "$$") ))

