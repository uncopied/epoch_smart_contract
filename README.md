# Smart Contract to manage NFTs minted on Algorand By Epoch
This is an explanation of the smart contract for artistic NTFs on Algorand. The NFTs will be traded on the Epoch website based on agreed standards for asset identification and metadata. This contract is meant for Epoch and allows the management of royalties not just on initial NFT transaction but also on all future NFT transactions.


## What Does this Contract Achieve
The purpose of this contract is to enable royalty transactions for Epoch and to also guide the creation of NFTs, for this purpose, the Algorand blockchain and  TEAL(Transaction Execution Approval Language) has been chosen as the desired Blockchain and smart contract language.

## Things to understand before proceeding
- A royalty transaction is a transaction that allows a creator of a content to be rewarded for his content by a buyer of such content, in our case, the content is the NFT.

- NFTs are created as ASA (Algorand Standard Assets) under the Algorand public blockchain.
- Atomic transactions are transactions that are grouped together such that if one fails, all fail.

## How do we achieve this?
We are going to solve this particular problem using an Atomic transaction that contains 10 transactions and another that contains 11 transactions, but first, it is good that you understand that there are two types of royalty transactions in our case :
1. A creator selling his NFT to a buyer.
2. A buyer giving or selling his NFT to a new Buyer

##  A creator selling his NFT to a buyer.
- The first transaction is a transaction sending the NFT to the new Buyer
- The second transaction sends 30% of the sales to Epoch(The address that created the contract).
- The third transaction is an application call transaction that calls the required Application(Stateful Smart Contract)
- The fourth to 10th transaction send  10% of the initial sale to 7 other artists

## A buyer giving or selling his NFT to a new Buyer
- The first transaction sends 30% of 20% of the new sale to  Epoch(Creator of the Contract)
- The second transaction sends 80% of the new sale to the seller of the NFT
- The third transaction makes the application call.
- The fourth transaction sends the NFT to the new buyer 
- The fifth to eleventh transaction sends 10% each of 20% of the new sale to the 7 artists

# Order Of Transactions For A Royalty Transaction To Take Place
1. An atomic transaction that creates an asset with default frozen true and also a stateful smart contract which stores the price of a single unit of the NFT, the address of the sender of the **create application** call  transaction along with the address of the 7 other artists that receive royalties

2. A compilation of a stateless smart contract that includes the application id of the stateful smart contract, will give us an address.

3. Funding the stateless smart contract address.
4. Performing an asset configuration transaction of the created asset to make the clawback address be the stateless smart contract address
5. Performing an opt-in transaction to opt the buyer of the NFT(asset) into the asset
6. An atomic transaction groups the 10 or 11 transactions described earlier together in order to have a successful transaction


# Code And Explanation
## Stateful Smart Contract
A stateful smart contract allows us to store certain values on the Algorand blockchain, for our use case, we will be storing the price of the NFT along with the address of the creator and the seven artists. Let's write the TEAL code for this in a file and call it freeport.teal

```TEAL
#pragma version 3
int 0
txn ApplicationID
==
bnz creation
```
the first line defines the version of the Teal programming language we are using. In our case, its version 3, the next three lines load 0 and the current application ID to the stack and compare them, this returns 1 if they are equal and 0 if they are not. Make sure to note that for a stateful smart contract that is just being created, the Application ID is always 0, so, with this, we can always specify the actions we intend to take when our Stateful smart contract is just being created. so the fourth line in the code above uses the bnz(Branch Not Zero) command to jump to a branch in our code called creation if the comparison is not zero(false). And when we call this Teal program for the first time, the comparison of 0 and the application id will definitely not be zero since it is just being created. So let's proceed to create this branch of our code called creation.
```TEAL

creation:
byte "Creator"
txn Sender
app_global_put
byte "Neil"
gtxna 1 ApplicationArgs 2
app_global_put
byte "Sarah"
gtxna 1 ApplicationArgs 3
app_global_put
byte "Alice"
gtxna 1 ApplicationArgs 4
app_global_put
byte "Juan"
gtxna 1 ApplicationArgs 5
app_global_put
byte "Alexandra"
gtxna 1 ApplicationArgs 6
app_global_put
byte "Amanda"
gtxna 1 ApplicationArgs 7 
app_global_put
byte "Hirad"
gtxna 1 ApplicationArgs 8
app_global_put
byte "Price"
gtxna 1 ApplicationArgs 0
btoi
app_global_put

global GroupSize
int 2
>=
gtxn 0 TypeEnum
int acfg
==
&&
gtxn 0 ConfigAssetDefaultFrozen
int 1
==
&&
return
```

