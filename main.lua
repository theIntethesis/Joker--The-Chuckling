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
    key = "HC_deck",
    path = "mana_cards.png",
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
    key = "LC_deck",
    path = "mana_cards.png",
    px = 71,
    py = 95
}
  
SMODS.Atlas {
    key = "LC_ui",
    path = "lc_ui.png",
    px = 18,
    py = 18
}
  
SMODS.Atlas {
    key = "HC_ui",
    path = "hc_ui.png",
    px = 18,
    py = 18
}

JTC = {
    magic_pool = false
}

JTC.Suit = SMODS.Suit:extend{
    lc_atlas = 'LC_deck',
    hc_atlas = 'HC_deck',
    lc_ui_atlas = 'LC_ui',
    hc_ui_atlas = 'HC_ui',
    in_pool = function(self, args)
        if args.initial_deck then
            return false
        end
        return JTC.magic_pool
    end
}

for _, path in ipairs{
    "decks.lua",
    "suits.lua",
    "debug.lua"
} do
    assert(SMODS.load_file(path))()
end