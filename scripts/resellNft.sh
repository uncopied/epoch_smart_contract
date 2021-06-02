#!/bin/bash

# 305 OF 20% payment
goal clerk send --from WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY --to 6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA  --amount 600000 --out unsignedSendA.tx
# Payment from new buyer to previous buyer
goal clerk send --from WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY --to XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --amount 8000000 --out unsignedSend.tx
# App Call Transaction
goal app call --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --app-id 15994703 --out unsignedPriceCall.tx
# Asset send transaction
goal asset send --amount 1 --assetid 15994702      --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY --clawback  PF4EFRLGWLL6DVZUM6QSJNQSVUL52NPE4NU5D4RHD6CLOMDBE2QT5YK2NE  --out unsignedAssetSend.tx

goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to GJ2KFYI723EMIS76SNSG3TKHDSW7322AZZJXJNV3J35B4TIQVXFXJLB3PI --amount 200000 --out unsignedSend0.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to GJ2KFYI723EMIS76SNSG3TKHDSW7322AZZJXJNV3J35B4TIQVXFXJLB3PI --amount 200000 --out unsignedSend1.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to GJ2KFYI723EMIS76SNSG3TKHDSW7322AZZJXJNV3J35B4TIQVXFXJLB3PI --amount 200000 --out unsignedSend2.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to GJ2KFYI723EMIS76SNSG3TKHDSW7322AZZJXJNV3J35B4TIQVXFXJLB3PI --amount 200000 --out unsignedSend3.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to GJ2KFYI723EMIS76SNSG3TKHDSW7322AZZJXJNV3J35B4TIQVXFXJLB3PI --amount 200000 --out unsignedSend4.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to GJ2KFYI723EMIS76SNSG3TKHDSW7322AZZJXJNV3J35B4TIQVXFXJLB3PI --amount 200000 --out unsignedSend5.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to GJ2KFYI723EMIS76SNSG3TKHDSW7322AZZJXJNV3J35B4TIQVXFXJLB3PI --amount 200000 --out unsignedSend6.tx



cat unsignedSendA.tx  unsignedSend.tx unsignedPriceCall.tx  unsignedAssetSend.tx    unsignedSend0.tx unsignedSend1.tx unsignedSend2.tx unsignedSend3.tx unsignedSend4.tx unsignedSend5.tx unsignedSend6.tx > combinedNftTransactions.tx


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