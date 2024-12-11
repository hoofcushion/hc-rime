---@class rime_schema
---@field schema rime_schema.schema
---@field recognizer rime_schema.recognizer
---@field engine rime_schema.engine
---@field key_binder rime_schema.key_binder
---@field punctuator rime_schema.punctuator
---@field speller rime_schema.speller
---@field ascii_composer rime_schema.ascii_composer
---@class rime_schema.schema
---@field schema_id string
---@field name string
---@field version? string
---@field description? string
---@field author? string
---@field dependencies? string[]
---@class rime_schema.recognizer
---@field patterns? table<string, string>
---@class rime_schema.engine
---@field processors? string[]
---@field segmentors? string[]
---@field translators? string[]
---@field filters? string[]
---@class rime_schema.key_binder
---@field bindings? rime_schema.key_binder.binding[]
---@class rime_schema.key_binder.binding
---@field accept string
---@field ["send"|"toggle"|"select"] string
---@field when string
---@class rime_schema.punctuator
---@field full_shape? (string|string[]|rime_schema.punctuator.pair|rime_schema.punctuator.commit)[]
---@field half_shape? (string|string[]|rime_schema.punctuator.pair|rime_schema.punctuator.commit)[]
---@class rime_schema.punctuator.pair
---@field [1] string
---@field [2] string
---@class rime_schema.punctuator.commit
---@field commit string
---@class rime_schema.speller
---@field alphabet? string
---@field initials? string
---@field finals? string
---@field delimiter? string
---@field algebra? string[]
---@field max_code_length? integer
---@field auto_select? boolean
---@field auto_select_pattern? string
---@field use_space? boolean
---@class rime_schema.ascii_composer
---@field good_old_caps_lock? boolean
---@field switch_key? rime_schema.ascii_composer.switch_key
---@class rime_schema.ascii_composer.switch_key
---@field Caps_Lock? rime_schema.ascii_composer.switch_key.behaviour
---@field Shift_L? rime_schema.ascii_composer.switch_key.behaviour
---@field Shift_R? rime_schema.ascii_composer.switch_key.behaviour
---@field Control_L? rime_schema.ascii_composer.switch_key.behaviour
---@field Control_R? rime_schema.ascii_composer.switch_key.behaviour
---@field Eisu_toggle? rime_schema.ascii_composer.switch_key.behaviour
---@alias rime_schema.ascii_composer.switch_key.behaviour
---| 'commit_code'
---| 'commit_text'
---| 'clear'
---| 'inline_ascii'
---| 'noop'
local rime_schema={
}