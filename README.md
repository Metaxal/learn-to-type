# Learn to Type

A very simple Racket GUI program to learn to type by copying a text.

The intended use is to copy (in the clipboard) some paragraph picked on the Web and press the `paste` button. The text appears in the top pane.
Some character normalization is applied to avoid uncommon (non-ascii) characters and bad spacing.
The user must then copy the text character by character, without mistake, in the bottom pane.
If any mistake occurs, it must be corrected before going on.

Some statistics are given in the status bar once the text is copied.
