#!/bin/bash

goal asset create  --assetmetadatab64 "16efaa3924a6fd9d3a4824799a4ac65d"  --asseturl "www.coolade.com" --creator "6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA" --decimals 0 --defaultfrozen=true --total 1000 --unitname nljh --name myas --out=unsginedtransaction1.tx

goal app create --creator 6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA --app-arg "int:1000000" --app-arg "int:5" --app-arg "addr:BN5DMMUOAJCR4SZUGPK3ICQFZ3JXSS24GWDY2B6P56K2SH4EADO6XN56GQ"  --app-arg "addr:DG5UXOMPCEPT2SKQ4UJMRNEYDCOABYM3EFR4UW6E3OXF2ME2LF5APS5KLA"  --app-arg "addr:DQIEID66TVX55BYECL7UUPIB2OE5ZQGNMFDLE7HRQDNGLTG3UXRBBXOWF4"  --app-arg "addr:EJKLHQS5GRXAKEY2U62YIFBSZPMVTDPL6EQD7XKNN7A33Z7XSYPUCMOODQ"  --app-arg "addr:F5N2DN7KIX5EL646GMGV4AQVZHGQJBEIFJR3FEIDVAZP7RGUTBU7LGRRO4"  --app-arg "addr:JYURMSAFWF3BFC6ZJ2WXNQFHBKZONXSVLB6GIH3EH4ZA7Y4PPITDZYVDXU"  --app-arg "addr:VEKJYW4IIOKGVBI67S5VDQB7ZOHPGJPLRXMI2GG53BAYTB6MZA27S4ALQA"     --approval-prog ../contracts/freeport.teal --global-byteslices 10 --global-ints 2 --local-byteslices 1 --local-ints 1 --clear-prog ../contracts/clear.teal --out=unsginedtransaction2.tx

# group both transactions
cat unsginedtransaction1.tx unsginedtransaction2.tx  > combinedtransactions.tx

goal clerk group -i combinedtransactions.tx -o groupedtransactions.tx 

goal clerk split -i groupedtransactions.tx -o split.tx 

goal clerk sign -i split-0.tx -o signout-0.tx

goal clerk sign -i split-1.tx -o signout-1.tx

cat signout-0.tx signout-1.tx  > signout.tx

goal clerk rawsend -f signout.tx



# VMWUIQ22RI2MA5R4F7DQUBPSERWQVPBMVKHXX2PEJLUFOCN2RE7A
# Y2TJZZ2HZOXTJ23S6SSHZYXYJQTCJL6IBHXAXTEYIB5KTZFBQNEA