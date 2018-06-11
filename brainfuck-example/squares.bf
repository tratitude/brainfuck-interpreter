[adding plus signs at the beginning will increase the range of result output]

;	TTL	NXT	INC	TMP	STP	(  CRLF  )	( NUM SET )
;	%0	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13
;					STP	0	LF	1	TMP	NUM	CHK			
;		$0	$1	$2	$3	$4	$5	$6	$7	$8	$9					{SQUARE}
;									
;								#n3	#n2	#n1	#0					{PRINT} applied to any NUMSET and CRLF
;										NUM	ABS								
;								$0	$1	$2	$3	$4	$5	$6		{COMPUTE}

TTL: total run times
NXT: the value needs to be added in next round
INC: increasing value
TMP: temp value
STP: general stop point
CHK: show if there's a number
ABS: abstracted value for calculating

++++										; %0 = 4
[>+++++<-]									; %1 = 4 * 5 = 20			%0 = 0
>[<+++++>-]									; %0 = 20 * 5 = 100			%1 = 0
+<+											; %1 = 1					%0 = 101

[											function {SQUARE} run %0 (TTL) minus 1 times and calculate squares
    >										; start from %1 == $0
	[>+>+<<-]								; copy $0 to $1 and $2		$0 = 0
	++>>									; $0 = 2					$2
	[<<+>>-]								; add $2 to $0				$2 = 0
	>>>[-]++								; $5 = 2
	>[-]+									; $6 = 1
    >>>+									; inc $9 (for loop starting?)
	[[-]++++++>>>]							; set current $ to 6 then go 3 byte right				until there's a 0
	<<<										; go back to the last data available == #0
	
											; ASCII '0' == 48
	[											function {PRINT} print every number exists in reverse order
		[<++++++++<++>>-]+					; add #n1 8* #0			#n2 = 2 * #0					#0 = 1
		<.<[>----<-]<						; output #n1				clear #n1 #n2				go to #n3
	]											{PRINT} always stop at %4 (STP)
	
											; since %4 keep being 0		it always stops at %4
    <<										; go to %2					%7 == $0 (the first digit)
	
	[											function {RECURSIVE} run %2 (INC) times and increase the certain value
		>>>>>								; go to $0
		[											function {COMPUTE} make carry overs when triggering multiple times
			>>>[-]+++++++++					; $3 = 9 (fill CHK)
			<[>-<-]+++++++++>				; dec $3 $2	(get ABS)		$2 = 9	(fill NUM)			go to $3 (ABS)
			[											function {INCREASE} stay at $3 if don't run: Check if this needs carry
				-[<->-]+					; $2 = add ( dec $2 $3 ) 1	(equals to "inc NUM 1")		$3 = 1
				[<<<]						; go to previous number (LF won't be changed by this method)
			]											{INCREASE} will always stop at %4 (STP)
			
			<[>+<-]>						; add %3 to %4				%3 = 0	(clear TMP)			go to %4	{INCREASE}
											; add $2 to $3				$2 = 0	(clear NUM)			go to $3	{NO INCREASE}
			
		]											{COMPUTE} will always stop at %4 if {INCREASE}
		
		<<-									; dec %2
	]											{RECURSIVE} will always stop at %2 (INC)
	<<-										; dec %0
]											{SQUARE} start again but now with 1 less on %0