We store the address of the Caller of the **Create Application** call transaction, then we  proceed to store the address of the 7 other artists using their names as the key. We also make sure that the asset that is created with this Application has a default frozen of true.

 That's presently all for our Stateful smart contract creation logic, let's look at the rest of our code after the `bnz creation` line earlier:

```TEAL
int UpdateApplication
txn OnCompletion
==
bnz updateApp

```
In the code above, we check if the application is being updated and we send program execution to the updateApp branch, lets take a look at this branch

```TEAL
updateApp:
byte "Creator"
app_global_get
txn Sender
==
return
```
The updateApp branch simply checks if the creator of the contract is the one calling the contract and allows the app(contract) to be updated, if not, it doesn't allow the app to be updated.

Let's proceed with our code after the bnz updateApp Line:

```TEAL
int DeleteApplication
txn OnCompletion
==
bnz DeleteApp
```
In the code above, we check if the application(contract) is being deleted and we send program execution to the DeleteApp branch, lets take a look at this branch

```TEAL
DeleteApp:
byte "Creator"
app_global_get
txn Sender
==
return
```
The DeleteApp branch simply checks if the creator of the contract is the one calling the contract and allows the app(contract) to be deleted, if not, it doesn't allow the app to be deleted.

Let's proceed with our code after the bnz DeleteApp Line:

```
byte "Creator"
app_global_get
gtxn 0 AssetSender
==
bnz txSentFromCreator
```
We simply check if the Person sending the asset is the creator of the asset and then send him to the `txSentFromCreator` branch as this is how we know if this is an initial transaction of that NFT or a secondary transaction.

Lets check the code in this branch out:

```TEAL
txSentFromCreator:
global GroupSize
int 10
==
gtxn 0 AssetAmount
int 1 
==
&&
gtxn 1 Receiver
gtxn 0 AssetSender
==
&&
byte "Neil"
app_global_get
gtxn 3 Receiver
==
&&
byte "Sarah"
app_global_get
gtxn 4 Receiver
==
&&
byte "Alice"
app_global_get
gtxn 5 Receiver
==
&&
byte "Juan"
app_global_get
gtxn 6 Receiver
==
&&
byte "Alexandra"
app_global_get
gtxn 7 Receiver
==
&&
byte "Amanda"
app_global_get
gtxn 8 Receiver
==
&&
byte "Hirad"
app_global_get
gtxn 9 Receiver
==
&&
gtxn 3 Amount
gtxn 4 Amount
+
gtxn 5 Amount
+
gtxn 6 Amount
+
gtxn 7 Amount
+
gtxn 8 Amount
+
gtxn 9 Amount
+
gtxn 1 Amount
+
store 10
gtxn 3 Amount
int 100
*
load 10
/
int 10
==
&&
gtxn 4 Amount
int 100
*
load 10
/
int 10
==
&&
gtxn 5 Amount
int 100
*
load 10
/
int 10
==
&&
gtxn 6 Amount
int 100
*
load 10
/
int 10
==
&&
gtxn 7 Amount
int 100
*
load 10
/
int 10
==
&&
gtxn 8 Amount
int 100
*
load 10
/
int 10
==
&&
gtxn 9 Amount
int 100
*
load 10
/
int 10
==
&&
gtxn 1 Amount
int 100
*
load 10
/
int 30
==
&&
byte "Price"
app_global_get
load 10
==
&&
return
```


In the code above we make several checks in the following order:

- We  check that there are exactly 10 transactions.
- We check that it is only 1 unit of this asset that is sent.
- We check that the Receiver of the 30% Royalty in the second transaction is equal to the AssetSender.
- We then Check that transactions 4 to 10 contain the right receivers which are the seven artists.
- We add up all the amounts in  every transaction together then save it in a scratchpad
- We confirm that the amount transferred in transaction 4 to 10 is 10% of the total amount in all transactions.
- We check that the Amount in transaction 2 sent to the Creator of the Application is equal to 30% of the total amounts in all transactions.
- We check that the total amounts in all transaction is equal to the price set by the creator

