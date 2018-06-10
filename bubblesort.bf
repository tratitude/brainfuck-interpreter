[Here is a Brainf*** program that bubblesorts its input and spits it out:]

>>>>>,														; leave #0 ~ #4
------------------------------------------------			; ASCII shifting
[>>>,------------------------------------------------]		; input until '0' and store a number every 3 bytes
<<<									; switch back to the last input located

[																	{ function bbsort }
									; this function will move the smallest number to the first location

	<<<								; previous number
	[																{ function swap }
									; (0) (0) (A) (0) (0) (B)
									; $0  $1  $2  $3  $4  $5
									; Initial place = $5
	
		>>>							; next number
		[															{ function Compare }						
			-<<<-<+>				; dec A and B  inc $1
			[>]						; go to next 0					{ function F1 }
			>>						; go right 2 bytes
			
									; if A>B: F1 stops at $3 leave loop at $5
									; if A<=B: F1 stops at $2 leave loop at $4
									; $1 = min(A_B)
		]
		
		<<<[<]>>					; go to $2	
		[>>>+<<<-]					; destructively add $2 to $5
		<							; go to $1
		[>+>>>+<<<<-]				; desturctively add $1 to $2 and $5
		
		<<							; go to previous number
		
	]								; if there's a previous number: start function swap again at $2
									; else break
	
	>>>								; go to first number
	[++++++++++++++++++++++++++++++++++++++++++++++++.[-]]	; ASCII shifting output and clear					
	
	>>>[>>>]<<<						; go to last number
]									; start bbsort again until there's no number left
