return {
    descriptions = {
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
                ['name'] = 'Graham Cracker',
                ['text'] = {
                    'This Joker gains {X:mult,C:white} X#1# {} Mult',
                    'every {C:attention}#2#{C:inactive} [#3#]{} cards played',
                    '{S:1.1,C:red,E:2}Self destructs{} after',
                    'reaching {X:mult,C:white} X#5# {} Mult',
                    '{C:inactive}(Currently {X:mult,C:white} X#4#{C:inactive} Mult)',
                }
            },
            j_cracker_hoarder = {
                ['name'] = 'Hoarder',
                ['text'] = {
                    '{C:red}+#1#{} Mult per {C:voucher}Voucher{}',
                    'purchased this run',
                    '{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)',
                }
            },
            j_cracker_cheese = {
                ['name'] = 'Cheese',
                ['text'] = {
                    '{X:mult,C:white}X#1#{} Mult, decreases by',
                    '{X:mult,C:white}X#2#{} every hand played',
                    '{s:0.8}resets at end of round',
                }
            },
            j_cracker_crackerbarrel = {
                ['name'] = 'Cracker Barrel',
                ['text'] = {
                    'When {C:attention}Blind{} is selected,',
                    'create {C:attention}#1# Food Joker',
                    '{C:inactive}({}{C:attention}#2#{}{C:inactive} Food Jokers left)',
                    '{C:inactive}(Must have room)',
                }
            },
            j_cracker_sacramentalkatana = {
                ['name'] = 'Sacramental Katana',
                ['text'] = {
                    'When {C:attention}Boss Blind{} is defeated,',
                    '{S:1.1,C:red,E:2}sacrifice{} and destroy Joker',
                    'to the right and permanently',
                    'add 1/4 its sell value as {X:mult,C:white} XMult',
                    '{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult)',
                }
            },
            j_cracker_freezer = {
                ['name'] = 'Freezer',
                ['text'] = {
                    [1] = '{C:attention}Food Jokers{}',
                    [2] = 'and other {C:attention}perishables{}',
                    [3] = 'are {C:spectral}frozen{}',
                }
            },
            j_cracker_lifesupport = {
                ['name'] = 'Life Support',
                ['text'] = {
                    [1] = 'Activates upon Death',
                    [2] = 'When active, {C:inactive}debuffs{} {C:attention}all cards{}',
                    [3] = 'and prevents Death for the next {C:attention}#1#{} rounds',
                    [4] = '{C:inactive}(Skipping reduces rounds)',
                }
            },
            j_cracker_curry = {
                ['name'] = 'Curry',
                ['text'] = {
                    [1] = '{C:red}+#1#{} Mult',
                    [2] = 'before cards are scored',
                    [3] = '{C:red}-#2#{} mult per round played',
                }
            },
            j_cracker_knifethrower = {
                ['name'] = 'Knife Thrower',
                ['text'] = {
                    [1] = '{C:blue}+#1#{} hand each round',
                }
            },
            j_cracker_northstar = {
                ['name'] = 'Northern Star',
                ['text'] = {
                    [1] = '{C:chips}+#1#{} chips per',
                    [2] = 'level from {C:attention}most leveled hand{}',
                    [3] = '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
                }
            },
            j_cracker_thedealer = {
                ['name'] = 'The Dealer',
                ['text'] = {
                    [1] = '{C:green}#1# in #2#{} chance',
                    [2] = 'to retrigger each',
                    [3] = 'scored card',
                }
            },
            j_cracker_bomb = {
                ['name'] = 'Bomb',
                ['text'] = {
                    [1] = '{C:attention}Blows up{} in {C:attention}#1#{} rounds',
                    [2] = 'Ticks down when {C:attention}Blind{} is selected',
                    [3] = '{S:1.1,C:red,E:2}Ends game{} if this Joker hits 0',
                }
            },
        },
        Other = {
            d_sacrifice = {
                name = "Sacrificed",
                text = {
                    "This joker",
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
                    "{C:inactive}(excl. taken from",
                    "{C:inactive}purchased Booster Pack){}",
                }
            },
        },
    },
    misc = {
        dictionary = {
            k_inactive="inactive",
            k_inactive_ex="Inactive",
            k_eaten_crumble="Crumbled!",
            k_eaten_barrel="Emptied!",
            k_bomb_explode='Boom!',
            k_used_lifesupport='Beep!',
        },
        v_dictionary = {
            a_money="+$#1#",
            a_money_minus="-$#1#",
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
            ch_c_bomb = {
                "{C:red}Bomb{} can only appear in this challenge",
            },
            ch_c_testing = {
                "This challenge is here for testing and will be {C:attention}removed/changed later{}",
            },
        },
    }
}