SMODS.ConsumableType{
    key = 'JTC_Token',
    primary_colour = HEX('FFFFFF'),
    secondary_colour = HEX('000000'),
    cards = {
        ["c_JTC_clue"] = true
    },
    loc_txt = {
        name = 'Token', -- used on card type badges
 		collection = 'Tokens', -- label for the button to access the collection
 		undiscovered = { -- description for undiscovered cards in the collection
 			name = '',
 			text = { '' },
 		},
    }
}

JTC.Consumable = SMODS.Consumable:extend{
    card_type = ""
}

SMODS.Atlas{
    key = 'clue_atlas',
    path = "clue.png",
    px = 71,
    py = 95
}
JTC.Consumable{
    key = "clue",
    set = 'JTC_Token',
    card_type = "Artifact",
    loc_txt = {
        name = "Clue",
        text = {
            "Draw one card."
        }
    },
    config = {
        extra = {
            numToDraw = 1,
            artifact = true
        }
    },
    atlas = 'clue_atlas',
    pos = {x=0,y=0},
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)

    end,
    use = function(self, card, area, copier)
        JTC_UTIL.draw_cards_ignore_hand_size(self.config.extra.numToDraw)
    end,
    can_use = function(self, card)
        if (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SELECTING_HAND) and #G.deck < 1 then return true
        else return false end
    end,
    in_pool = function(self, args)
        return false
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge('Artifact', G.C.GREY, G.C.WHITE)
    end,
}