And finally we return.


So let's proceed to the lines after our `bnz txSentFromCreator` line:
Do note that this is the line of code that executes if its a secondary sale
```
global GroupSize
int 11
==
gtxn 3 AssetAmount
int 1 
==
&&
byte "Creator"
app_global_get
gtxn 0 Receiver
==
&&
byte "Neil"
app_global_get
gtxn 4 Receiver
==
&&
byte "Sarah"
app_global_get
gtxn 5 Receiver
==
&&
byte "Alice"
app_global_get
gtxn 6 Receiver
==
&&
byte "Juan"
app_global_get
gtxn 7 Receiver
==
&&
byte "Alexandra"
app_global_get
gtxn 8 Receiver
==
&&
byte "Amanda"
app_global_get
gtxn 9 Receiver
==
&&
byte "Hirad"
app_global_get
gtxn 10 Receiver
==
&&
gtxn 4 Amount
gtxn 5 Amount
+
gtxn 6 Amount
+
gtxn 7 Amount
+
gtxn 8 Amount
+
gtxn 9 Amount
+
gtxn 10 Amount
+
gtxn 1 Amount
+
gtxn 0 Amount
+
store 11
load 11
int 20
*
int 100
/
store 12
gtxn 0 Amount
int 100
*
load 12
/
int 30
==
&&
gtxn 4 Amount
int 100
*
load 12
/
int 10
==
&&
gtxn 5 Amount
int 100
*
load 12
/
int 10
==
&&
gtxn 6 Amount
int 100
*
load 12
/
int 10
==
&&
gtxn 7 Amount
int 100
*
load 12
/
int 10
==
&&
gtxn 8 Amount
int 100
*
load 12
/
int 10
==
&&
gtxn 9 Amount
int 100
*
load 12
/
int 10
==
&&
gtxn 10 Amount
int 100
*
load 12
/
int 10
==
&&
return

```
We make the following checks for secondary sales in the code above:

- We check that there at exactly 11 transactions
- We check that the asset amount transferred in the fourth transaction is equal to 1
- We make sure that the Creator of the application is the receiver of the 30% of 20% of the new sale in the first transaction.
- We make sure that the receivers in transaction 5 to 11 are equal to the address of the 7 artists we saved earlier.
- We add up all the amounts in all the transactions and store it to the scratch space
- We store 20 % of the total amount in all transactions to the scratchspace
- We check that the amount sent in the first transaction to the creator is equal to 30% of the 20% the total transaction
- We check that the amount sent in transaction 5 to 11 is equal to 10% of the 20% of the total transaction.

# Stateless Smart Contract
Let's create a file and call it Epoch.teal, this file will house our stateless smart contract which when compiled will be used as our clawback address, let's look at the code for this file
```TEAL
#pragma version 3
gtxn 0 RekeyTo
global ZeroAddress
==
gtxn 1 RekeyTo
global ZeroAddress
==
&&
gtxn 2 RekeyTo
global ZeroAddress
==
&&
gtxn 0 CloseRemainderTo
global ZeroAddress
==
&& 
gtxn 1 CloseRemainderTo
global ZeroAddress
==
&& 
gtxn 2 CloseRemainderTo
global ZeroAddress
==
&& 
gtxn 0 AssetCloseTo
global ZeroAddress
==
&&
gtxn 1 AssetCloseTo
global ZeroAddress
==
&&
gtxn 2 AssetCloseTo
global ZeroAddress
==
&&
txn Fee
int 10000
<=
&&
global GroupSize
int 10
>=
&&
gtxn 2 TypeEnum
int appl
==
&&
gtxn 2 ApplicationID
int 16016196
==
&&
```

We check for that the rekeyto address of the first three transactions is a zeroadddress so no one can rekey our transaction to use a different clawback address for sending, we check that the closeRemainderTo for the first three transactions is also a zero address and that the AssetCloseTo of the first three transactions should be the zero Address. 
Lastly, we make sure the transaction fee is not more than 10000 micro algos so a malicious party does not try to exhaust our funds by setting a high transaction fee, we make sure this transaction is grouped with at least 9 other transactions, then we make sure the third transaction is an application call transaction and lastly we check if the application id of the third transaction is equal to the application id of our stateful smart contract address, the nos 16016196 should be changed to the application id of the stateful smart contract before this is compiled, a simple find and replace transaction with any programming language should do this fine.

