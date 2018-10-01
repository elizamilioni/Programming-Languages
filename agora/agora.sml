fun agora file =
	let
(* A function to read an integer from specified input. *)
	fun readInt input = 
Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

(* Open input file. *)
	val inStream = TextIO.openIn file

(* Read an integer (number of villages) and consume newline. *)
	val N = readInt inStream;
	val _ = TextIO.inputLine inStream;

(* A function to read N integers from the open file. *)
	fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
| readInts i acc = readInts (i - 1) (readInt inStream :: acc)

	fun gcd (a,0) = a
	| gcd (0,b) = b
| gcd (a,b) = if a < b then gcd (a, b mod a) else gcd (b, a mod b)

	fun hd_ex [] = IntInf.fromInt 1
	| hd_ex (h::t) = h

	fun tl_ex [] = []
	| tl_ex (h::t) = t

fun lcm (a:IntInf.int, b:IntInf.int) = let val d = gcd (a, b)
	in (a div d)*b
	end

	val first_list = readInts N [];
	val first_int = [hd first_list];

	fun lcm_l_r (0, list1, acc2:IntInf.int list) = acc2
	| lcm_l_r (i, list1, []) = lcm_l_r (i-1, tl list1, [Int.toLarge (hd list1)]) 
| lcm_l_r (i, list1, acc2) = lcm_l_r (i-1, tl list1, (lcm(Int.toLarge (hd list1), hd acc2))::acc2)		

	val lcm_list_l_r = lcm_l_r(N, first_list, [])
	(*val rev_list_l_r = rev lcm_list_l_r*)
val lcm_list_r_l = lcm_l_r(N, rev first_list, [])
	val list1 = tl lcm_list_r_l
val list_beta = rev (tl lcm_list_l_r)

	fun find_solution (lcm_list_r_l, lcm_list_l_r , i, min, pos, lim) = 
if (i = lim ) then (min, pos) 
	else 
	let fun solution (previous_sol) =
let val cur_sol = lcm (hd_ex lcm_list_l_r, hd_ex lcm_list_r_l)
	in
if cur_sol < previous_sol then (cur_sol,i+1) else (previous_sol, pos)

	end 
	in 
find_solution(tl_ex lcm_list_r_l, tl_ex lcm_list_l_r, i+1, #1 (solution(min)), #2 (solution(min)), lim)
	end
val final_solution = find_solution( tl list1, rev ( lcm_list_l_r), 1, lcm(1,hd list1), 0, N ) 
	in
	print(IntInf.toString(#1 final_solution));
	print(" ");
	print(Int.toString(#2 final_solution));
	print("\n")
	end        
