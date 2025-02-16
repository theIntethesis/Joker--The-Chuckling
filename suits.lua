
JTC.WhiteMana = JTC.Suit {
	key = 'White',
	card_key = "W",
	pos = {y = 0},
	ui_pos = {x=0,y=2},
	loc_txt = {
		singular = 'White',
		plural = 'White'
	},
	hc_colour = HEX('EAD8CA'),
	lc_colour = HEX('EAD8CA')
}

JTC.BlueMana = JTC.Suit {
	key = 'Blue',
	card_key = "U",
	pos = {y = 1},
	ui_pos = {x=1,y=2},
	loc_txt = {
		singular = 'Blue',
		plural = 'Blue'
	},
	hc_colour = HEX('57B2DD'),
	lc_colour = HEX('57B2DD')
}

JTC.BlackMana = JTC.Suit {
	key = 'Black',
	card_key = "B",
	pos = {y = 2},
	ui_pos = {x=2,y=2},
	loc_txt = {
		singular = 'Black',
		plural = 'Black'
	},
	hc_colour = HEX('29231C'),
	lc_colour = HEX('29231C')
}

JTC.RedMana = JTC.Suit {
	key = 'Red',
	card_key = "R",
	pos = {y = 3},
	ui_pos = {x=3,y=2},
	loc_txt = {
		singular = 'Red',
		plural = 'Red'
	},
	hc_colour = HEX('D84527'),
	lc_colour = HEX('D84527')
}

JTC.GreenMana = JTC.Suit {
	key = 'Green',
	card_key = "G",
	pos = {y = 4},
	ui_pos = {x=0,y=3},
	loc_txt = {
		singular = 'Green',
		plural = 'Green'
	},
	hc_colour = HEX('88B272'),
	lc_colour = HEX('88B272')
}


JTC.Colorless = SMODS.Enhancement {
	key = 'Colorless',
	loc_txt = {
		name = 'Colorless',
		text = {
			"Colorless Card",
			"{C:chips}+20{} chips",
			"{C:red}Self-destructs"
		}
	},
	atlas = 'backs.png',
	pos = {x=0,y=5},
	config = {
		bonus_chips = 20
	},
	-- replace_base_card = true,
	no_rank = true,
	no_suit = true,
	always_scores = true,
	calculate = function(self, card, context)
		if context.after == true then
			JTC_UTIL.destroy_playing_cards({card}, card, {
				message = 'Sacrificed!',
				colour = G.C.GREY
			})
		end
	end
}