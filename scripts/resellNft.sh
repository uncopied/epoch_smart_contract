#!/bin/bash

# 30% OF 20% payment
goal clerk send --from WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY --to 6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA  --amount 120000 --out unsignedSendA.tx
# Payment from new buyer to previous buyer
goal clerk send --from WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY --to XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --amount 1600000 --out unsignedSend.tx
# App Call Transaction
goal app call --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --app-id 16016196 --out unsignedFreeportCall.tx
# Asset send transaction
goal asset send --amount 1 --assetid 16016195       --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY --clawback  XA5WEWCKTSR246S7I566J7NLGSBH24QUUAWYOSMBBZOI2DQDFHUB2GO2RU  --out unsignedAssetSend.tx

goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to BN5DMMUOAJCR4SZUGPK3ICQFZ3JXSS24GWDY2B6P56K2SH4EADO6XN56GQ --amount 40000 --out unsignedSend0.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to DG5UXOMPCEPT2SKQ4UJMRNEYDCOABYM3EFR4UW6E3OXF2ME2LF5APS5KLA --amount 40000 --out unsignedSend1.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to DQIEID66TVX55BYECL7UUPIB2OE5ZQGNMFDLE7HRQDNGLTG3UXRBBXOWF4 --amount 40000 --out unsignedSend2.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to EJKLHQS5GRXAKEY2U62YIFBSZPMVTDPL6EQD7XKNN7A33Z7XSYPUCMOODQ --amount 40000 --out unsignedSend3.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to F5N2DN7KIX5EL646GMGV4AQVZHGQJBEIFJR3FEIDVAZP7RGUTBU7LGRRO4 --amount 40000 --out unsignedSend4.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to JYURMSAFWF3BFC6ZJ2WXNQFHBKZONXSVLB6GIH3EH4ZA7Y4PPITDZYVDXU --amount 40000 --out unsignedSend5.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to VEKJYW4IIOKGVBI67S5VDQB7ZOHPGJPLRXMI2GG53BAYTB6MZA27S4ALQA --amount 40000 --out unsignedSend6.tx




cat unsignedSendA.tx  unsignedSend.tx unsignedFreeportCall.tx  unsignedAssetSend.tx    unsignedSend0.tx unsignedSend1.tx unsignedSend2.tx unsignedSend3.tx unsignedSend4.tx unsignedSend5.tx unsignedSend6.tx > combinedNftTransactions.tx


goal clerk group -i combinedNftTransactions.tx -o groupedNftTransactions.tx 

goal clerk split -i groupedNftTransactions.tx -o splitNft.tx

goal clerk sign -i splitNft-0.tx -o signoutNft-0.tx

goal clerk sign -i splitNft-3.tx --program ../contracts/epoch.teal -o signoutNft-3.tx

goal clerk sign -i splitNft-1.tx -o signoutNft-1.tx

goal clerk sign -i splitNft-2.tx -o signoutNft-2.tx

goal clerk sign -i splitNft-4.tx -o signoutNft-4.tx

goal clerk sign -i splitNft-5.tx -o signoutNft-5.tx

goal clerk sign -i splitNft-6.tx -o signoutNft-6.tx

goal clerk sign -i splitNft-7.tx -o signoutNft-7.tx

goal clerk sign -i splitNft-8.tx -o signoutNft-8.tx

goal clerk sign -i splitNft-9.tx -o signoutNft-9.tx

goal clerk sign -i splitNft-10.tx -o signoutNft-10.tx

cat signoutNft-0.tx signoutNft-1.tx signoutNft-2.tx signoutNft-3.tx signoutNft-4.tx signoutNft-5.tx signoutNft-6.tx signoutNft-7.tx signoutNft-8.tx signoutNft-9.tx signoutNft-10.tx  > signoutNft.tx

goal clerk rawsend -f signoutNft.tx

# goal clerk dryrun --dryrun-dump --txfile signoutNft.tx --outfile createAssetDryDump.json
# tealdbg debug ../contracts/freeport.teal --dryrun-req  ./createAssetDryDump.json