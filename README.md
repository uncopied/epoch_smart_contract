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
int 15994703
==
&&
```

We check for that the rekeyto address of the first three transactions is a zeroadddress so no one can rekey our transaction to use a different clawback address for sending, we check that the closeRemainderTo for the first three transactions is also a zero address and that the AssetCloseTo of the first three transactions should be the zero Address. 
Lastly, we make sure the transaction fee is not more than 10000 micro algos so a malicious party does not try to exhaust our funds by setting a high transaction fee, we make sure this transaction is grouped with at least 9 other transactions, then we make sure the third transaction is an application call transaction and lastly we check if the application id of the third transaction is equal to the application id of our stateful smart contract address, the nos 15994703 should be changed to the application id of the stateful smart contract before this is compiled, a simple find and replace transaction with any programming language should do this fine.

# Transactions Demo
