local function get_available_voucher_upgrades(reserved_upgrades)
    local available_upgrades = {}
    local seen_upgrades = {}
    local in_shop = {}
    local reserved_upgrades = reserved_upgrades or {}

    if not (G and G.GAME and G.GAME.used_vouchers and G.P_CENTERS) then
        return available_upgrades
    end

    if G.shop_vouchers and G.shop_vouchers.cards then
        for _, voucher_card in ipairs(G.shop_vouchers.cards) do
            local center = voucher_card and voucher_card.config and voucher_card.config.center
            if center and center.key then
                in_shop[center.key] = true
            end
        end
    end

    for owned_voucher_key, owned in pairs(G.GAME.used_vouchers) do
        if owned then
            for center_key, center in pairs(G.P_CENTERS) do
                if center.set == 'Voucher' and type(center.requires) == 'table' and not G.GAME.used_vouchers[center_key] then
                    for _, requirement in ipairs(center.requires) do
                        if requirement == owned_voucher_key and not seen_upgrades[center_key] then
                            seen_upgrades[center_key] = true
                            if not in_shop[center_key] and not (reserved_upgrades and reserved_upgrades[center_key]) then
                                available_upgrades[#available_upgrades + 1] = center_key
                            end
                            break
                        end
                    end
                end
            end
        end
    end

    return available_upgrades
end

SMODS.Tag {
    key = 'crystal',
    config = {
        dollars_per_tarot = 2
    },
    pos = { 
        x = 0,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.dollars_per_tarot, tag.config.dollars_per_tarot * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)}}
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0) * tag.config.dollars_per_tarot)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'rocket',
    config = {
        dollars_per_planet = 3
    },
    pos = { 
        x = 1,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.dollars_per_planet, tag.config.dollars_per_planet * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0)}}
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0) * tag.config.dollars_per_planet)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'wheel',
    config = {
    },
    pos = { 
        x = 2,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        local key = tag.ability.wheels and "tag_cracker_wheel_set" or "tag_cracker_wheel"
        return {vars = { localize { set = 'Edition', type = 'name_text', key = tag.ability.wheels } }, key = key}
    end,
    set_ability = function(self, tag)
        if not tag.ability.blind_type then tag.ability.blind_type = 'Small' end
        if G.cracker_wheel_choices then
            tag.ability.wheels = G.cracker_wheel_choices
        elseif tag.ability.blind_type then
            if G.GAME.Cracker.wheel_choices and G.GAME.Cracker.wheel_choices[G.GAME.round_resets.ante] and G.GAME.Cracker.wheel_choices[G.GAME.round_resets.ante][tag.ability.blind_type] then
                tag.ability.wheels = G.GAME.Cracker.wheel_choices[G.GAME.round_resets.ante][tag.ability.blind_type]
            end
        end
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local editionless_jokers = {}

            for _, joker in ipairs(G.jokers.cards) do
                if not joker.edition and not joker.ability.cracker_wheel_reserved then
                    table.insert(editionless_jokers, joker)
                end
            end
            if #editionless_jokers > 0 then
                local eligible_card = pseudorandom_element(editionless_jokers, 'cracker_wheel_tag_jokers')
                local edition = tag.ability.wheels
                eligible_card.ability.cracker_wheel_reserved = true
                tag:yep('+', G.C.ATTENTION, function()
                    eligible_card:set_edition(edition, true)
                    check_for_unlock({ type = 'have_edition' })
                    eligible_card.ability.cracker_wheel_reserved = nil
                    return true
                end)
                tag.triggered = true
                return true
            end
        end
    end
}

SMODS.Tag {
    key = 'gift',
    config = {
    },
    pos = { 
        x = 3,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    in_pool = function(self, args)
        return #get_available_voucher_upgrades() > 0
    end,
    loc_vars = function(self, info_queue, tag)
        return {vars = {}}
    end,
apply = function(self, tag, context)
    if context.type == 'new_blind_choice' then
        local available = get_available_voucher_upgrades()
        if #available > 0 then
            local chosen_key = pseudorandom_element(available, pseudoseed('cracker_gift_tag'))
            tag:yep('+', G.C.SECONDARY_SET.Voucher, function()
                G.E_MANAGER:add_event(Event({func = function()
                    local voucher_card = create_card('Voucher', G.hand, nil, nil, nil, nil, chosen_key, 'cracker_gift_tag')
                    voucher_card.cost = 0
                    local prev_state = G.STATE
                    delay(0.2)
                    G.STATE = prev_state
                    G.FUNCS.use_card({ config = { ref_table = voucher_card } })
                    delay(0.6)
                    return true
                end}))
                G.E_MANAGER:add_event(Event({func = function()
                    for i = 1, #G.GAME.tags do
                        if G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then break end
                    end
                    return true
                end}))
                return true
            end)
            tag.triggered = true
            return true
        end
    end
end
}

SMODS.Tag {
    key = 'loan',
    config = {
        money = 30
    },
    pos = { 
        x = 4,
        y = 0
    },
    min_ante = 1,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.money}}
    end,
    apply = function(self, tag, context)
        if context.type == 'shop_end' then
            tag:yep('+', G.C.GOLD, function()
                if G.GAME.dollars ~= 0 then
                    ease_dollars(-G.GAME.dollars, true)
                end
                return true
            end)
            tag.triggered = true
        end
    end,
}
