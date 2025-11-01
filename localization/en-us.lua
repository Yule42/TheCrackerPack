return {
    descriptions = {
        Back = {
            b_cracker_golden = {
                name = 'Golden Deck',
                text = {
                    'Start run with',
                    '{C:money,T:v_seed_money}#1#{},',
                    '{C:money,T:v_cracker_silver_spoon}#2#{},',
                    'and {C:dark_edition,T:v_hone}#3#',
                },
            },
            b_cracker_consumer = {
                name = 'Consumer Deck',
                text = {
                    'For every {C:money}$#2#{} {C:inactive}[#3#]',
                    'spent while in the shop,',
                    'get {C:money}$#1#',
                }
            },
            b_cracker_blitz = {
                name = 'Blitz Deck',
                text = {
                    'Win in Ante {C:attention}6',
                    'Required score scales',
                    'faster for each {C:attention}Ante',
                }
            },
            b_cracker_patchwork = {
                name = 'Patchwork Deck',
                text = {
                    '{C:attention}Deck Vouchers{} appear',
                    'instead of {C:attention}Vouchers',
                    '{C:attention}Deck Vouchers{} restock',
                    'every {C:attention}other{} Ante',
                }
            },
            b_cracker_catalog = {
                name = 'Catalog Deck',
                text = {
                    'In shop:',
                    '{C:attention}+1{} Voucher slot',
                    '{C:attention}+1{} Booster Pack slot',
                    '{C:attention}-1{} card slot',
                }
            },
        },
        Joker = {
            j_cracker_saltinecracker = {
                name = 'Saltine Cracker',
                text = {
                    '{C:chips}+#1#{} Chips',
                    'Gains {C:chips}+#2#{} Chips',
                    'after each round',
                    '{S:1.1,C:red,E:2}Self destructs{} after',
                    'reaching {C:chips}#3#{} Chips'
                }
            },
            j_cracker_chocolatecoin = {
                name = 'Chocolate Coin',
                text = {
                    'Earn {C:attention}$#1#{} at',
                    'end of round',
                    'for the next',
                    '{C:attention}#2#{} rounds'
                }
            },
            j_cracker_grahamcracker = {
                name = 'Graham Cracker',
                text = {
                    'This Joker gains {X:mult,C:white} X#1# {} Mult',
                    'every {C:attention}#2#{C:inactive} [#3#]{} scoring cards played',
                    '{S:1.1,C:red,E:2}Self destructs{} after',
                    'reaching {X:mult,C:white} X#5# {} Mult',
                    '{C:inactive}(Currently {X:mult,C:white} X#4#{C:inactive} Mult)',
                }
            },
            j_cracker_thrifty_joker = {
                name = 'Thrifty Joker',
                text = {
                    '{C:red}+#1#{} Mult per {C:voucher}Voucher{}',
                    'purchased this run',
                    '{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)',
                }
            },
            j_cracker_cheese = {
                name = 'Cheese',
                text = {
                    '{X:mult,C:white}X#1#{} Mult, decreases by',
                    '{X:mult,C:white}X#2#{} every hand played',
                    '{s:0.8}resets at end of round',
                }
            },
            j_cracker_crackerbarrel = {
                name = 'Cracker Barrel',
                text = {
                    'When {C:attention}Blind{} is selected,',
                    'create {C:attention}#1# Food Joker',
                    '{C:inactive}({}{C:attention}#2#{}{C:inactive} Food Jokers left)',
                    '{C:inactive}(Must have room)',
                }
            },
            j_cracker_sacramentalkatana = {
                name = 'Sacramental Katana',
                text = {
                    'When {C:attention}Boss Blind{} is defeated,',
                    '{S:1.1,C:red,E:2}sacrifice{} and destroy Joker',
                    'to the right and permanently',
                    'add 1/4 its sell value as {X:mult,C:white} XMult',
                    '{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult)',
                }
            },
            j_cracker_freezer = {
                name = 'Freezer',
                text = {
                    '{C:attention}Food Jokers{}',
                    'and other {C:attention}perishables{}',
                    'are {C:spectral}frozen{}',
                }
            },
            j_cracker_lifesupport = {
                name = 'Life Support',
                text = {
                    'On {C:attention}final hand{} of the round,',
                    'set {C:chips}Chips{} and {C:mult}Mult{} to the higher value',
                    'and lose {C:money}$#1#',
                    '{S:1.1,C:red,E:2}Self destructs{} if cost puts you in debt',
                    '{C:inactive}(Money lost doubles each use)',
                }
            },
            j_cracker_curry = {
                name = 'Curry',
                text = {
                    '{C:red}+#1#{} Mult',
                    'before cards are scored',
                    '{C:red}-#2#{} Mult per round played',
                }
            },
            j_cracker_knifethrower = {
                name = 'Knife Thrower',
                text = {
                    '{C:blue}+#1#{} hand each round',
                }
            },
            j_cracker_northstar = {
                name = 'Northern Star',
                text = {
                    '{C:chips}+#1#{} Chips per',
                    'level from {C:attention}most leveled hand{}',
                    '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
                }
            },
            j_cracker_thedealer = {
                name = 'The Dealer',
                text = {
                    '{C:green}#1# in #2#{} chance',
                    'to retrigger each',
                    '{C:attention}played card',
                }
            },
            j_cracker_bomb = {
                name = 'Bomb Joker',
                text = {
                    '{C:attention}Blows up{} in {C:attention}#1#{} rounds',
                    'Ticks down when {C:attention}Blind{} is selected',
                }
            },
            j_cracker_cybernana = {
                name = 'Cybernana MK920',
                text = {
                    'This Joker gains {X:mult,C:white}X#1#{} Mult',
                    'per round played',
                    '{C:green}#2# in #3#{} chance this card',
                    'is destroyed at end of round',
                    '{C:inactive}(Currently {X:mult,C:white} X#4#{C:inactive} Mult)'
                }
            },
            j_cracker_buttpopcorn = {
                name = 'Buttered Popcorn',
                text = {
                    '{C:mult}+#1#{} Mult',
                    '{C:mult}-#2#{} Mult per round played',
                }
            },
            j_cracker_frozencustard = {
                name = 'Sundae',
                text = {
                    '{C:chips}+#1#{} Chips',
                    '{C:chips}-#2#{} Chips for',
                    'every hand played'
                }
            },
            j_cracker_hardseltzer = {
                name = 'Hard Seltzer',
                text = {
                    'Retrigger all cards played',
                    'for the next {C:attention}#1#{} rounds',
                }
            },
            j_cracker_canofbeans = {
                name = 'Can of Beans',
                text = {
                    '{C:attention}+#3#{} hand size',
                    'for the next',
                    '{C:attention}#1#{} rounds',
                }
            },
            j_cracker_tsukemen = {
                name = 'Tsukemen',
                text = {
                    '{X:mult,C:white} X#1#{} Mult,',
                    'gains {X:mult,C:white} X#2#{} Mult',
                    'per {C:attention}card{} discarded,',
                    'loses {X:mult,C:white} X#3# {} Mult',
                    'after {C:attention}hand is scored{}',
                }
            },
            
            j_cracker_greencard = {
                name = 'Green Card',
                text = {
                    'This Joker gains',
                    '{C:money}$#1#{} of {C:attention}sell value{} when',
                    'a card is {C:attention}purchased',
                }
            },
            j_cracker_bluecard = {
                name = 'Blue Card',
                text = {
                    'This Joker gains {C:chips}+#2#{} Chips',
                    'when a card is taken from a {C:attention}Booster Pack{},',
                    'loses {C:chips}-#3#{} Chips when a card is {C:attention}purchased{}',
                    '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}',
                }
            },
            j_cracker_violetcard = {
                name = 'Violet Card',
                text = {
                    'This Joker gains',
                    '{X:mult,C:white}X#2#{} Mult when any',
                    '{C:attention}Booster Pack{} is skipped',
                    '{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult){}',
                }
            },
            j_cracker_indigocard = {
                name = 'Indigo Card',
                text = {
                    '{C:green}#1# in #2#{} chance to upgrade level of',
                    '{C:attention}most played poker hand',
                    'when {C:attention}Booster Pack{} is skipped',
                }
            },
            j_cracker_pinkcard = {
                name = 'Pink Card',
                text = {
                    'This Joker gains {C:attention}+#1#{} hand size',
                    'when {C:attention}Booster Pack{} is skipped',
                    '{C:inactive}(Currently {C:attention}+#2#{C:inactive} hand size)',
                    '{s:0.8}Resets at end of round',
                }
            },
            j_cracker_orangecard = {
                name = 'Orange Card',
                text = {
                    'When {C:attention}Booster Pack{} is skipped,',
                    'creates a random card',
                    'from {C:attention}type of pack skipped{}',
                    '{C:inactive}(Must have room)',
                }
            },
            j_cracker_yellowcard = {
                name = 'Yellow Card',
                text = {
                    'Earn {C:money}$#1#{} at end of round',
                    'Payout set to {C:money}$#2#{}',
                    'when {C:attention}Blind{} is skipped',
                    'Decreases by {C:money}$#3#{} each payout',
                }
            },
            j_cracker_blackcard = {
                name = 'Black Card',
                text = {
                    'Create a {C:spectral}Negative Tag{} every #2# {C:attention}Booster Packs{} opened,',
                    'resets when {C:attention}Booster Pack{} is skipped',
                    '{C:inactive}(Currently {C:attention}#1#{C:inactive}/#2#){}',
                }
            },
            j_cracker_whitecard = {
                name = 'White Card',
                text = {
                    'Fills {C:attention}empty consumable slots{}',
                    'with {C:tarot}The Fool{} at the end of the {C:attention}shop',
                    'if no {C:attention}Booster Packs{} opened this round',
                }
            },
            j_cracker_rainbowcard = {
                name = 'Rainbow Card',
                text = {
                    'Retrigger all played cards {C:attention}#1#{} times',
                    'if no {C:attention}Booster Packs{} opened in shop',
                    'during this round',
                }
            },
            j_cracker_royaldecree = {
                name = 'Royal Decree',
                text = {
                    'A {C:attention}Straight{} that contains an',
                    '{C:attention}Ace{} and a {C:attention}face card{}',
                    'is a {C:attention}Royal Flush{}',
                }
            },
            j_cracker_snail = {
                name = 'Snail',
                text = {
                    '{C:mult}+#2#{} Mult',
                    'per {C:attention}blind defeated{} with this Joker',
                    '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)',
                }
            },
            j_cracker_prosopagnosia = {
                name = 'Prosopagnosia',
                text = {
                    'This Joker gains {X:mult,C:white}X#2#{} Mult',
                    'when a {C:attention}face{} card is scored,',
                    'face cards are drawn face down',
                    '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)',
                }
            },
            j_cracker_shrimpcocktail = {
                name = 'Shrimp Cocktail',
                text = {
                    '{C:red}+#1#{} discard#3# each round',
                    'This Joker loses {C:red}#2#{} discard',
                    'when more than {C:attention}3{} discards are',
                    'used in a single round'
                }
            },
            j_cracker_hamburger = {
                name = 'Hamburger',
                text = {
                    '{C:blue}+#1#{} hand#3# each round',
                    'This Joker loses {C:blue}#2#{} hand',
                    'every {C:attention}#4# {C:inactive}[#5#]{} cards discarded',
                }
            },
            j_cracker_potatochips = {
                name = 'Potato Chips',
                text = {
                    '{C:blue}+#1#{} Chips',
                    '{C:blue}-#2#{} Chips if {C:attention}first played hand of round',
                    'wins Blind',
                }
            },
            j_cracker_ants = {
                name = 'Ants',
                text = {
                    'This Joker gains',
                    '{X:mult,C:white}X#2#{} Mult when a',
                    '{C:attention}Food Joker{} is destroyed',
                    '{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult){}',
                }
            },
            j_cracker_highroller = {
                name = 'High Roller',
                text = {
                    'Played {C:attention}Lucky Cards{} give',
                    '{X:mult,C:white}X#1#{} Mult when scored,',
                    'increases by {X:mult,C:white}X#2#{} when a',
                    '{C:attention}Lucky Card {C:green}successfully{} triggers',
                    '{C:inactive}(Resets every hand){}',
                }
            },
            j_cracker_thefalcon = {
                name = 'The Falcon',
                text = {
                    '{C:green}#1# in #2#{} chance for',
                    'each discarded card to be destroyed'
                }
            },
            j_cracker_postman = {
                name = 'Postman',
                text = {
                    'This Joker gains',
                    '{C:mult}+#2#{} Mult when a seal is triggered',
                    '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}',
                },
            },
        },
        Voucher = {
            v_cracker_silver_spoon = {
                name = 'Silver Spoon',
                text = {
                    'Earn {C:money}$#1#{}',
                    'at end of round',
                }
            },
            v_cracker_clowncar = {
                name = 'Clown Car',
                text = {
                    '{C:green}Uncommon Jokers{}',
                    'appear more often',
                }
            },
            v_cracker_busfullofclowns = {
                name = 'Bus Full o\' Clowns',
                text = {
                    '{C:red}Rare Jokers{}',
                    'appear more often',
                }
            },
            v_cracker_cheese_touch = {
                name = 'Cheese Touch',
                text = {
                    'Permanently',
                    'gain {C:blue}+#1#{} hand',
                    'per round',
                }
            },
            v_cracker_dumpster = {
                name = 'Dumpster',
                text = {
                    'Permanently',
                    'gain {C:red}+#1#{} discard',
                    'each round',
                }
            },
            v_pw_red = {
                name = "Red Deck",
                text = {
                    'Permanently',
                    'gain {C:red}+#1#{} discard',
                    'each round',
                },
            },
            v_pw_blue = {
                name = "Blue Deck",
                text = {
                    'Permanently',
                    'gain {C:blue}+#1#{} hand',
                    'per round',
                },
            },
            v_pw_yellow = {
                name = "Yellow Deck",
                text = {
                    'Gain {C:money}$#1#',
                },
            },
            v_pw_green = {
                name = "Green Deck",
                text = {
                    "At end of round, earn an additional",
                    "{C:money}$#1#{s:0.85} per remaining {C:blue}Hand,",
                    "and {C:money}$#2#{s:0.85} per remaining {C:red}Discard",
                },
            },
            v_pw_black = {
                name = "Black Deck",
                text = {
                    '{C:attention}+1{} Joker Slot',
                },
            },
            v_pw_magic = {
                name = "Magic Deck",
                text = {
                    "Get {C:tarot,T:v_crystal_ball}#1#{} and {C:attention}2{} copies",
                    "of {C:tarot,T:c_fool}#3#",
                    "{C:inactive}(Gives upgrade if voucher already owned)",
                    "{C:inactive}(Must have room)",
                }
            },
            v_pw_nebula = {
                name = "Nebula Deck",
                text = {
                    "Get {C:planet,T:v_telescope}#1#{}",
                    "{C:inactive}(Gives upgrade if voucher already owned)",
                },
            },
            v_pw_ghost = {
                name = "Ghost Deck",
                text = {
                    "{C:spectral}Spectral{} cards may",
                    "appear in the shop,",
                    "Create {C:spectral,T:c_hex}#1#",
                    "{C:inactive}(Must have room)",
                },
            },
            v_pw_abandoned = {
                name = "Abandoned Deck",
                text = {
                    "Destroy all {C:attention}Face Cards",
                    "in deck",
                },
            },
            v_pw_checkered = {
                name = "Checkered Deck",
                text = {
                    "Convert all {C:clubs}Clubs{} to {C:spades}Spades",
                    "and all {C:diamonds}Diamonds{} to {C:hearts}Hearts",
                },
            },
            v_pw_zodiac = {
                name = "Zodiac Deck",
                text = {
                    "Get {C:tarot,T:v_tarot_merchant}#1#{},",
                    "{C:planet,T:v_planet_merchant}#2#{},",
                    "and {C:attention,T:v_overstock_norm}#3#",
                    "{C:inactive}(Gives upgrade if voucher already owned)",
                },
            },
            v_pw_painted = {
                name = "Painted Deck",
                text = {
                    "{C:attention}+#1#{} Hand Size",
                },
            },
            v_pw_anaglyph = {
                name = "Anaglyph Deck",
                text = {
                    "After defeating each",
                    "{C:attention}Boss Blind{}, gain a",
                    "{C:attention,T:tag_double}#1#",
                },
            },
            v_pw_plasma = {
                name = "Plasma Deck",
                text = {
                    "Balance {C:blue}Chips{} and",
                    "{C:red}Mult{} when calculating",
                    "score for played hand",
                    --"{C:red}X2{} base Blind size",
                },
            },
            v_pw_erratic = {
                name = "Erratic Deck",
                text = {
                    "Get {C:attention}#1#{} random Vouchers",
                },
            },
            v_cracker_pw_golden = {
                name = "Golden Deck",
                text = {
                    "Get {C:money,T:v_seed_money}#1#{},",
                    "{C:money,T:v_cracker_silver_spoon}#2#{},",
                    "and {C:dark_edition,T:v_hone}#3#",
                    "{C:inactive}(Gives upgrade if voucher already owned)",
                },
            },
            v_cracker_pw_consumer = {
                name = 'Consumer Deck',
                text = {
                    'For every {C:money}$#2#{} {C:inactive}[#3#]',
                    'spent while in the shop,',
                    'get {C:money}$#1#',
                },
            },
            v_cracker_pw_blitz = {
                name = "Blitz Deck",
                text = {
                    "{C:attention}-1{} Ante Requirement,",
                    "{C:attention}-1{} Ante",
                },
            },
            v_cracker_pw_catalog = {
                name = 'Catalog Deck',
                text = {
                    'In shop:',
                    '{C:attention}+1{} Voucher slot',
                    '{C:attention}+1{} Booster Pack slot',
                }
            },
        },
        Other = {
            artist_credits_cracker = {
                name = 'Credits',
                text = {
                    '{C:chips}Art:{} #1#',
                    '{C:money}Design:{} #2#',
                }
            },
            patchwork_only = {
                name = 'Deck Voucher',
                text = {
                    'This {C:attention}Voucher',
                    'only appears in {C:attention}Patchwork Deck',
                }
            },
            concept_credits_cracker = {
                name = 'Credits',
                text = {
                    '{C:money}Design:{} #1#',
                }
            },
            d_sacrifice = {
                name = "Sacrificed",
                text = {
                    "This Joker",
                    "cannot appear for",
                    "the rest of the run",
                },
            },
            d_frozen = {
                name = "Frozen",
                text = {
                    "Cannot decay",
                    "or grow",
                }
            },
            d_purchased = {
                name = "Purchased",
                text = {
                    "Bought in shop",
                    "{C:inactive}(excl. cards in",
                    "{C:inactive}Booster Packs){}",
                }
            },
        },
    },
    misc = {
        dictionary = {
            k_inactive="inactive",
            k_inactive_ex="Inactive...",
            k_eaten_crumble="Crumbled!",
            k_eaten_barrel="Emptied!",
            k_bomb_explode='Boom!',
            k_used_lifesupport='Beep!',
            k_maximized='Maximized!',
            k_discard_falcon='Clawed!',
            k_frozen='Frozen!',
            k_open_url='Open URL',
            k_copy_url='Copy URL',
            jdis_before='Before',
        },
        v_dictionary = {
            a_money="+$#1#",
            a_money_minus="-$#1#",
            a_hands_minus="-#1# Hands",
            a_card="+#1# Card",
            a_discards="+#1# Discards",
            a_discards_minus="-#1# Discards",
        },
        v_text = {
            ch_c_ante_39 = {
                "Beat {C:attention}Ante 38{} to win"
            },
            ch_c_plasma = {
                "Balance {C:blue}Chips{} and {C:red}Mult{} when calculating score for played hand",
                
            },
            ch_c_plasma_2 = {
                "{C:red}X2{} base Blind size",
            },
            ch_c_onlyjokers = {
                "Only {C:attention}Jokers{} show up in shop",
            },
            ch_c_spectral_replace_arcana = {
                "{C:spectral}Spectral{} cards replace {C:tarot}Tarot{} cards",
            },
            ch_c_all_perishable = {
                "All Jokers are {C:attention}Perishable",
            },
            ch_c_testing = {
                "This challenge is here for testing and will be {C:attention}removed/changed later{}",
            },
            ch_c_debuff_played_unsealed_cards = {
                "{C:attention}Scored{} cards without a seal become {C:attention}debuffed",
            },
        },
    }
}
