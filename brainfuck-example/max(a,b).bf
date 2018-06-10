,>,>[-]>[-]>[-]>[-]>[-]<<<<<< // clear cells #2~6
[->>+>+>+<<<<]              // copy cell #0 to #2 #3 #4
>>>[-<<<+>>>]<<<            // move cell #3 back to #0
>[->>+>>+>+<<<<<]<          // copy cell #1 to #3 #5 #6
>>>>>>[-<<<<<+>>>>>]<<<<<<  // move cell #6 back to #1

>>>>                        // check cells: { a b a b(a b)0 }
    /**
     *  2nd:  compare(#4 AND #5);
     */
    [->                     // decrease cell #4
            [               // if cell #5 not 0
                -[->+<]     //     decrease and move to #6
            ]
            >[-<+>]<        // move cell #6 back to #5
    <]
    /**
     *  3rd:  if (#4 SMALLER_THAN #5) {
     *            #2 = #3;
     *        }
     */
    >[                      // if cell #5 not equls 0
        <<<[-]>[-<+>]       //     move cell #3 to #2
        >>[-]               //     clear cell #5
    ]<
    <[-]>                   // clear cell #3
<<.<<