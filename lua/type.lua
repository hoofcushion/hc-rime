---@meta type
---@diagnostic disable: undefined-doc-name
---@class Candidate
---@field type string
---@field start number
---@field _end number
---@field quality number
---@field text string
---@field comment string
---@field preedit string
local CandidateReg={}
--- ShadowCandidate 衍生候选词，继承 Candidate 的所有属性。
---@class ShadowCandidate:Candidate
local ShadowCandidateReg={}
---@class Phrase:Candidate
---@field language Language
---@field preedit Preedit
---@field weight number
---@field code Code
---@field entry DictEntry
local PhraseReg={}
---@return Candidate
function PhraseReg:toCandidate() end
---@class UniquifiedCandidate:Candidate
local UniquifiedCandidateReg={}
--- 获取候选词的动态类型。
--- @return "Sentence"|"Phrase"|"Simple"|"Shadow"|"Uniquified"|"Other"
function CandidateReg:get_dynamic_type() end
--- 获取候选原型。
---@return Candidate
function CandidateReg:get_genuine() end
--- 获取候选原型列表。
---@return Candidate[]
function CandidateReg:get_genuines() end
--- 将候选词转换为 ShadowCandidate。
---@param type string
---@param text string
---@param comment string
---@param inherit_comment boolean|nil
---@return ShadowCandidate
function CandidateReg:to_shadow_candidate(type,text,comment,inherit_comment) end
--- 将候选词转换为 UniquifiedCandidate。
---@param type string
---@param text string
---@param comment string
---@return UniquifiedCandidate
function CandidateReg:to_uniquified_candidate(type,text,comment) end
--- 将候选词转换为 Phrase。
---@return Phrase
function CandidateReg:to_phrase() end
--- 将候选词转换为 Sentence。
---@return Sentence
function CandidateReg:to_sentence() end
--- 将候选词添加到 UniquifiedCandidate。
---@param item Candidate
---@return boolean
function CandidateReg:append(item) end
---@param type string 候选词的来源和类别标记
---@param start number 分词开始的位置
---@param _end number 分词结束的位置
---@param text string 候选词内容
---@param comment string 候选词的注释信息
---@return Candidate
function Candidate(type,start,_end,text,comment) end
--- ShadowCandidate 构造函数。
---@param cand Candidate
---@param type string
---@param text string
---@param comment string
---@param inherit_comment string|nil
---@return ShadowCandidate
function ShadowCandidate(cand,type,text,comment,inherit_comment) end
--- Phrase 构造函数。
---@param memory Memory
---@param type string
---@param start number
---@param _end number
---@param entry DictEntry
---@return Phrase
function Phrase(memory,type,start,_end,entry) end
--- UniquifiedCandidate 构造函数。
---@param cand Candidate
---@param type string
---@param text string
---@param comment string
function UniqifiedCandidate(cand,type,text,comment) end
--- 在翻译器中返回 Candidate。
---@param Candidate Candidate
function yield(Candidate) end
---@class Segmentation
---@field input string
---@field size integer
local SegmentationReg={}
--- 判断 Segmentation 是否为空。
---@return boolean
function SegmentationReg:empty() end
--- 获取 Segmentation 末尾的 Segment。
---@return Segment
function SegmentationReg:back() end
--- 移除 Segmentation 末尾的 Segment。
function SegmentationReg:pop_back() end
--- 重置 Segmentation 的输入。
---@param input string
function SegmentationReg:reset_input(input) end
--- 重置 Segmentation 的长度。
---@param length integer
function SegmentationReg:reset_length(length) end
--- 判断 Segmentation 是否已完成分词。
---@return boolean
function SegmentationReg:has_finished_segmentation() end
--- 获取当前 Segment 的开始位置。
---@return integer
function SegmentationReg:get_current_start_position() end
--- 获取当前 Segment 的结束位置。
---@return integer
function SegmentationReg:get_current_end_position() end
--- 获取当前 Segment 的长度。
---@return integer
function SegmentationReg:get_current_segment_length() end
--- 获取已确认 Segment 的位置。
---@return integer
function SegmentationReg:get_confirmed_position() end
--- 获取 Segments 列表。
---@return Segment[]
function SegmentationReg:get_segments() end
--- 获取指定索引处的 Segment。
---@param idx integer
---@return Segment|nil
function SegmentationReg:get_at(idx) end
---@class Segment
---@field start integer
---@field _start integer
---@field _end integer
---@field length integer
---@field status integer
---@field tags string[]
---@field menu Menu
---@field selected_index integer
---@field prompt string
local SegmentReg={}
--- 返回 Segment 的状态。
---@return "kVoid"|"kGuess"|"kSelected"|"kConfirmed"
function SegmentReg:get_status() end
--- 设置 Segment 的状态。
---@param status string
function SegmentReg:set_status(status) end
function SegmentReg:clear() end
--- 分割 Segment。
function SegmentReg:close() end
--- 复原 Segment。
---@param caret_pos integer
function SegmentReg:reopen(caret_pos) end
--- 返回 Segment 是否包含标签。
---@param tag string
---@return boolean
function SegmentReg:has_tag(tag) end
--- 获取指定索引处的候选词。
---@param idx integer
---@return Candidate|nil
function SegmentReg:get_candidate_at(idx) end
--- 获取选中的候选词。
---@return Candidate|nil
function SegmentReg:get_selected_candidate() end
---@param start_pos integer
---@param end_pos integer
---@return Segment
function Segment(start_pos,end_pos) end
---@class Translation
---@field exhausted boolean
local TranslationReg={}
---@return fun():Candidate
function TranslationReg:iter() end
--- Translation 构造函数。
---@return Translation
function Translation() end
---@class Switcher
---@field attached_engine Engine|nil
---@field user_config UserConfig
---@field active boolean
local SwitcherReg={}
function SwitcherReg:select_next_schema() end
--- @return boolean
function SwitcherReg:is_auto_save(option) end
function SwitcherReg:refresh_menu() end
function SwitcherReg:activate() end
function SwitcherReg:deactivate() end
---@param engine Engine
function Switcher(engine) end
---@class Menu
local MenuReg={}
--- 向菜单中添加翻译结果。
---@param translation Translation
function MenuReg:add_translation(translation) end
--- 准备指定数量的候选词。
---@param requested integer
function MenuReg:prepare(requested) end
--- 获取指定索引处的候选词。
---@param index integer
function MenuReg:get_candidate_at(index) end
--- 获取候选词数量。
---@return integer
function MenuReg:candidate_count() end
--- 返回菜单是否为空。
---@return boolean
function MenuReg:empty() end
--- Menu 构造函数。
--- @return Menu
function Menu() end
