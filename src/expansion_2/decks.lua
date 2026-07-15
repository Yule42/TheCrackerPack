SMODS.Back{ -- Golden Deck
    key = "golden",
    
    pos = {
        x = 0,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    config = {
        requirement = 2,
        current_amount = 2,
    },
    unlocked = false,
    locked_loc_vars = function(self, info_queue, back)
        return {
            vars = {
                localize { type = 'name_text', set = 'Stake', key = 'stake_gold' },
                colours = { get_stake_col(8) }
            }
        }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win_stake' and get_deck_win_stake() >= 8
    end,
    loc_vars = function(self, info_queue, center)
        key = "b_cracker_golden"
        if not G.GAME.selected_back.effect.config.requirement then -- figure out a way to make this work while still playing the deck
            key = key.."_collection"
        end
        return {vars = {G.GAME.selected_back.name == 'b_cracker_golden' and G.GAME.selected_back.effect.config.requirement or self.config.requirement, G.GAME.selected_back.name == 'b_cracker_golden' and G.GAME.selected_back.effect.config.current_amount or self.config.current_amount}, key = key}
    end,
    calculate = function(self, back, context)
        if context.skip_blind then
            back.effect.config.current_amount = back.effect.config.current_amount - 1
            if back.effect.config.current_amount <= 0 then
                back.effect.config.current_amount = back.effect.config.requirement
                G.GAME.no_saved = true
                return { func = function()
                    G.E_MANAGER:add_event(Event {
                        trigger = "after",
                        blocking = false,
                        func = function()
                            G.E_MANAGER:add_event(Event {
                            trigger = "after",
                            blocking = false,
                            func = function()
                                if G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED then
                                G.GAME.current_round.reroll_cost = G.GAME.round_resets.reroll_cost
                                G.GAME.current_round.reroll_cost_increase = 0
                                G.STATE = G.STATES.SHOP
                                G.STATE_COMPLETE = false
                                G.GAME.no_saved = nil
                                return true
                            end
                        end})
                        if G.blind_select then
                            G.blind_select.alignment.offset.y = G.blind_select.alignment.offset.y + G.blind_select.T.h
                            G.E_MANAGER:add_event(Event{
                            trigger = "after",
                            delay = 0.3,
                            func = function()
                                G.blind_select:remove()
                                G.blind_prompt_box:remove()
                                return true
                            end})
                        end
                        return true
                    end})
                end}
            else
                return {
                    message = ''..back.effect.config.current_amount,
                    colour = G.C.FILTER,
                    delay = 0.5
                }
            end
        end
    end
}

--[[SMODS.Tag:take_ownership('skip', -- make skip tag appear properly in the shop
    {
        loc_vars = function(self, info_queue, tag)
            return { vars = { tag.config.skip_bonus, tag.config.skip_bonus * ((G.GAME.skips or 0) + (Cracker.tag_is_in_shop(tag) and 0 or 1)) } }
        end,
    },
    true
)]]
for tag_key, enabled in pairs(Cracker.money_tags) do
    if enabled then
        SMODS.Tag:take_ownership(tag_key,
        {
            get_weight = function(self, weight)
                if G.GAME.selected_back_key.key == "b_cracker_golden" or G.GAME.used_vouchers['v_cracker_pw_golden'] then
                    return 30
                end
                return 10
            end
        },
        true)
    end
end

SMODS.Back{ -- Rebate Deck
    key = "rebate",
    
    pos = {
        x = 1,
        y = 0,
    },
    config = {
        requirement = 25,
        current_amount = 0,
        active = true
    },
    atlas = 'Backs',
    discovered = true,
    unlocked = false,
    locked_loc_vars = function(self, info_queue, back)
        return {
            vars = {
                30
            }
        }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'cracker_money_spent' and G.GAME.cracker_money_spent >= 30
    end,
    loc_vars = function(self, info_queue, center)
        key = "b_cracker_rebate"
        if not G.GAME.selected_back.effect.config.requirement then -- figure out a way to make this work while still playing the deck
            key = key.."_collection"
        end
        return {vars = {G.GAME.selected_back.name == 'b_cracker_rebate' and G.GAME.selected_back.effect.config.requirement or self.config.requirement, G.GAME.selected_back.name == 'b_cracker_rebate' and G.GAME.selected_back.effect.config.current_amount or self.config.current_amount}, key = key}
    end,
    calculate = function(self, back, context)
        if context.money_altered and context.amount < 0 and back.effect.config.active then
            back.effect.config.current_amount = back.effect.config.current_amount - context.amount
            if back.effect.config.current_amount >= back.effect.config.requirement then
                back.effect.config.current_amount = back.effect.config.requirement
                if context.from_shop then
                    back.effect.config.active = false
                    return Cracker.spawn_mega_pack()
                end
            else
                return {
                    message = ''..back.effect.config.current_amount,
                    colour = G.C.FILTER,
                    delay = 0.5
                }
            end
        elseif context.starting_shop and back.effect.config.current_amount >= back.effect.config.requirement and back.effect.config.active then
            back.effect.config.active = false
            return Cracker.spawn_mega_pack()
        elseif context.end_of_round and context.beat_boss and context.game_over == false and context.main_eval then
            back.effect.config.active = true
            back.effect.config.current_amount = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end,
}

SMODS.Back{ -- Blitz Deck
    key = "blitz",
    pos = {
        x = 2,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    unlocked = false,
    locked_loc_vars = function(self, info_queue, back)
        local other_name = localize('k_unknown')
        if G.P_CENTERS['b_cracker_golden'].unlocked then
            other_name = localize { type = 'name_text', set = 'Back', key = 'b_cracker_golden' }
        end

        return { vars = { other_name } }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win_deck' and get_deck_win_stake('b_cracker_golden') > 0
    end,
    config = { dollars = 15 },
    loc_vars = function(self, info_queue, back)
        return { vars = { G.GAME.selected_back.name == 'b_cracker_blitz' and G.GAME.selected_back.effect.config.dollars or self.config.dollars } }
    end,
    apply = function(self, back)
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
        G.GAME.win_ante = 6
    end,
}

SMODS.Back{ -- Catalog Deck
    key = "catalog",
    pos = {
        x = 4,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    config = { vouchers = { 'v_overstock_norm' } },
    unlocked = false,
    locked_loc_vars = function(self, info_queue, back)
        return { vars = { 150 } }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'discover_amount' and args.amount >= 150
    end,
    loc_vars = function(self, info_queue, center)
        return {vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' } } }
    end,
    apply = function(self, back)
        SMODS.change_booster_limit(-1)
        SMODS.change_voucher_limit(1)
    end
}
