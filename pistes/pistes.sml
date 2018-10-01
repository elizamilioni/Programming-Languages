fun pistes file =
    let
       	
	val inStream = TextIO.openIn file
	fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    val N = readInt inStream

    fun list_For_Keys(0,list_Of_IDs) = list_Of_IDs 
    | list_For_Keys(i,list_Of_IDs) = list_For_Keys(i-1, readInt inStream::list_Of_IDs)

   	fun readInts(0, list_Of_Pistes) = list_Of_Pistes
          | readInts(i, list_Of_Pistes) = 
	        let
	            val number_Of_rk_keys = readInt(inStream)
	            val number_Of_ek_keys = readInt(inStream)
	            val stars = readInt(inStream)
	            val required_keys = list_For_Keys(number_Of_rk_keys, [])
	            val earned_keys = list_For_Keys(number_Of_ek_keys, [])
	            val pista = (N+1-i,number_Of_rk_keys, number_Of_ek_keys, stars, required_keys, earned_keys)
            in
                readInts(i-1, pista::list_Of_Pistes)
	        end

	val list_Of_Pistes = rev (readInts(N+1, [])) 
	val pista = hd list_Of_Pistes
		
	fun first  (a,_,_,_,_,_) = a
	fun second (_,b,_,_,_,_) = b
	fun third  (_,_,c,_,_,_) = c
	fun fourth (_,_,_,d,_,_) = d
	fun fifth  (_,_,_,_,e,_) = e
	fun sixth  (_,_,_,_,_,f) = f
	fun firstp (a,_,_,_) = a
	fun secondp (_,b,_,_) = b
	fun thirdp (_,_,c,_) = c
	fun fourthp (_,_,_,d) = d
	
	(*fun print_contents [] = print "\n"
	  | print_contents l = (print ( (Int.toString (firstp (hd l))) ^ " "); print_contents (tl l)) 

	fun print_l_contents [] = print "\n"
	  | print_l_contents l = (print ( (Int.toString (hd l)) ^ " "); print_l_contents (tl l)) 
	*)
    fun remove_key(inventory, index) = 
	    if index = 1 then List.drop (inventory, 1) 
		else List.take(inventory, index-1) @ List.drop(inventory, index)

	fun check_key ([], rk_key, i) = (false, i)
	  | check_key (inventory, rk_key:int, i) = 
	  	if (hd inventory = rk_key) then (true, i)
		else check_key(tl inventory, rk_key, i+1)

	fun check_keys (inventory, []) = true
	  | check_keys (inventory, rk_keys) =
		let 
		  	val check_tuple = check_key (inventory, hd rk_keys, 1)
		in
		  	if #1 check_tuple then check_keys ((*new state_list*)remove_key(inventory, #2 check_tuple), tl rk_keys)
		  	else false
		end

	fun check_Visited_Pista (index, []) = false
	  | check_Visited_Pista (index:int, visited) = 
		if (hd visited = index) then true
		else check_Visited_Pista (index, tl visited)

	fun next_States (state, [], newStates) = newStates
	  | next_States (state, pistes, newStates) =
		let 
			val pista     = hd pistes
			val index     = first pista
			val stars     = fourth pista
			val rk_keys   = fifth pista
			val ek_keys   = sixth pista
			val tstars    = secondp state
			val visited   = thirdp state
			val inventory = fourthp state
			fun remove (whole_inv, [], item, i) = []
	   		  | remove (whole_inv, inv, item, i) = 
				if (item = hd inv) then remove_key(whole_inv, i)
				else remove(whole_inv, tl inv, item, i+1)
				
			fun remove_Keys (inv, []) = inv
	   		  | remove_Keys (inv, rk_keys) = remove_Keys(remove(inv, inv, hd rk_keys, 1), tl rk_keys)
			
			val new_inv = remove_Keys(inventory, rk_keys)
			fun next_State() = (index, tstars+stars, index::visited, new_inv @ ek_keys)
		in
			if (not (check_Visited_Pista(index, visited)) andalso check_keys(inventory,rk_keys)) then
			    	 next_States (state, tl pistes, next_State() :: newStates)
			else next_States (state, tl pistes, newStates)
		end
			
	val initial_State  = (first pista, fourth pista, first pista :: [], sixth pista)
	val visited_States = [initial_State]

	val myqueue = Queue.mkQueue()
	val _ = Queue.enqueue(myqueue, initial_State)
	
	(*fun print_q_contents () =
	let
		val contents = Queue.contents myqueue 
	in
		(print_contents contents)
	end*)

	fun quick_check_states (state, []) = false
          | quick_check_states (state, visited) = 
		if firstp state = firstp (hd visited) then true
		else quick_check_states(state, tl visited)

	fun equal_list (list1, list2) = check_keys(list1, list2) andalso check_keys(list2,list1)

	fun check_states (state, []) = false
	  | check_states (state, visited_states) = 
		let 
			val v_state = hd visited_states
			val list_visited = thirdp v_state
		in
			if (equal_list(thirdp state, list_visited) andalso equal_list(fourthp state, fourthp v_state)) then true 
			else check_states(state, tl visited_states) 
		end 
	
	
	fun push (state, visited_states) = 
		(Queue.enqueue(myqueue, state);	state::visited_states)	
		
	fun check_score(state, max) = 
		if(secondp state > max) then secondp state
		else max	

	fun check_new_visited (visited_states, []) = visited_states 
	  | check_new_visited (visited_states, next_states) = 
		let 
			val n_state = hd next_states
			val q = quick_check_states (n_state, visited_states)
			val p = check_states(n_state, visited_states)
		in 
			if (not q orelse not p) then check_new_visited(push(n_state, visited_states), tl next_states)	
			else check_new_visited (visited_states, tl next_states) 
		end

	fun bfs(visited_States, max_score) =
		let 
			val curr = Queue.dequeue(myqueue)
			val new_visited = check_new_visited (visited_States, next_States(curr, list_Of_Pistes, []))
		in 
			bfs(new_visited, check_score(curr, max_score))
		end	  
		handle Dequeue => max_score
	
    in
	    print ( (Int.toString (bfs (visited_States,0))) ^ "\n")
    end
