0'  ORDER.BA by Bob Michaud 75715,44 ORDER.BA allows for the entry of item numbers,number of items, cost
5' per item and amount - entered into four arrays. The number of items to be entered is limited only
10' by the available memory. Users must answer two preliminary prompts used in dimensioning the arrays and for
15'computing critical variables in the program. After all entries are made,an additional prompt for the discount
20' rate (entered with no decimal) is requested. After this entry,the program then begins to display the data for  
22' transfer to a sale order form.Each display contains the number of items requested in the initial prompt
24 'IMPORTANT!! In order to continue the program, press any key to see the next display. The last display shows the
26' subtotal,discount (if any) and the total. Address questions to Bob Michaud,75715,44.
100 DEFSTRA-G:DEFSNGO-Q:DEFINTH-N:DEFDBLR-W:DEFINTX-Z
105 F(1)="Item #":F(2)="Number":F(3)="Cost per item":L=0:S=0
110 CLS:PRINT@2,"Limit to five items on each display"
112FORK=1TO2000:NEXTK
114PRINT@42,;:INPUT"Total number of items ";M:PRINT@82,;:INPUT"Number of items on first display ";N
115 DIMH(M):DIMO(M):DIMP(M):DIMR(M):
120 FORK=1TOM
125 CLS
130 IFK=1THENPRINT@2,;:INPUT"Enter the 'first' item ";H(K):GOTO140
135 CLS:PRINT@2,"Previous item = ";H(K-1):PRINT@42,;:INPUT"Next item = ";H(K)
140 PRINT@82," ";F(2):INPUT" ";O(K)
145 PRINT@122," ";F(3):INPUT" ";P(K)
150 NEXT
155 FORK=1TOM
160 R(K)=O(K)*P(K)
165 S=S+R(K)
170 NEXTK
175 CLS:PRINT@2,;:INPUT"Discount";U
180 V=(S*U)/100:T=S-V
185 CLS
190 L=1:X=1:Y=M\N:Z=MMODN:LL=1:GOTO200
195 X=X+1:LL=LL+1
200 CLS:PRINTUSING"\     \\     \    \     \      \        \      ";"Item";"Number";"each";"Amount"
205 FORK=LTO(N*X)
210 PRINTUSING" ##    ####    $$###.##   $$#####,.##";H(K),O(K),P(K),R(K)
215 J=J+1
220 NEXTK
225 A=INKEY$:IFA=""THEN225
230 IFLL<YTHEN235ELSE240
235 L=J+1:GOTO195
240 I=(X*N)+1
245 IFI=<MTHEN250ELSE275
250 CLS:PRINTUSING"\     \\     \    \     \      \        \      ";"Item";"Number";"each";"Amount"
255 FORK=ITOM
260 PRINTUSING" ##    ####    $$###.##   $$#####,.##";H(K),O(K),P(K),R(K)
265 NEXTK
270 A=INKEY$:IFA=""THEN270
275 CLS
280 PRINTUSING"\           \ $$#####,.##";"Subtotal  = ",S
285 PRINTUSING"\           \ $$#####,.##";"Discount  = ",V
290 PRINTUSING"\           \ $$#####,.##";"Total     = ";T
295 A=INKEY$:IFA=""THEN295
300 END

