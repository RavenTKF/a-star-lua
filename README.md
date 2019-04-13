A* for Lua
==========
[![LICENSE](https://img.shields.io/badge/license-MIT.svg)](https://github.com/RavenTKF/a-star-lua/blob/master/LICENSE) [![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/RavenTKF/a-star-lua/blob/master/LICENSE)

A clean, simple implementation of the A* pathfinding algorithm for Lua.

Modified for in using of Unity projects.

This implementation has no dependencies and has a simple interface. It takes a table of nodes, a start and end point and a "valid neighbor" function which makes it easy to adapt the module's behavior, especially in circumstances where valid paths would frequently change.

The module automatically caches paths which saves CPU time for frequently accessed start and end nodes. Cached paths can be ignored by setting the appropriate parameter in the main function. Cached paths can be purged with the `clear_cached_paths ()` function.

## Usage example ##

	-- this function determines which neighbors are valid (e.g., within range) 
	-- in file a-star.lua
	
	function astar:is_valid_node ( node, neighbor ) 
	
		local MAX_DIST = 1.2
			
		-- helper function in the a-star module, returns distance between points
		if 	neighbor.player_id == node.player_id and 
			self:dist ( node.x, node.y, neighbor.x, neighbor.y ) < MAX_DIST then
			return true
		end
		return false
	end
	
	--in file test.lua
	local ignore = true -- ignore cached paths
	
	local path = astar.path ( start, end, all_nodes, ignore, valid_node_func )
	
	if path then
		-- do something with path (a lua table of ordered nodes from start to end)
	end
	
## Maphandler ##
	
	-- This file provides three 20x20 maps
	-- you can generate your own map by using mapgenerator(You need set block grids by yourself)
	-- x:[-10,10] y:[-10,10]   grids:20x20
	
## BaseClass ##
	
	-- Automatically call __init by using .New()
	
## a-star ##
	
	-- Get NodeID by using x,y
	-- Work in 20x20 map
	function astar:getNodeID ( x, y )
		local x_n = math.ceil((x+10)/1)
		if x_n == 0 then
			x_n = x_n +1
		end

		local y_n = math.ceil(math.abs(y-10)/1)
		if y_n == 0 then
			y_n = y_n +1
		end
		return  x_n + (y_n - 1) * 20 
	end
	
	
## Notes ##

This assumes that nodes are objects (tables) with (at least) members "x" and "y" that hold the node's coordinates.

	node = {}
	node.x = 123
	node.y = 456
	node.foo = "bar"
