## v0.1.1.1
### Additions
#### Jokers
- Painter (Common): *+10 Mult per hand size above 7*
- Tax Collector (Common): *Played cards that are not part of the poker hand give half of their Chips as Mult*
### Fixes
- Fixed Spider accidentally drawing cards when a Straight Flush isn't in hand.
- Fixed an accidental debug print.
- Fixed copying The Falcon possibly resulting in multiple destroyed messages on the same card.
- Fixed copying Goodie Bag resulting in messages being shown on the bag itself and not the copier.

## v0.1.1.0
### Additions
#### Jokers
- Knight (Common): *All face cards score*
- U.F.O. (Uncommon): *Every 3 hands, decrease level of played poker hand and add 3X the lost Mult to this Joker*
- Sailor (Common): *Retrigger every third used planet*
- Spider (Uncommon): *If played hand contains a Straight Flush, immediately draw 13 cards*
- Circuit Board (Rare): *Copy the Joker in slot N, slot set on appearence*
### Changes
#### Jokers
- Card Binder rework: Now gives +4 Mult for every Joker activated this run. Previously gave +20 Mult for every 9 enhanced cards in the full deck.
- High Roller now gains X0.25 Mult for each Lucky Card trigger instead of X0.5.
- Darkroom is now Blueprint compatible.
- Freezer is now Perishable compatible.
### Fixes
- Fixed Patchwork Deck not having a proper Solar Deck Voucher
- Fixed Gift Tag being able to give a Voucher that is already in shop.
- Loan Tag should only be able to appear through "Skip Blind", so other mods that adds random tag generation will not have it appear.

## v0.1.0.8
### Changes
#### Jokers
- Snail rework: Gains +8 Mult when big blind is selected, previously gained +2 Mult at end of round
- Thrifty Joker is now Uncommon instead of Common and gives +10 Mult per voucher instead of +6 Mult per voucher
- Decreased Tsukemen to 20 cards instead of 25 cards
#### Tags
- Gift Tag now redeems immediately instead of adding to shop
- Wheel Tag now shows what edition it will add, and has equal odds for each edition
- Increased Crystal Tag to $2 per tarot instead of $1
- Increased Rocket Tag to $3 per planet instead of $1
### Fixes
- Fixed Cracker Barrel on latest SMODS
- Fixed various localization issues

## v1.0.7
### Changes
#### Jokers
- Changed Tsukemen: Now only works for 25 cards discarded instead of 30, applies +5 Mult instead of +3
### Fixes
- Fixed some localizations
