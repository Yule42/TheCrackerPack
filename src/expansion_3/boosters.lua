local normal_boosters = {keys = {'reverse_arcana_normal_1', 'reverse_arcana_normal_2', 'reverse_arcana_normal_3', 'reverse_arcana_normal_4'}, info = {
    atlas = 'booster',
    config = {
        choose = 1,
        extra = 3
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {(card and card.ability.choose or self.config.choose), card and card.ability.extra or self.config.extra}}
    end,
    create_card = function(self, card)
        return create_card("reversetarot", G.pack_cards, nil, nil, true, true, nil, "reverse_arcana")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.REVERSE_ARCANA)
        ease_background_colour{new_colour = G.C.REVERSE_ARCANA, special_colour = G.C.BLACK, contrast = 2}
    end,
    group_key = 'reverse_arcana_pack',
    kind = 'cracker_reverse_arcana',
    draw_hand = true,
    cost = 4,
    weight = 0.2,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}}

for i, key in ipairs(normal_boosters.keys) do
    local booster_args = {}
    for k,v in pairs(normal_boosters.info) do
        booster_args[k] = v
    end
    booster_args.key = key
    booster_args.pos = {
        x = i - 1,
        y = 0
    }
    SMODS.Booster(booster_args)
end

local jumbo_boosters = {keys = {'reverse_arcana_jumbo_1', 'reverse_arcana_jumbo_2'}, info = {
    atlas = 'booster',
    config = {
        choose = 1,
        extra = 5
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {(card and card.ability.choose or self.config.choose), card and card.ability.extra or self.config.extra}}
    end,
    create_card = function(self, card)
        return create_card("reversetarot", G.pack_cards, nil, nil, true, true, nil, "reverse_arcana")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.REVERSE_ARCANA)
        ease_background_colour{new_colour = G.C.REVERSE_ARCANA, special_colour = G.C.BLACK, contrast = 2}
    end,
    group_key = 'reverse_arcana_pack_2',
    kind = 'cracker_reverse_arcana',
    draw_hand = true,
    cost = 6,
    weight = 0.1,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}}

for i, key in ipairs(jumbo_boosters.keys) do
    local booster_args = {}
    for k,v in pairs(jumbo_boosters.info) do
        booster_args[k] = v
    end
    booster_args.key = key
    booster_args.pos = {
        x = i - 1,
        y = 1
    }
    SMODS.Booster(booster_args)
end

local mega_boosters = {keys = {'reverse_arcana_mega_1', 'reverse_arcana_mega_2'}, info = {
    atlas = 'booster',
    config = {
        choose = 2,
        extra = 5
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {(card and card.ability.choose or self.config.choose), card and card.ability.extra or self.config.extra}}
    end,
    create_card = function(self, card)
        return create_card("reversetarot", G.pack_cards, nil, nil, true, true, nil, "reverse_arcana")
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, G.C.REVERSE_ARCANA)
        ease_background_colour{new_colour = G.C.REVERSE_ARCANA, special_colour = G.C.BLACK, contrast = 2}
    end,
    group_key = 'reverse_arcana_pack_3',
    kind = 'cracker_reverse_arcana',
    draw_hand = true,
    cost = 8,
    weight = 0.04,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}}

for i, key in ipairs(mega_boosters.keys) do
    local booster_args = {}
    for k,v in pairs(mega_boosters.info) do
        booster_args[k] = v
    end
    booster_args.key = key
    booster_args.pos = {
        x = 2 + i - 1,
        y = 1
    }
    SMODS.Booster(booster_args)
end