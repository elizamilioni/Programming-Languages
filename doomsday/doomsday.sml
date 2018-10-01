fun doomsday filename= 
let
  open Array2
  open Queue;
  fun columns (x::xs, i) = if x <> #"\n" then columns(xs, i+1) else i
  fun rowss([],i) = i
    | rowss (x::xs, i)= if x = #"\n" then rowss(xs, i+1) else rowss(xs,i)
  fun parse file =
  let
    fun next_String input = (TextIO.inputAll input) 
    val stream = TextIO.openIn file
    val string_list = next_String stream
  in
    explode(string_list)
  end

  val l = parse filename
  val rows = rowss(l,0)
  val cols = columns(l,0)
  val a = array(rows, cols, #"0")
  val flagsp = array(rows, cols, #"0")
  val flagsm = array(rows, cols, #"0")
  val  worldIsSaved : int ref = ref 0
  val doomsdayTime : int ref = ref 0

  fun arrayfromList(a, _, _, []) = a
    |   arrayfromList(a, i, j, x::xs) = 
    if (x <> #"\n") then (update(a, i, j, x); arrayfromList(a, i, j+1, xs))
    else arrayfromList(a, i+1, 0, xs)

  val arr = arrayfromList(a, 0, 0, l)
  val q = Queue.mkQueue() : int Queue.queue;

  fun typwse(arr, rows, cols, i, j) =
    (if (i <= rows) then (  
        if (j <= cols) then ( 
                print(Char.toString(sub(arr, i, j)));
                typwse(arr, rows, cols, i, j+1)
        )
        else (print "\n"; typwse(arr, rows, cols, i+1, 0))
    )
    else ()
    )

  fun FindPlusMinusPushInQueue(arr,rows,cols,i,j)=
    (if (i <=rows) then (
        if (j <=cols) then (
                if ((sub(arr,i,j) = #"+") orelse (sub(arr,i,j) = #"-"))
                then (
                        enqueue(q,i);
                        enqueue(q,j); 
                        enqueue(q,Char.ord(sub(arr,i,j)));
                        enqueue(q,0);
                        FindPlusMinusPushInQueue(arr, rows, cols, i, j+1))
                else(FindPlusMinusPushInQueue(arr, rows, cols, i, j+1)) 
                )
        else ( FindPlusMinusPushInQueue(arr, rows, cols, i+1,0))
        )
    else())
    (* print "lala\n"; print (Int.toString(dequeue q));
    print (Int.toString(dequeue q)); print (Int.toString(dequeue q)); print (Int.toString(dequeue q)); print "\n");		 *)

  fun checkIfDoomsday(newX,newY,oldProsimo,newProsimo, newTime) = 
    (if ((newProsimo <> oldProsimo)  andalso (newProsimo <> #"X")) then(	
        (worldIsSaved := !worldIsSaved + 1);
        update(arr,newX,newY,#"*");
        if (!worldIsSaved = 1 ) then (
                doomsdayTime := !doomsdayTime + newTime;
                print(Int.toString(newTime));
                print "\n" 
                )
        else ()
    )  
    else () );

  fun pushInQueue (newProsimo,oldProsimo,newX,newY,newTime) =
    (if (newProsimo = #".") then(
        update(arr,newX,newY,Char.chr(oldProsimo));
        enqueue(q,newX);
        enqueue(q,newY);
        enqueue(q,Char.ord(sub(arr,newX,newY)));
        enqueue(q,newTime)
    )
    else
      checkIfDoomsday(newX,newY,Char.chr(oldProsimo),newProsimo,newTime)
      )

  fun expandPlusMinus(oldX,oldY,oldProsimo,oldTime) = 
    (if (oldX + 1 < rows) then
      ( pushInQueue (sub(arr,oldX+1,oldY),oldProsimo,oldX+1,oldY,oldTime+1))
    else ();
    if (oldX - 1 >= 0) then 
      ( pushInQueue (sub(arr,oldX-1,oldY),oldProsimo,oldX-1,oldY,oldTime+1))
    else();

    if (oldY + 1 < cols) then
      ( pushInQueue (sub(arr,oldX,oldY+1),oldProsimo,oldX,oldY+1,oldTime+1))
    else();

    if (oldY - 1 >= 0) then
      ( pushInQueue (sub(arr,oldX,oldY-1),oldProsimo,oldX,oldY-1,oldTime+1))
    else()
    );

  fun LASTexpandPlusMinus(oldX,oldY,oldProsimo,oldTime) = 
    ( if (oldTime < !doomsdayTime) then (	
        if (oldX + 1 < rows)
        then
                ( pushInQueue (sub(arr,oldX+1,oldY),oldProsimo,oldX+1,oldY,oldTime+1))
        else ();

        if (oldX - 1 >= 0) then 
                ( pushInQueue (sub(arr,oldX-1,oldY),oldProsimo,oldX-1,oldY,oldTime+1))
        else();

        if (oldY + 1 < cols) then
                ( pushInQueue (sub(arr,oldX,oldY+1),oldProsimo,oldX,oldY+1,oldTime+1))
        else();

        if (oldY - 1 >= 0) then
                ( pushInQueue (sub(arr,oldX,oldY-1),oldProsimo,oldX,oldY-1,oldTime+1))
        else()
       )
      else() 
    );

  fun loopa a = 
    (if (isEmpty q = false) then ( 
        if (!doomsdayTime = 0 ) then (
                expandPlusMinus (dequeue q,dequeue q,dequeue q,dequeue q); loopa(5) )
        else (LASTexpandPlusMinus (dequeue q,dequeue q,dequeue q,dequeue q); loopa(5) )
    )
    else ()
    );

  in
    FindPlusMinusPushInQueue(arr,rows-1,cols-1,0,0);
    loopa(5);
    if (!worldIsSaved = 0 )
    then( print ("the world is saved\n") )
    else();
    typwse(arr, rows-1, cols-1, 0, 0)
  end        
