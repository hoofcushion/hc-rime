---@meta type
---@param type string 候选词的来源和类别标记
---@param start number 分词开始的位置
---@param _end number 分词结束的位置
---@param text string 候选词内容
---@param comment string 候选词的注释信息
---@return Candidate
function Candidate(type,start,_end,text,comment) end
--- Candidate 类用于表示 Rime 输入法中的候选词。
---@class Candidate
---@field type string 候选词来源和类别标记
---@field start integer 编码开始位置
---@field _start integer 编码开始位置
---@field _end integer 编码结束位置
---@field quality number 结果展示排名权重
---@field text string 候选词内容
---@field comment string 候选词的注释信息
---@field preedit string 候选词预测码
local Candidate={}
--- 获取候选词的动态类型。
--- @return "Phrase"|"Simple"|"Shadow"|"Uniquified"|"Other"
function Candidate:get_dynamic_type() end
--- @return Candidate
function Candidate:get_genuine() end
--- @return table<number, Candidate>
function Candidate:get_genuines() end
---@return ShadowCandidate
function Candidate:to_shadow_candidate() end
---@return UniquifiedCandidate
function Candidate:to_uniquified_candidate() end
---@param cand Candidate
function Candidate:append(cand) end
--- Candidate 类用于表示 Rime 输入法中的候选词。
---@class ShadowCandidate:Candidate
---@param cand Candidate
---@param type string
---@param text string
---@param comment string
---@param inherit_comment string|nil
---@return ShadowCandidate
function ShadowCandidate(cand,type,text,comment,inherit_comment) end
---@class Phrase:Candidate
---@field language Language
---@field preedit Preedit
---@field weight number
---@field code Code
---@field entry DictEntry
local Phrase={}
---@return Candidate
function Phrase:toCandidate() end
---@param memory Memory
---@param type string
---@param start number
---@param _end number
---@param entry DictEntry
function Phrase(memory,type,start,_end,entry) end
---@class UniquifiedCandidate:Candidate
local UniquifiedCandidate={}
---@param cand Candidate
---@param type string
---@param text string
---@param comment string
function UniqifiedCandidate(cand,type,text,comment) end
