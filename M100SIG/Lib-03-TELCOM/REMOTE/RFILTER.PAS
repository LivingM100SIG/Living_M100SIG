program rfilter;

(*************************************************************************

                            RFILTER.PAS

    Purpose: To open a channel to the modem, read characters
      sent from the modem, and write them to a file using
      DOS I/O redirection. RFILTER replaces occurences of
      the carriage-return characters (ASCII 13) with a 
      carriage return and line feed (ASCII 13 and 10), thereby
      pandering to the practices of the Tandy Model 100, 102 and 200.

    Syntax: RFILTER [port baud parity wordsize stop-bits]

    If no parameters are given, the program defaults to
      COM1, 300 baud, even parity, 7-bit word, 1 stop bit.

    Returns error-level 1 to DOS if the parameters are in error,
      error-level 2 if the comm channel can't be opened, and
      error-level 0 if all is okay.

    Written in Borland Turbo Pascal 4.0 and above. In addition to
      standard units, RFILTER uses ASYNC4U.PAS, a package of
      telecommunications routines by Michael Quinlan available
      on the Borland Programming SIG on CompuServe (and probably
      elsewhere)

    By Tim Bovee, CompuServe 72157,677, Herndon, Va., December 1988

*************************************************************************)

uses dos, async;

type
  cmdrecdef = record
               port: integer;
               baud: integer;
               parity: char;
               wordsize: integer;
               stpbits: integer;
             end;

var
  cmdrec: cmdrecdef;
  c: char;

procedure cmdln(var crec: cmdrecdef);

var
  code: integer;
  pstr: string;

begin
  fillchar(crec,sizeof(crec),#000);
  with crec do
    begin
      if paramstr(2) = '' then
        begin
          port := 1;
          baud := 300;
          parity := 'E';
          wordsize := 7;
          stpbits := 1;
        end
      else
        begin
          pstr := paramstr(2);
          val(pstr, port, code);
          if code <> 0 then halt(1);
          pstr := paramstr(3);
          val(pstr, baud, code);
          if code <> 0 then halt(1);
          pstr := paramstr(4);
          parity := pstr[1];
          pstr := paramstr(5);
          val(pstr,wordsize,code);
          if code <> 0 then halt(1);
          pstr := paramstr(6);
          val(pstr,stpbits,code);
          if code <> 0 then halt(1);
        end;
    end;
end;      

procedure initcomm(crec: cmdrecdef);

begin
  with crec do
    if not async_open(port, baud, parity, wordsize, stpbits) then halt(2);
end;

begin
  cmdln(cmdrec);
  initcomm(cmdrec);
  repeat
    if async_buffer_check(c) then
      begin
        write(c);
        if c = #013 then write(#010);
      end;
  until c = #026;
  async_close;
  halt(0);
end.
