Doug Roberts left me a note inquiring about the possibility of a version of Redial that would recognize when a voice 
answered.  I left him a short response, suggesting where he might start; then, on further thought, decided to move 
the discussion into the public.


Beginnings:  The solution to the problem, if it exists, is in larry gensch's essay on the M100 Carrier Detect routine
-- which is available under CARDET.TXT in XA4.  You have to understand how CARDET works before you begin, else the 
problem cannot be solved.  Very briefly, what it does is check to see if the incoming tone meets a specific 
description. If yes, it (immediately) verifies that check.  But the details are important; you should not (indeed, 
cannot) depend on that summary if you want to detect a different signal.

The necessary trick is to modify the CARDET routine to check for some other signal.  That can be done.  BUT WHAT 
SIGNAL DO YOU WANT CARDET TO LOOK FOR?  Ah, there's the rub....


Larry briefly addresses the problem toward the end of his essay, and even suggests a routine for finding the "right" 
signal.

What I'm going to do, now, is address that in a bit more detail.

First off:  Detecting a modem carrier is an EASY problem.  The carrier has to meet a specific description.  If the 
signal at hand doesn't meet that description, return a NO and try again.  That's what CARDET does.

Detecting a voice -- or a busy signal, or a ringing phone -- is probably a more difficult problem.  None of these 
have really obvious characteristics; moreover, they're by nature only intermittent signals.

That doesn't, however, mean that they cannot be detected.  It's possible -- maybe likely -- that all phone rings are 
enough alike that M100 can recognize them, if you teach it to ask the right quesions.  Likewise busy signals.  
Possibly even likewise voices.  I dunno; it's far outside my area of interest.


So, then:  What's the next step?

First, you gotta find out if voice/ busy signal/ ringing phone can be detected.  That's why you read CARDET; larry 
tells you how to go about that.  (Beware:  The method larry suggests is trial and error.  Not my idea of fun.  I'm 
hoping one of you wants this badly enough to do the work.)  Then you study Dialer.100 (XA1) in order to understand 
how Redial's constructed.  Then you make the necessary modifications....

The necessary modifications, by the way, include the following:

1) Identify busy signal. (Try again.  We already know how to handle this.)

2) Identify phone ringing.  (If no answer after ??? time, sound off and hang up.)

3) Identify modem answered.  (We already know how to handle this.)

4) Identify voice answered.  (Now, then: probably program should sound off, somehow, and go into a holding routine.)


An offer.  If someone can solve the basic identification problems; I'll happily make the necessary modifications to 
Redial.  It's an interesting problem, but I'm not interested enough to solve it.

Best wishes, all.


Joel Dinda
.[75725,1134]
.CompuNet TBBS
.Lansing, Michigan
.(517)339-3367

