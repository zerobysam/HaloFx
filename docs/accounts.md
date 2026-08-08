# HaloFX Accounts

Users can manage multiple trading accounts.

## Account

Each account contains:

- ID
- Name
- Broker
- Account type
- Market
- Currency
- Balance
- Equity
- Leverage
- Demo/Live
- Created date

## Features

- Add account
- Edit account
- Delete account
- Select active account
- Switch accounts
- View account balance
- Use account in calculators

## State

Account data is managed through Riverpod.

Local state should update before backend synchronization.

## Future

- Broker integrations
- Automatic balance synchronization
- MT4/MT5 integrations