# Transactions Demo
So now, let's try to run through the order of transactions above using the goal command-line tool.
1. An atomic transaction that creates an asset with default frozen true and also a stateful smart contract which stores the price of a single unit of the NFT, the address of the sender of the **create application** call  transaction along with the address of the 7 other artists that receive royalties:

```bash
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
```
When i run the commands above on my PC presently, the atomic transaction is successful with the following transaction IDs VMWUIQ22RI2MA5R4F7DQUBPSERWQVPBMVKHXX2PEJLUFOCN2RE7A,Y2TJZZ2HZOXTJ23S6SSHZYXYJQTCJL6IBHXAXTEYIB5KTZFBQNEA

When i inspect both of them on testnet.algoexplorer.io, I find out the following information

Asset Id: 16016195

Application Id : 16016196

2. A compilation of a stateless smart contract that includes the application id of the stateful smart contract, will give us an address.
```bash
goal clerk compile ../contracts/epoch.teal
```
when I run the command above, I get XA5WEWCKTSR246S7I566J7NLGSBH24QUUAWYOSMBBZOI2DQDFHUB2GO2RU as the address.

3. Funding the stateless smart contract address you can fund the address on https://bank.testnet.algorand.network/

4. Performing an asset configuration transaction of the created asset to make the clawback address be the stateless smart contract address

```bash
goal asset config --manager 6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA  --new-clawback  XA5WEWCKTSR246S7I566J7NLGSBH24QUUAWYOSMBBZOI2DQDFHUB2GO2RU --assetid 16016195      
```
When I do this, I get a successful transaction with a transaction id of XSXQCK6DO2XGZ6Z4FZS2L6NAYOELCVSY2LJTEB4UZIYOHGWWGU7A, feel free to inspect this id on https://testnet.algoexplorer.io/


5. Performing an opt-in transaction to opt the buyer of the NFT(asset) into the asset. Next, we need to opt-in the account of the buyer so he can receive the NFTs.
```bash
goal asset send -a 0 -f XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY -t XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY   --assetid 16016195   
```
After running this, I get a transaction with the following id AEFUJKO4JWQF5XOMQOHO4YB6RBV2OO32YXRWRTY6IPKDTVIEPCPA, feel free to inspect this id on https://testnet.algoexplorer.io/

6. An atomic transaction groups the 10 or 11 transactions described earlier together in order to have a successful transaction

