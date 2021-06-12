#!/bin/bash

goal asset create  --assetmetadatab64 "16efaa3924a6fd9d3a4824799a4ac65d"  --asseturl "www.coolade.com" --creator "5CJEIMOPJIKJKSFGIAHNF7NTNUFKZLQQETOWHXEA3AM335B5NQKYHSFVEY" --decimals 0 --defaultfrozen=true --total 1000 --unitname nljh --name myas --out=unsginedtransaction1.tx

goal app create --creator 5CJEIMOPJIKJKSFGIAHNF7NTNUFKZLQQETOWHXEA3AM335B5NQKYHSFVEY --app-arg "int:1000000" --app-arg "int:5" --app-arg "addr:YGCKHAG4H3WDUQSAY5J4MK5ZIWLGIF7W6ZYO5EZY3OGZJB5FWGDNBX7BUA"  --app-arg "addr:IKEPBSW7RSPN4TXYC3AV6FOOGZ6PJLTJKEB2PVCTPSRFNB3CANZ5JJRZPY"  --app-arg "addr:2FSBHE3XAXJHBFFUABPPBBU3ZL4PQAHI6BB3KTHJKL5IZCC7BG4LR6GRT4"  --app-arg "addr:UONII5HLZPHGDCBCETVTFGX42I5MJWEYKM5NUIFQW3A47CSDIHZN74AYUA"  --app-arg "addr:EMMEIOWLZPMUCXSLGB5QOR33HCQZAQT6KSRGCXHBO54W7LNLQCJXSGJ4IQ"  --app-arg "addr:UNH443RNFL4NWFCP5AI3N34C6IK6SWDEPZRLFKXGWYTXBZ5BTLJJLGWLRQ"  --app-arg "addr:QPNWTRS3FLRUICYYLVPQV7QZIJPBNM2EV6S5BF6JOFQL7DGCLU5HKQSUK4"     --approval-prog ../contracts/freeport.teal --global-byteslices 10 --global-ints 3 --local-byteslices 1 --local-ints 1 --clear-prog ../contracts/clear.teal --out=unsginedtransaction2.tx

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