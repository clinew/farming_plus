
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

farming.register_plant("farming_plus:potato2", {
	description = "Potato Seed",
	inventory_image = "farming_plus_potato_seed.png",
	steps = 3,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
	groups = {flammable = 2},
})
minetest.register_alias("farming_plus:potato", "farming_plus:potato2_3")
minetest.register_alias("farming_plus:potato_seed", "farming_plus:seed_potato2")
minetest.register_alias("farming_plus:potato_1", "farming_plus:potato2_3")
minetest.register_alias("farming_plus:potato_2", "farming_plus:potato2_3")

minetest.register_craftitem("farming_plus:potato2", {
	description = S("Potato"),
	inventory_image = "farming_plus_potato.png",
})
minetest.register_alias("farming_plus:potato_item", "farming_plus:potato2")

table.insert(farming_plus.registered_plants, "farming_plus:potato")

minetest.register_alias("farming_plus:potatoe_item", "farming_plus:potato_item")
minetest.register_alias("farming_plus:potatoe_seed", "farming_plus:potato_seed")
minetest.register_alias("farming_plus:potatoe", "farming_plus:potato")
minetest.register_alias("farming_plus:potatoe_1", "farming_plus:potato_1")
minetest.register_alias("farming_plus:potatoe_2", "farming_plus:potato_2")

