-- Visualize and navigate undo history as a tree
--   https://github.com/mbbill/undotree

return {
	"mbbill/undotree",
	keys = {
		{ "U", vim.cmd.UndotreeToggle },
	},
}
