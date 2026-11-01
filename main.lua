CrackerConfig = SMODS.current_mod.config

SMODS.current_mod.optional_features = function()
    return {
        object_weights = true,
        post_trigger = true,
    }
end

SMODS.current_mod.no_marquee = true

--region Atlas
SMODS.Atlas {
    key = 'Jokers',
    path = "Jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'mods_modicon',
    px = 34,
    py = 34,
    path = 'modicon.png'
}

SMODS.Atlas {
    key = 'Vouchers',
    path = "Vouchers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Backs',
    path = "backs.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'falcon',
    path = "falcon.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'tags',
    path = "tags.png",
    px = 34,
    py = 34,
}

SMODS.Atlas {
    key = 'spectral',
    path = "spectral.png",
    px = 71,
    py = 95,
}

SMODS.Attribute {
    key = "debuff",
}

-- utils
assert(SMODS.load_file('utils/functions.lua'))()
assert(SMODS.load_file('utils/tabs.lua'))()
assert(SMODS.load_file('utils/enabled_content.lua'))()

Cracker.load_files('src/Items/Jokers', Cracker.jokers)

assert(SMODS.load_file('src/voucher.lua'))()

assert(SMODS.load_file('src/new_additions/tags.lua'))() -- guess who needs to be referenced later?

assert(SMODS.load_file('src/expansion_2/decks.lua'))()

assert(SMODS.load_file('src/new_additions/decks.lua'))()
--assert(SMODS.load_file('src/new_additions/showdown_blinds.lua'))()

assert(SMODS.load_file('src/ever_stuffer/decks.lua'))()
assert(SMODS.load_file('src/ever_stuffer/jokers.lua'))()
assert(SMODS.load_file('src/ever_stuffer/vouchers.lua'))()
assert(SMODS.load_file('src/ever_stuffer/editions.lua'))()

if JokerDisplay then
    assert(SMODS.load_file('src/compat/JokerDisplay.lua'))()
end

if next(SMODS.find_mod('allinjest')) then
    assert(SMODS.load_file('src/compat/AllInJest.lua'))()
end

--[[if next(SMODS.find_mod('paperback')) then
    assert(SMODS.load_file('src/compat/Paperback.lua'))()
end]]

assert(SMODS.load_file('src/expansion_2/patchwork_deck.lua'))() -- always at the last of the list of decks for an obvious reason

if next(SMODS.find_mod('partner')) then
	SMODS.Atlas {
		key = 'Partner',
		path = "Partners.png",
		px = 46,
		py = 58
	}
	assert(SMODS.load_file('src/compat/Partner.lua'))()
end

if CardSleeves then
	SMODS.Atlas {
		key = 'sleeves',
		path = "sleeves.png",
		px = 73,
		py = 95
	}
	assert(SMODS.load_file('src/compat/CardSleeves.lua'))()
end

local mod_path = ''..SMODS.current_mod.path..'/src/'

local function collect_item_files(base_fs, rel, out)
    print(NFS.getDirectoryItems(base_fs))
    print(base_fs)
	for _, name in ipairs(NFS.getDirectoryItems(base_fs)) do
        print(name)
		local abs = base_fs .. "/" .. name
		local info = NFS.getInfo(abs)
		if info and info.type == "directory" then
			collect_item_files(abs, rel .. "/" .. name, out)
		elseif info and info.type == "file" and name:match("%.lua$") then
			table.insert(out, rel .. "/" .. name)
		end
	end
end

-- Collect item files
local files = {}
collect_item_files(mod_path .. "Items", "/src/Items", files)
local objects = {}
for _, rel in ipairs(files) do
	local f, err = SMODS.load_file(rel)
	if not f then
		print("Error loading item file '" .. rel .. "': " .. tostring(err))
	else
		local ok, curr_obj = pcall(f)
		if ok then
			table.insert(objects, curr_obj)
		end
	end
end

-- Sort loaded objects by defined order
table.sort(objects, function(a, b)
	local function get_lowest_order(obj)
		if not obj.items then
			return math.huge
		end
		local lowest = math.huge
		for _, item in ipairs(obj.items) do
			if item.order and item.order < lowest then
				lowest = item.order
			end
		end
		return lowest
	end
	return get_lowest_order(a) < get_lowest_order(b)
end)

-- Load all the items
for _, item in ipairs(objects) do
    item.ignore = item.ignore or false
    if SMODS[item.object_type] and not item.ignore then
        SMODS[item.object_type](item)
    elseif CardSleeves and CardSleeves[item.object_type] and not item.ignore then
        CardSleeves[item.object_type](item)
    elseif not item.ignore then
        print("Error loading item "..item.key.." of unknown type "..item.object_type)
    end
end

assert(SMODS.load_file('src/expansion_2/deck_vouchers.lua'))()
assert(SMODS.load_file('src/challenge.lua'))() -- load this last cause it references stuff from previous files

SMODS.current_mod.calculate = function(self, context)
    if context.tag_added and context.tag_added.key == "tag_cracker_loan" then
        ease_dollars(30)
    elseif context.joker_type_destroyed then
        if Cracker.is_food(context.card) then
            G.GAME.Cracker.food_jokers_destroyed = G.GAME.Cracker.food_jokers_destroyed + 1
        end
    elseif context.money_altered then
        if context.from_shop and context.amount < 0 then
            G.GAME.cracker_money_spent = (G.GAME.cracker_money_spent or 0) - context.amount
            check_for_unlock({type = 'cracker_money_spent'})
        end
        check_for_unlock({type = 'cracker_money_change', amount = context.amount})
    elseif context.starting_shop then
        G.GAME.cracker_money_spent = 0
    elseif context.post_trigger then
        if context.other_card.ability and context.other_card.ability.set == 'Joker' and not G.GAME.Cracker.triggered_jokers[context.other_card.config.center_key] then
            G.GAME.Cracker.triggered_jokers[context.other_card.config.center_key] = true
            G.GAME.Cracker.triggered_jokers_count = G.GAME.Cracker.triggered_jokers_count + 1
        end
    end
end

local cdb = Card.calculate_dollar_bonus
function Card:calculate_dollar_bonus()
    local ret = cdb(self)
    if ret and ret > 0 and self.ability.set == 'Joker' and not G.GAME.Cracker.triggered_jokers[self.config.center_key] then
        G.GAME.Cracker.triggered_jokers[self.config.center_key] = true
        G.GAME.Cracker.triggered_jokers_count = G.GAME.Cracker.triggered_jokers_count + 1
    end
    return ret
end