```bash
goal asset send --amount 1 --assetid 16016195       --from 6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA --to XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --clawback  XA5WEWCKTSR246S7I566J7NLGSBH24QUUAWYOSMBBZOI2DQDFHUB2GO2RU  --out unsignedAssetSend.tx

goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to 6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA --amount 300000 --out unsignedSend.tx

goal app call --from 6OQQDT3FI2FY4TY6XFW7I7QFTSTQWH2TP3AF5U3W42TR6SMQPXEJX7TZAA --app-id 16016196 --out unsignedFreeportCall.tx

goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to BN5DMMUOAJCR4SZUGPK3ICQFZ3JXSS24GWDY2B6P56K2SH4EADO6XN56GQ --amount 100000 --out unsignedSend0.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to DG5UXOMPCEPT2SKQ4UJMRNEYDCOABYM3EFR4UW6E3OXF2ME2LF5APS5KLA --amount 100000 --out unsignedSend1.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to DQIEID66TVX55BYECL7UUPIB2OE5ZQGNMFDLE7HRQDNGLTG3UXRBBXOWF4 --amount 100000 --out unsignedSend2.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to EJKLHQS5GRXAKEY2U62YIFBSZPMVTDPL6EQD7XKNN7A33Z7XSYPUCMOODQ --amount 100000 --out unsignedSend3.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to F5N2DN7KIX5EL646GMGV4AQVZHGQJBEIFJR3FEIDVAZP7RGUTBU7LGRRO4 --amount 100000 --out unsignedSend4.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to JYURMSAFWF3BFC6ZJ2WXNQFHBKZONXSVLB6GIH3EH4ZA7Y4PPITDZYVDXU --amount 100000 --out unsignedSend5.tx
goal clerk send --from XHFRWIODL7MFJNCWURZY6USPIWUZTQ2X6EWCJ7SWSRKJPUN4LYHO5XK2BY --to VEKJYW4IIOKGVBI67S5VDQB7ZOHPGJPLRXMI2GG53BAYTB6MZA27S4ALQA --amount 100000 --out unsignedSend6.tx



cat  unsignedAssetSend.tx unsignedSend.tx unsignedFreeportCall.tx  unsignedSend0.tx unsignedSend1.tx unsignedSend2.tx unsignedSend3.tx unsignedSend4.tx unsignedSend5.tx unsignedSend6.tx > combinedNftTransactions.tx


goal clerk group -i combinedNftTransactions.tx -o groupedNftTransactions.tx 

goal clerk split -i groupedNftTransactions.tx -o splitNft.tx

goal clerk sign -i splitNft-0.tx --program ../contracts/epoch.teal -o signoutNft-0.tx

goal clerk sign -i splitNft-1.tx -o signoutNft-1.tx

goal clerk sign -i splitNft-2.tx -o signoutNft-2.tx

goal clerk sign -i splitNft-3.tx -o signoutNft-3.tx

goal clerk sign -i splitNft-4.tx -o signoutNft-4.tx

goal clerk sign -i splitNft-5.tx -o signoutNft-5.tx

goal clerk sign -i splitNft-6.tx -o signoutNft-6.tx

goal clerk sign -i splitNft-7.tx -o signoutNft-7.tx

goal clerk sign -i splitNft-8.tx -o signoutNft-8.tx

goal clerk sign -i splitNft-9.tx -o signoutNft-9.tx

cat signoutNft-0.tx signoutNft-1.tx signoutNft-2.tx signoutNft-3.tx signoutNft-4.tx signoutNft-5.tx signoutNft-6.tx signoutNft-7.tx signoutNft-8.tx signoutNft-9.tx > signoutNft.tx

goal clerk rawsend -f signoutNft.tx
```
After doing this, I get 10 successful transactions with ids, `QU4NRMWV5UDOFDRDUB2BGBNGBOEZ3VSOHFV5EHCOQVZKCJ2VNPRA` `2XKCJONXX3LTZTG4BLZH5AOY2OX2M3R2T76VN6CCE2H6RN26AJUQ` `G3IFYCRNYO6O3QTN5FO4EI52QQBRXFK36OXZFEUYRKIWCJR65DKQ` `J5XLEQOJWU3447A34NYWPPSTC4DWLKFPH6M6UIPMITHUU66Y4GOA` `VZOCEAIN3AO7EQXCQV5RFFKHYAMMVNDRNNUIOIRF4EDSAIVFACGA` `D3MSHP2Y3WRWKFGIL76TKRSB52425BNXZWYOPY7TZ6LJP4NQGTYQ` `JFXEM5SN2MQOMIM5GIESQLR7HXYJFH5Z5EEMD34P75ZBFLKMLTQA` `UBVUMQ5B6NDHP6HASBAFXT4PX4ORITTPJSSTZMOHCFC2PRP7PVQQ` `OBSQRB4AYW6OVARYSFA2X7K4WPMGGUGQ5QOLBOVF3PTK44OQRRSA` `FEYHLSAW6SSE5SWMISFGY425TLQOQXRQIWCN6WRXUSXT4UB5F2AA`

Meaning our transactions were successful.

Up next is the second type of royalty transaction, where someone who has already bought the NFT sends it to a new buyer:

The first step here is to opt the new user into the nft:
```bash
goal asset send -a 0 -f WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY -t WOOWCYJU4DV3LY4BFTRVIF3B3XRQF67YXBM64VC3NJN3OY35C4APYBW6EY   --assetid 16016195   
```

 get a successful transaction with the transaction id : NEN4XBZH4TWXNODPKKMBSF3GNDJS3MES3Q54MPX63OLA3IUC5RFA

Then we can send the new buyer the NFT while also sending the percent of the amount transferred to the Creator and the other seven artists :

```bash
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
```

In the example above 1 unit of our NFT is resold for 2 algo, meaning our Creator gets  0.12 algo(30% of 20% of 2 algo), we send 0.04(10% 0f 20% of 2 algo) algo to our remaining artists, we send 1.6 algo(80% of 2 algo) to the previous buyer.


Meaning our transactions were successful and our contracts work as expected.

