
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


-- Tree-generation taken in part from Minetest Game.

farming_plus = {}
farming_plus.registered_plants = {}
farming_plus.registered_trees = {}

farming_plus.tree_growth_min = 2400
farming_plus.tree_growth_max = 4800
farming_plus.tree_growth_delay_min = 240
farming_plus.tree_growth_delay_max = 600

-- Boilerplate to support localized strings if intllib mod is installed.
if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	farming_plus.S = intllib.Getter(minetest.get_current_modname())
else
	farming_plus.S = function ( s ) return s end
end

-- Register tree-generation functions.
-- The 'generator' function returns either 'nil' if the tree is not generated
-- or it returns the position where the tree was generated at.
function farming_plus.add_tree(name, generator, rarity)
	table.insert(farming_plus.registered_trees, {
		name = name,
		generator = generator,
		rarity = rarity,
	})
end

-- Based on minetest_game/mods/default/trees.lua v0.4.14
function farming_plus.add_trunk_and_leaves(data, a, pos, tree_cid, leaves_cid,
		height, size, iters, fruit, rarity)
	local x, y, z = pos.x, pos.y, pos.z
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_fruit = minetest.get_content_id(fruit)

	-- Trunk
	data[a:index(x, y, z)] = tree_cid -- Force-place lowest trunk node to replace sapling
	for yy = y + 1, y + height - 1 do
		local vi = a:index(x, yy, z)
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore or node_id == leaves_cid then
			data[vi] = tree_cid
		end
	end

	-- Force leaves near the trunk
	for z_dist = -1, 1 do
	for y_dist = -size, 1 do
		local vi = a:index(x - 1, y + height + y_dist, z + z_dist)
		for x_dist = -1, 1 do
			if data[vi] == c_air or data[vi] == c_ignore then
				if math.random(1, 100) <= rarity then
					data[vi] = c_fruit
				else
					data[vi] = leaves_cid
				end
			end
			vi = vi + 1
		end
	end
	end

	-- Randomly add leaves in 2x2x2 clusters.
	for i = 1, iters do
		local clust_x = x + math.random(-size, size - 1)
		local clust_y = y + height + math.random(-size, 0)
		local clust_z = z + math.random(-size, size - 1)

		for xi = 0, 1 do
		for yi = 0, 1 do
		for zi = 0, 1 do
			local vi = a:index(clust_x + xi, clust_y + yi, clust_z + zi)
			if data[vi] == c_air or data[vi] == c_ignore then
				if math.random(1, 100) <= rarity then
					data[vi] = c_fruit
				else
					data[vi] = leaves_cid
				end
			end
		end
		end
		end
	end
end

-- Based in part on minetest_game/mods/default/trees.lua v0.4.14
function farming_plus.generate_tree(pos, trunk, leaves, underground, fruit,
	rarity, spawned)
	local x, y, z = pos.x, pos.y, pos.z
	local height = math.random(4, 5)
	local c_tree = minetest.get_content_id(trunk)
	local c_leaves = minetest.get_content_id(leaves)
	local cant_grow = false
	local light_required = spawned and 8 or 13

	-- Check if growing is possible.
	local nodename = minetest.get_node(pos).name
	for _,name in ipairs(underground) do
		if nodename == name then
			-- Surface not suitable.
			cant_grow = true
		end
	end
	pos.y = pos.y+1
	local light = minetest.get_node_light(pos, spawned and 0.5 or nil)
	if not light or light < light_required then
		-- Too dark.
		cant_grow = true
	elseif spawned and (minetest.get_mapgen_params().water_level >= pos.y) then
		-- Underwater.
		cant_grow = true
	end
	local node = {name = ""}
	for dy=1,4 do
		pos.y = pos.y+dy
		if minetest.get_node(pos).name ~= "air" then
			-- Obstructed.
			cant_grow = true
		end
		pos.y = pos.y-dy
	end
	pos.y = pos.y-1
	if cant_grow then
		if spawned then
			return
		end
		minetest.get_node_timer(pos):start(math.random(
			farming_plus.tree_growth_delay_min,
			farming_plus.tree_growth_delay_max))
		return
	end

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = pos.x - 2, y = pos.y, z = pos.z - 2},
		{x = pos.x + 2, y = pos.y + height + 1, z = pos.z + 2}
	)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	farming_plus.add_trunk_and_leaves(data, a, pos, c_tree, c_leaves, height, 2, 8, fruit, rarity)
	if spawned == false then
		minetest.log("Node '" .. nodename .. "' grows into a tree at '" .. minetest.pos_to_string(pos) .. "'")
	end

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

-- Define the function to call when a tree is created; start its growth timer.
function farming_plus.tree_on_construct(pos)
	minetest.get_node_timer(pos):start(math.random(
		farming_plus.tree_growth_min,
		farming_plus.tree_growth_max))
end

-- Start timers on nodes which did not previously have timers.
minetest.register_lbm({
	name = "farming_plus:sapling_growth",
	nodenames = {"farming_plus:banana_sapling",
		"farming_plus:cocoa_sapling",
		"farming_plus:cherry_sapling",
		"farming_plus:orange_sapling"},
	run_at_every_load = true,
	action = function(pos)
		local timer = minetest.get_node_timer(pos)
		if timer:is_started() == false then
			timer:start(math.random(farming_plus.tree_growth_min,
				farming_plus.tree_growth_max))
			minetest.log("Started growth timer on '" ..
				minetest.get_node(pos).name .. "' at '" ..
				minetest.pos_to_string(pos) .. "'")
		end
	end
})

