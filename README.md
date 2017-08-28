# Learn to Type

A very simple Racket GUI program to learn to type by copying a text.

## How to use

To install, just type in a terminal:
```raco pkg install learn-to-type```

Then run with 
```racket -l learn-to-type```

Copy some text on some webpage and click the paste button. The text appears in the top panel. Then start to type when you are ready.

Some character normalization is applied to avoid uncommon (non-ascii) characters and bad spacing.
The user must then copy the text character by character, without mistake, in the bottom pane.
If any mistake occurs, it must be corrected before going on.

Some statistics are given in the status bar once the text is correctly and entirely typed.
