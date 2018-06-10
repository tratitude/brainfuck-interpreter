# Brainfuck-interpreter
- Written in masm 32bits assembly
- Develop environment on visual studio 2017, using [Irvine library](http://kipirvine.com/asm/gettingStartedVS2017/index.htm)
- Try some example in brainfuck-example directory
- Brainfuck-visualizer and some example [moky/BrainFuck](https://github.com/moky/BrainFuck)

## Program processing flow
1. Editing brainfuck source file .bf
2. Run main.exe
3. Input source file's location
4. Print the output on screen

## Syntax
|Brainfuck|C|
|:---:|:---:|
|>|++ptr;|
|<|--ptr;|
|+|++*ptr;|
|-|--*ptr;|
|.|putchar(*ptr);|
|,|*ptr = getchar();|
|[|while (*ptr) {|
|]|}|