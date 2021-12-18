 17  3  4  0 
0 0 0 "Item"
0 1 0 "Pct by wt"
0 2 0 "  Cost/lb"
0 3 0 " Cost/can"
1 0 0 "Peanuts"
1 1 1 60
1 2 4 .338
1 3 -4 "+B1*C1/100"
2 0 0 "Pecans"
2 1 1 10
2 2 4 1.850
2 3 -4 "+B2*C2/100"
3 0 0 "Cashews"
3 1 1 5
3 2 4 2.437
3 3 -4 "+B3*C3/100"
4 0 0 "Almonds"
4 1 -1 "(100-B1-B2-B3)*@<=((B1+B2+B3),100)"
4 2 4 1.024
4 3 -4 "+B4*C4/100"
5 0 0 "TOTAL"
5 1 -1 "@SUM(B1,B4)"
5 3 -4 "@SUM(D1,D4)*@=(B5,100)"
7 0 0 "Penurious"
7 1 0 " Mixed Nu"
7 2 0 "ts - 1 po"
7 3 0 "und cans"
9 0 0 "Packaging"
9 1 0 " cost per"
9 2 0 " can"
9 3 4 .093
10 0 0 "Cans per"
10 1 0 "case"
10 3 1 24
11 0 0 "Wholesale"
11 1 0 " price pe"
11 2 0 "r case"
11 3 3 22.98
12 0 0 "Total cas"
12 1 0 "es sold p"
12 2 0 "er month"
12 3 1 10000
14 0 0 "Sales"
14 2 0 "        $"
14 3 -1 "+D11*D12*@>(D5,0)"
15 0 0 "Cost of G"
15 1 0 "oods Sold"
15 3 -1 "(D5+D9)*D10*D12*@>(D5,0)"
16 0 0 "Fixed G &"
16 1 0 " A Expens"
16 2 0 "es"
16 3 1 15000
17 0 0 "Net Profi"
17 1 0 "t"
17 2 0 "        $"
17 3 -1 "+D14-D15-D16"
-1 -1 0 END
