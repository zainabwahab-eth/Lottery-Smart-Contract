## Decentralized Lottery Smart Contract

This is a Solidity-based smart contract for a decentralized lottery system built on Ethereum. The contract allows participants to purchase tickets, generates a random winner, and distributes the prize pool in a secure and decentralized manner.

🔑 Features
- **Lottery State Management:** Manages the lottery's state (Open or Closed) using `enum`.
- **Ticket Purchase:** Participants can buy tickets and choose a number between 0 and `MAX_NUMBER`.
- **Random Winner Selection:** Generates a winning number using a pseudo-random number generator (`keccak256`).
- **Prize Distribution:** Divides the prize pool equally among all winners who guessed the correct number, with funds securely transferred using `call`.
- **Rollover for No Winners:** If no one picks the winning number, the prize pool rolls over to the next round.

