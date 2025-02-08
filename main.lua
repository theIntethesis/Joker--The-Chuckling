SMODS.Atlas {
	key = "LeylineBack",
	path = "leyline.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
    key = "Jokers",
    path = "Jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "Vouchers",
    path = "vouchers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'HC_deck',
    path = 'hc_mana_cards.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "Backs",
    path = "backs.png",
    px = 71,
    py = 95
}
  

SMODS.Atlas {
    key = 'LC_deck',
    path = 'lc_mana_cards.png',
    px = 71,
    py = 95
}
  
SMODS.Atlas {
    key = 'LC_ui',
    path = 'lc_ui.png',
    px = 18,
    py = 18
}
  
SMODS.Atlas {
    key = 'HC_ui',
    path = 'hc_ui.png',
    px = 18,
    py = 18
}

JTC = { 
    manaPool = false,
    C = {
        WHITE = HEX('EAD8CA'),
        BLUE = HEX('57B2DD'),
        BLACK = HEX('29231C'),
        RED = HEX('D84527'),
        GREEN = HEX('88B272')
    }
 }

JTC.Suit = SMODS.Suit:extend{
    lc_atlas = 'JTC_LC_deck',
    hc_atlas = 'JTC_HC_deck',
    lc_ui_atlas = 'JTC_LC_ui',
    hc_ui_atlas = 'JTC_HC_ui',
    in_pool = function(self, args)
		if args.initial_deck then return false end
		return JTC.manaPool
	end
}

for _ , path in ipairs{
    "decks.lua",
    "suits.lua",
    "debug.lua",
    'jokers.lua', 
    'hands.lua',
    'utils.lua'
} do
    assert(SMODS.load_file(path))()
end