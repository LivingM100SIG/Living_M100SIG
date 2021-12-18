GIMME A BREAK! (Part 1: Software)

Here is a little bit of code that will enable your Model 100 to send TRUE BREAK
signals:

    64 CALL 28277, 0, 256: PRINT #2, CHR$(0);:
       CALL 28277, 0, 256*((PEEK(-2469)+6)MOD26):RETURN

HOW IT WORKS: This sets the UART baud rate to 75 baud (the slowest that the
M100 will go), sends a NULL to the modem, and resets the baud rate to whatever
it should be. The big hairy expression surrounding the PEEK is needed so that
both internal and external modems are handled correctly, and your favorite baud
rate (set in TELCOM) is restored.

The general approach should work with any modem program; trim the PRINT#2
statement to fit your way of sending a character to the modem.

    Enjoy,
    Greg Limes
