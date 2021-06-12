#!/bin/bash

goal asset send --amount 1 --assetid 16062688       --from 5CJEIMOPJIKJKSFGIAHNF7NTNUFKZLQQETOWHXEA3AM335B5NQKYHSFVEY --to YI5FXEUEQCFTE7ZAXIM6RSXRE63EAAXVUK2XNYAQVOF4YQXYVSGZNEX4LI --clawback  L5FF6H3PGS6ESQKLM3NM27JS4GYIZMEDG6ZS46WDDIF64MKVIJTZYUETQA  --out unsignedAssetSend.tx

goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to 5CJEIMOPJIKJKSFGIAHNF7NTNUFKZLQQETOWHXEA3AM335B5NQKYHSFVEY --amount 0 --out unsignedSend.tx

goal app call --from 5CJEIMOPJIKJKSFGIAHNF7NTNUFKZLQQETOWHXEA3AM335B5NQKYHSFVEY --app-id 16062689 --out unsignedFreeportCall.tx

# goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to YI5FXEUEQCFTE7ZAXIM6RSXRE63EAAXVUK2XNYAQVOF4YQXYVSGZNEX4LI --amount 100000 --out unsignedSend0.tx
# goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to IKEPBSW7RSPN4TXYC3AV6FOOGZ6PJLTJKEB2PVCTPSRFNB3CANZ5JJRZPY --amount 100000 --out unsignedSend1.tx
# goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to 2FSBHE3XAXJHBFFUABPPBBU3ZL4PQAHI6BB3KTHJKL5IZCC7BG4LR6GRT4 --amount 100000 --out unsignedSend2.tx
# goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to UONII5HLZPHGDCBCETVTFGX42I5MJWEYKM5NUIFQW3A47CSDIHZN74AYUA --amount 100000 --out unsignedSend3.tx
# goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to EMMEIOWLZPMUCXSLGB5QOR33HCQZAQT6KSRGCXHBO54W7LNLQCJXSGJ4IQ --amount 100000 --out unsignedSend4.tx
# goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to UNH443RNFL4NWFCP5AI3N34C6IK6SWDEPZRLFKXGWYTXBZ5BTLJJLGWLRQ --amount 100000 --out unsignedSend5.tx
# goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to QPNWTRS3FLRUICYYLVPQV7QZIJPBNM2EV6S5BF6JOFQL7DGCLU5HKQSUK4 --amount 100000 --out unsignedSend6.tx



cat  unsignedAssetSend.tx unsignedSend.tx unsignedFreeportCall.tx  > combinedNftTransactions.tx # unsignedSend0.tx unsignedSend1.tx unsignedSend2.tx unsignedSend3.tx unsignedSend4.tx unsignedSend5.tx unsignedSend6.tx > combinedNftTransactions.tx


goal clerk group -i combinedNftTransactions.tx -o groupedNftTransactions.tx 

goal clerk split -i groupedNftTransactions.tx -o splitNft.tx

goal clerk sign -i splitNft-0.tx --program ../contracts/epoch.teal -o signoutNft-0.tx

goal clerk sign -i splitNft-1.tx -o signoutNft-1.tx

goal clerk sign -i splitNft-2.tx -o signoutNft-2.tx

# goal clerk sign -i splitNft-3.tx -o signoutNft-3.tx

# goal clerk sign -i splitNft-4.tx -o signoutNft-4.tx

# goal clerk sign -i splitNft-5.tx -o signoutNft-5.tx

# goal clerk sign -i splitNft-6.tx -o signoutNft-6.tx

# goal clerk sign -i splitNft-7.tx -o signoutNft-7.tx

# goal clerk sign -i splitNft-8.tx -o signoutNft-8.tx

# goal clerk sign -i splitNft-9.tx -o signoutNft-9.tx

cat signoutNft-0.tx signoutNft-1.tx signoutNft-2.tx > signoutNft.tx # signoutNft-3.tx signoutNft-4.tx signoutNft-5.tx signoutNft-6.tx signoutNft-7.tx signoutNft-8.tx signoutNft-9.tx > signoutNft.tx

goal clerk rawsend -f signoutNft.tx

# goal clerk dryrun --dryrun-dump --txfile signoutNft.tx --outfile createAssetDryDump.json
# tealdbg debug ../contracts/freeport.teal --dryrun-req  ./createAssetDryDump.json