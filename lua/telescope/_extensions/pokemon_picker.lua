local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local pokemon_picker = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'Pokémon',
      finder = finders.new_oneshot_job({
        'curl',
        '-s',
        'https://pokeapi.co/api/v2/pokemon?limit=151',
      }, opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          print('You selected: ' .. selection.value.name)
        end)
        return true
      end,
    })
    :find()
end

return require('telescope').register_extension {
  setup = function() end,
  exports = {
    pokemon = pokemon_picker,
  },
}