-- ========= GENERATE PLANTS IN THE MAP =========
minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y >= 2 and minp.y <= 0 then
		-- Generate plants (code from flowers)
		local perlin1 = minetest.get_perlin(974, 3, 0.6, 100)
		-- Assume X and Z lengths are equal
		local divlen = 16
		local divs = (maxp.x-minp.x)/divlen+1;
		for divx=0,divs-1 do
		for divz=0,divs-1 do
			local x0 = minp.x + math.floor((divx+0)*divlen)
			local z0 = minp.z + math.floor((divz+0)*divlen)
			local x1 = minp.x + math.floor((divx+1)*divlen)
			local z1 = minp.z + math.floor((divz+1)*divlen)
			-- Determine flowers amount from perlin noise
			local grass_amount = math.floor(perlin1:get2d({x=x0, y=z0}) ^ 3 * 9)
			-- Find random positions for flowers based on this random
			local pr = PseudoRandom(seed+456)
			for i=0,grass_amount do
				if math.random(1, 100) == 100 then
					local x = pr:next(x0, x1)
					local z = pr:next(z0, z1)
					-- Find ground level (0...15)
					local ground_y = nil
					for y=30,0,-1 do
						if minetest.get_node({x=x,y=y,z=z}).name ~= "air" then
							ground_y = y
							break
						end
					end

					if ground_y then
						local p = {x=x,y=ground_y+1,z=z}
						local nn = minetest.get_node(p).name
						-- Check if the node can be replaced
						if minetest.registered_nodes[nn] and
							minetest.registered_nodes[nn].buildable_to then
							nn = minetest.get_node({x=x,y=ground_y,z=z}).name
							if nn == "default:dirt_with_grass" then
								--local plant_choice = pr:next(1, #farming_plus.registered_plants)
								local plant_choice = math.floor(perlin1:get2d({x=x,y=z})*(#farming_plus.registered_plants))
								local plant = farming_plus.registered_plants[plant_choice]
								if plant then
									minetest.set_node(p, {name=plant})
									minetest.log("Generated rare '"..plant:split(":")[2].."' plant at '"..minetest.pos_to_string(p).."'")
								end
							end
						end
					end
				end
			end
		end
		end
	end
end)

-- Generate trees in the map.
minetest.register_on_generated(function(minp, maxp, seed)
	-- Build list of possible rare trees to spawn, based on their rarity.
	local roll = math.random(1, 100)
	local trees = {}
	for i = 1, #farming_plus.registered_trees do
		if roll <= farming_plus.registered_trees[i].rarity then
			table.insert(trees, farming_plus.registered_trees[i])
		end
	end
	if next(trees) == nil then
		-- No rare trees this time.
		return
	end

	-- Randomly select a rare tree.
	local tree_index = math.random(1, #trees)
	local tree = trees[tree_index]
	local ret = tree.generator(minp, maxp, seed)
	if ret ~= nil then
		minetest.log("Generated rare '"..tree.name.."' tree at '"..minetest.pos_to_string(ret).."'")
	end
end)

-- ========= ALIASES FOR FARMING MOD BY SAPIER =========
-- potatoe -> potatoe
minetest.register_alias("farming_plus:potatoe_node", "farming_plus:potatoe")
--minetest.register_alias("farming_plus:potatoe", "farming_plus:potatoe_item") cant do this
minetest.register_alias("farming_plus:potatoe_straw", "farming_plus:potatoe")
minetest.register_alias("farming_plus:seed_potatoe", "farming_plus:potatoe_seed")
for lvl = 1, 6, 1 do
	minetest.register_entity(":farming_plus:potatoe_lvl"..lvl, {
		on_activate = function(self, staticdata)
			minetest.set_node(self.object:getpos(), {name="farming_plus:potatoe_1"})
		end
	})
end

-- ========= BANANAS =========
dofile(minetest.get_modpath("farming_plus").."/bananas.lua")

-- ========= CARROTS =========
dofile(minetest.get_modpath("farming_plus").."/carrots.lua")
--
-- ========= CHERRY =========
dofile(minetest.get_modpath("farming_plus").."/cherries.lua")

-- ========= COCOA =========
dofile(minetest.get_modpath("farming_plus").."/cocoa.lua")

-- ========= ORANGES =========
dofile(minetest.get_modpath("farming_plus").."/oranges.lua")

-- ========= POTATOES =========
dofile(minetest.get_modpath("farming_plus").."/potatoes.lua")

-- ========= PUMPKIN =========
dofile(minetest.get_modpath("farming_plus").."/pumpkin.lua")

-- ========= RHUBARB =========
dofile(minetest.get_modpath("farming_plus").."/rhubarb.lua")

-- ========= STRAWBERRIES =========
dofile(minetest.get_modpath("farming_plus").."/strawberries.lua")

-- ========= TOMATOES =========
dofile(minetest.get_modpath("farming_plus").."/tomatoes.lua")

-- ========= WEED =========
dofile(minetest.get_modpath("farming_plus").."/weed.lua")
