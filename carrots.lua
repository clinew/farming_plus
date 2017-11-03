
--  'farming_plus' farming mod for Minetest.
--  Copyright (C) 2017  PilzAdam, Wade Cline
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2.1 of the License, or (at your option) any later version.
--
--  This library is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public
--  License along with this library; if not, write to the Free Software
--  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

-- main `S` code in init.lua
local S
S = farming_plus.S

farming.register_plant("farming_plus:carrot2", {
	description = "Carrot Seed",
	inventory_image = "farming_plus_carrot_seed.png",
	steps = 4,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
	groups = {flammable = 2},
})
minetest.register_alias("farming_plus:carrot", "farming_plus:carrot2_4")
minetest.register_alias("farming_plus:carrot_seed", "farming_plus:seed_carrot2")
minetest.register_alias("farming_plus:carrot_1", "farming_plus:carrot2_4")
minetest.register_alias("farming_plus:carrot_2", "farming_plus:carrot2_4")
minetest.register_alias("farming_plus:carrot_3", "farming_plus:carrot2_4")

minetest.register_craftitem("farming_plus:carrot2", {
	description = S("Carrot"),
	inventory_image = "farming_plus_carrot.png",
	on_use = minetest.item_eat(2),
})
minetest.register_alias("farming_plus:carrot_item", "farming_plus:carrot2")

table.insert(farming_plus.registered_plants, "farming_plus:carrot")
