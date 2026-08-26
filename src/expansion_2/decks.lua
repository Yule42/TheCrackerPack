SMODS.Back{ -- Golden Deck
    key = "golden",
    
    pos = {
        x = 0,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    config = {
    },
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    calculate = function(self, back, context)
        if context.skip_blind then
            stop_use()
            if G.blind_select then
                G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
                G.blind_select.alignment.offset.x = 0
            end
            G.deck:shuffle('cashout'..G.GAME.round_resets.ante)
            G.deck:hard_set_T()
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}
            G.GAME.current_round.free_rerolls = G.GAME.round_resets.free_rerolls
            calculate_reroll_cost(true)
            if G.blind_prompt_box then
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object.pop_delay = 0
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').config.object:pop_out(5)
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object.pop_delay = 0
                G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext2').config.object:pop_out(5) 
            end
            delay(0.3)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    if G.blind_select then
                        G.blind_select:remove()
                        G.blind_prompt_box:remove()
                        G.blind_select = nil
                    end
                    G.STATE = G.STATES.SHOP
                    G.GAME.shop_free = nil
                    G.GAME.shop_d6ed = nil
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
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

function Cracker.spawn_jumbo_pack_rebate()
    local center = get_pack('rebate_deck')
    local count = 0
    local found = nil
    
    while count <= 1000 and not found do
        if not center.name:find('Jumbo') then
            center = get_pack('rebate_deck')
        else
            found = true
        end
        count = count + 1
    end
    local booster = SMODS.add_booster_to_shop(center.key)
    booster.ability.couponed = true
    booster:set_cost()
    return {
        message = localize('k_cracker_rebate'),
        colour = G.C.FILTER,
        delay = 0.5
    }
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
                    return Cracker.spawn_jumbo_pack_rebate()
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
            return Cracker.spawn_jumbo_pack_rebate()
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
    config = { vouchers = { 'v_overstock_norm', 'v_overstock_plus', 'v_reroll_surplus', 'v_reroll_glut' } },
    loc_vars = function(self, info_queue, center)
        return {vars = { localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' }, localize { type = 'name_text', key = self.config.vouchers[4], set = 'Voucher' } } }
    end,
    apply = function(self, back)
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 2
        if G.GAME.modifiers.scaling == 4 then
            G.GAME.modifiers.scaling = "blitz_mid"
        elseif G.GAME.modifiers.scaling == 5 then
            G.GAME.modifiers.scaling = "blitz_full"
        end
        G.GAME.modifiers.cracker_increased_blinds = true
        G.GAME.win_ante = 6
    end,
}

local ref_bl_amo = get_blind_amount
function get_blind_amount(ante)
    if G.GAME.modifiers.scaling and G.GAME.modifiers.scaling == "blitz_mid" then
        local amounts = {
          300, 1100, 3500, 11000, 35000, 75000, 150000, 400000
        }
        if ante < 1 then return 100 end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = math.floor(a*(b+(k*c)^d)^c)
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
        return amount
    elseif G.GAME.modifiers.scaling and G.GAME.modifiers.scaling == "blitz_full" then
        local amounts = {
          300, 1200, 4000, 15000, 50000, 150000, 400000, 800000
        }
        if ante < 1 then return 100 end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = math.floor(a*(b+(k*c)^d)^c)
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
        return amount
    end
    return ref_bl_amo(ante)
end

SMODS.Back{ -- Catalog Deck
    key = "catalog",
    
    pos = {
        x = 4,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    config = { vouchers = { 'v_overstock_norm' } },
    loc_vars = function(self, info_queue, center)
        return {vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' } } }
    end,
    
    apply = function(self, back)
        SMODS.change_booster_limit(-1)
        SMODS.change_voucher_limit(1)
    end
}

SMODS.Back{ -- Patchwork Deck
    name = "Patchwork Deck", 
    key = "patchwork",
    
    pos = {
        x = 3,
        y = 0,
    },
    atlas = 'Backs',
    discovered = true,
    
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.GAME.modifiers.voucher_override = 'patchwork_enabled'
        G.GAME.modifiers.voucher_restock_antes = 2
    end
}
